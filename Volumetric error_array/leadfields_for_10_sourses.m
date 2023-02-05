%% leadfields_for_10_sources
% calculates magnetic field fo source #Ns for evenpoints in a biggest cells
% for each sensors in the array 
% 
%
% OUTPUT:
%  source_data_odd/even - 11250/12800x100 odd/even points of the biggest cell 
%  for 100 different sensors' tilts
%  
%
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk
function sourse_all(Ns)

load ('dipoles.mat')
load ('nrm_dip.mat')
load ('chanori.mat') %to synchronize location fluctuation for brain noise and ECD
load ('chanpos.mat')


vol.r =[0.08 0.091];
vol.o = [0 0 0];      % center of sphere
vol.unit = 'm';
vol.type = 'singlesphere';
vol.cond = [0.33 0.33];
headmodel = vol;
source_data=[];

[X,Y,Z,N_new] = mySphere(139);
pos = [];
pos = unique([X(:) Y(:) Z(:)], 'rows');
pos = pos(pos(:,3)>=0,:);
elecori = pos;
   
    
    
    r=1;
    %% 
    for mc=1:1:100
    for k=10:-1:1  
        % calculation for odd points, to calculate even points do 16x16x50
        clear opm 
        opm=opmSens(15/1000,50/1000,15*15,50,chanpos{1,mc}(Ns,:),chanori{1,mc}(Ns,:)); 
        opm.tra=eye(15*15*50);
        opm.unit='m';
 %%   
        cfg                = [];
        cfg.grad           = opm;
        cfg.headmodel      = headmodel;
        cfg.sourcemodel.inside = 1;
        cfg.dipoleunit = 'A*m';
        cfg.unit           = 'm';
        cfg.sourcemodel.pos     = dipoles(k,:);
        lf_noise  = ft_prepare_leadfield(cfg);
        source_data{1,mc}(:,k) =10^(-8)*lf_noise.leadfield{1,1}*nrm_dip(k,:)';
  
        r=r+1;
    end
    end
 save(['source_data_odd_' num2str(Ns)], 'source_data');
end
