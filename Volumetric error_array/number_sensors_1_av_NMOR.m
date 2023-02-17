% function number_sensors_1av_NMOR.m
%
%function that takes as input the number of sensors in the array and outputs the reconstructed x, y, z coordinates of the sources for 100 brain noise sets.
%
% OUTPUT:
%  loc1/2/3 - x,y,z location of the reconstructed sources(1x10 cells) each
%  cell includes result for 100 brain noise sets for particular number of sensors in array (Nsens) 
%  For av=1 type of experiment
%
% The code loads precalculated data for brain noise and dipole positions, 
% calculates the ideal sensor positions based on the number of sensors, 
% creates trial data by reconstructing dipole position and adding noise, 
% and then reconstructs the dipole location
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk 

function number_sensors_1_av_NMOR(Nsens)

    load('dB_i_nmor.mat')
    load('dipoles.mat')
    load('nrm_dip.mat')
    load ('mesh_noise.mat')  % noise dipoles position
    load ('nrm_noise.mat')   % noise dipoles orientation

    % correct sensor placement
     N=1:1000;
     area=4*pi./N;  
     distance=sqrt(area);
     M_theta_raw=pi./distance;
     M_theta_desired=5:2:17;
     N_desired=round(interp1(M_theta_raw,N,M_theta_desired));   
     [X,Y,Z,N_new] = mySphere(N_desired(Nsens));
     pos = unique([X(:) Y(:) Z(:)], 'rows');
     pos = pos(pos(:,3)>=-eps,:);
     elecori = pos;
     chanpos = pos*0.093;  
     clear opm 

    vol.r=[0.091];
    vol.o=[0 0 0];
    vol.unit = 'm';
    vol.type = 'singlesphere';
    vol.cond = [0.33];
    headmodel = vol;
    
    L=7; %mm optimal size from single sensor calculation
    D=17; %mm
    
    sens_brain_noise=mc_noise_Nsens(N_desired(Nsens),mesh_noise,nrm_noise,L,D); % brain noise calculation   
        
    opm_ideal= opmSens(D/1000,L/1000,D*D,L,chanpos,elecori); % for ideal leadfields
    opm_ideal.unit='m';
    
    % create data structure appropriate for fieldtrip
    raw=[];
    cfg=[];
    cfg.headmodel = headmodel;        
    cfg.grad = opm_ideal; 
    cfg.dip.pos = [0 0 0.07];
    cfg.dip.mom = [1 0 0]';     
    cfg.triallength =1;        % seconds
    cfg.fsample = 1;
    cfg.numtrl = 1;
    raw = ft_dipolesimulation(cfg);
    
    env_noise=25*10^(-15);
    % construct trial data - recostruct dipole position    
    for sori=[1 2 3 4 5 6 7 8 9 10]       
        for mc=1:100        
            [chanpos_fluct,ori_fluct]=placement_fluct(chanpos);%introdusing fluctuation in sensor positions
            opm=[];
            opm=opmSens(D/1000,L/1000,D*D,L,chanpos_fluct,ori_fluct);
            opm.unit='m';
        
            % signal from ECD
            cfg                     = [];
            cfg.headmodel           = headmodel;
            cfg.sourcemodel.inside  = 1;
            cfg.dipoleunit          = 'A*m';
            cfg.unit                = 'm';
            cfg.sourcemodel.pos     = dipoles(sori,:);
            cfg.grad           = opm; 
            lf_prep = ft_prepare_leadfield(cfg);
            lf = 1e-8*lf_prep.leadfield{1,1}*nrm_dip(sori,:)';       
        
            env_noise_trial=[]; % every mc new env_noise, independent for sensors, same for length          
            env_noise_trial=randn(size(chanpos,1),1)*env_noise;
             
            intr_noise_trial=[]; % every mc new intrinsic_noise, independent for sensors, scales with length 
            intr_noise_trial=randn(size(chanpos,1),1)*(dB_i(6,16)*5);
        
            br_noise=[];  % every mc new brain noise, correlated for sensors, scales with length       
            br_noise_tmp = sens_brain_noise{1,mc};            
            br_noise = sum(br_noise_tmp,2)./5;

            % constructiong data
            data=lf+intr_noise_trial+env_noise_trial+br_noise;
            raw.trial{1,1}=data;
            
            % reconstruction
            avg = ft_timelockanalysis([], raw);
            cfg      = [];
            cfg.headmodel =headmodel;   
            cfg.grad = opm_ideal;        % with ideal sensor position
            cfg.dip.pos = dipoles(sori,:);  
            cfg.gridsearch = 'no';
            cfg.unit='m';
            cfg.senstype = 'meg';
            dip = ft_dipolefitting(cfg,avg);
            loc1_1(mc,1)=dip.dip.pos(1);
            loc2_1(mc,1)=dip.dip.pos(2);
            loc3_1(mc,1)=dip.dip.pos(3);                                   
        end    
    loc1{1,sori}=loc1_1;
    loc2{1,sori}=loc2_1;
    loc3{1,sori}=loc3_1;
end
 %%
 save(['loc1_' num2str(Nsens) '_ss_' num2str(env_noise*1e15)], 'loc1');
 save(['loc2_' num2str(Nsens) '_ss_' num2str(env_noise*1e15)], 'loc2');
 save(['loc3_' num2str(Nsens) '_ss_' num2str(env_noise*1e15)], 'loc3'); 
end

    
