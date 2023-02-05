% function number_sensors_20av_NMOR.m
%
% OUTPUT:
%  loc1/2/3 - x,y,z location of the reconstructed sources(1x10 cells) each
%  cell includes result for 100 brain noise sets for particular number of sensors in array (Nsens) 
%  For av=20 type of experiment
%
%
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk 

for Nsens=1:7

    load('dB_i_nmor.mat')
    load('dipoles.mat')
    load('nrm_dip.mat')
    load ('mesh_noise.mat') % noise dipoles position
    load ('nrm_noise.mat')  % noise dipoles orientation
    
    env_noise=25*10^(-15);
        
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

%%
    vol.r=[0.091];
    vol.o=[0 0 0];
    vol.unit = 'm';
    vol.type = 'singlesphere';
    vol.cond = [0.33];
    headmodel = vol;
    L=7; %mm optimal size from single sensor calculation
    D=17;
    
    % sensor placement without fluctuation in sensor position
    opm_old= opmSens(D/1000,L/1000,D*D,L,chanpos,elecori);
    opm_old.unit='m';
    
    % brain noise calculation
    sens_brain_noise=mc_noise_Nsens(N_desired(Nsens),mesh_noise,nrm_noise,L,D) ;  
    
    % create data structure appropriate for fieldtrip
    raw=[];
    cfg=[];
    cfg.headmodel = headmodel;        
    cfg.grad = opm_old; 
    cfg.dip.pos = [0 0 0.07];
    cfg.dip.mom = [1 0 0]';     
    cfg.triallength = 1;        % seconds
    cfg.fsample = 20;
    cfg.numtrl = 1;
    time        = repmat(1,1,20);
    cfg.dip.signal   = repmat({10*10^-9.*time},1,1);
    data = ft_dipolesimulation(cfg);
    
    % construct trial data - recostruct dipole position    
    for sori=[1 2 3 4 5 6 7 8 9 10]
     for mc=1:1:100         
        [chanpos_fluct,ori_fluct]=placement_fluct(chanpos)%introdusing fluctuation in sensor positions       
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

        ss = 1; 
            
        env_noise_trial=[]; % every mc new env_noise, different for each sensor in array          
        env_noise_trial=randn(size(chanpos,1),20)*env_noise;

        intr_noise_trial=[]; % every mc new intrinsic_noise, different for each sensor in array (coef=5 accounts for BW)
        intr_noise_trial=randn(size(chanpos,1),20)*(dB_i(6,16)*5);

        br_noise=[];  % every mc new brain noise, different for each of 20 time points (averages)                   
        rand_noise=randperm(100,20);
        for tt=1:20           
                br_noise_tmp = sens_brain_noise{1,rand_noise(tt)};            
                br_noise(:,tt) = (sum(br_noise_tmp,2)./5);
        end


        % constructiong data  
        data.trial{1,1} = lf+intr_noise_trial...
         + env_noise_trial+br_noise;

    %% reconstruction     
        avg = ft_timelockanalysis([], data);
        cfg      = [];
        cfg.headmodel =headmodel;   
        cfg.grad = opm_old;        % with ideal sensor position
        cfg.dip.pos = dipoles(sori,:); 
        cfg.gridsearch = 'no';
        cfg.unit='m';
        cfg.senstype = 'meg';
        dip = ft_dipolefitting(cfg, avg);
        loc1_1(mc,1)=dip.dip.pos(1);
        loc2_1(mc,1)=dip.dip.pos(2);
        loc3_1(mc,1)=dip.dip.pos(3);                                   
    end
    
    loc1{1,sori}=loc1_1;
    loc2{1,sori}=loc2_1;
    loc3{1,sori}=loc3_1;
end
 %%
 save(['loc1_' num2str(Nsens) '_20s_' num2str(env_noise*1e15)], 'loc1');
 save(['loc2_' num2str(Nsens) '_20s_' num2str(env_noise*1e15)], 'loc2');
 save(['loc3_' num2str(Nsens) '_20s_' num2str(env_noise*1e15)], 'loc3'); 
end

    