%% frw_inv_1av_nmor
% reconstructs the position of 10 different source dipole with the
% 100 different brain noises
% 
%
% OUTPUT:
%  loc1/2/3 - x,y,z location of the reconstructed sources(1x10 cells) each
%  cell includes result for all cell sizes
%  
%
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

function frw_inv_1av_nmor(mc)
 
raw_folder = '/rds/projects/j/jenseno-opm/fieldtrip-20200331'
addpath /rds/projects/j/jenseno-opm/fieldtrip-20200331


load('br_noise_all.mat')
load('dB_i_nmor.mat')
load('dipoles.mat')
load('nrm_dip.mat')

%%
Nsens=139;

[X,Y,Z,N_new] = mySphere(Nsens);

pos = [];
pos = unique([X(:) Y(:) Z(:)], 'rows');
pos = pos(pos(:,3)>=0,:);
elecori = pos;
chanpos = pos*0.093;    
clear opm 
opm=opmSens(3/1000,3/1000,1,1,chanpos,elecori);
opm.unit='m';

vol.r=[0.091];
vol.o=[0 0 0];
vol.unit = 'm';
vol.type = 'singlesphere';
vol.cond = [0.33];
headmodel = vol;

raw=[];
cfg=[];
cfg.headmodel = headmodel;        
cfg.grad = opm; 
cfg.dip.pos = [0 0 0.07];
cfg.dip.mom = [1 0 0];     
cfg.triallength =1;        % seconds
cfg.fsample = 1;
cfg.numtrl = 1;
raw = ft_dipolesimulation(cfg);
data=raw;



  
 %%  

for sori=1:1:10   
    load(['source_' num2str(sori)])
    % signal one trial 1 points
    data_source=[];
    Response_sens=[];
    source_all_tr=[];
    br_noise_trial=[];
    env_noise=100*10^(-15);
    for i=1:1:49
        for j=2:1:16
                       
            
            env_noise_trial=[];           
            env_noise_trial=randn(size(chanpos,1),1)*env_noise;
            
            intr_noise_trial=[];
            intr_noise_trial=randn(size(chanpos,1),1)*(dB_i(i,j-1)*5);
            source_all_tr=[];
            br_noise_trial=[];
            for jj=1:1:size(chanpos,1)        
                br_noise_trial(jj,1) = br_noise_all{mc,jj}(i,j-1)/5 ; 
                source_all_tr(jj,1)=source_all{jj,mc}(i,j-1);
            end
             
            
           
            data.trial{1,1} = source_all_tr+intr_noise_trial...
             + env_noise_trial+br_noise_trial;
         
         data.cfg.dip.pos=dipoles(sori,:);
         data.cfg.dip.mom=nrm_dip(sori,:);

         
        clear opm 

        opm=opmSens(j/1000,(i+1)/1000,j*j,i+1,chanpos,elecori);
        opm.unit='m';
        opm.tra=opm.tra./(j*j*(i+1)); 

        avg = ft_timelockanalysis([], data);
        cfg      = [];
        cfg.headmodel =headmodel;    % see above
        cfg.grad = opm;        % see above
        cfg.dip.pos = dipoles(sori,:);  % initial search position
        cfg.gridsearch = 'no';
        cfg.unit='m';
        cfg.senstype = 'meg';
        dip = ft_dipolefitting(cfg, avg);
        loc1{1,sori}(i,j)=dip.dip.pos(1);
        loc2{1,sori}(i,j)=dip.dip.pos(2);
        loc3{1,sori}(i,j)=dip.dip.pos(3);
            
        end
    end

end

    save(['loc1_nmor_ss_ne_100_'  num2str(mc)], 'loc1');
    save(['loc2_nmor_ss_ne_100_'  num2str(mc)], 'loc2');
    save(['loc3_nmor_ss_ne_100_'  num2str(mc)], 'loc3'); 
end

