% function mc_noise_Nsens.m
%
% OUTPUT: 
%       sens_brain_noise - brain noise for particular number of sensors in array
%           1x100 array of cells, each cell contains results for all cell dimentions 
%  
%
%
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk 

function sens_brain_noise=mc_noise_Nsens(Nsens,mesh_noise,nrm_noise,L,D)

    vol.r = [0.08 0.091];
    vol.o = [0 0 0];      % center of sphere
    vol.unit = 'm';
    vol.type = 'singlesphere';
    vol.cond = [0.33 0.33];
    headmodel = vol;

    [X,Y,Z,N_new] = mySphere(Nsens);
    pos = [];
    pos = unique([X(:) Y(:) Z(:)], 'rows');
    pos = pos(pos(:,3)>=-eps,:);
    elecori = pos;

    k=1;
    noise=[];
    
    for tr=1:1:100
        noise=mesh_noise{1,tr}; % take trial
        nrm_n=nrm_noise{1,tr};
        noise_br=[];
        dist=93/1000;
        chanpos = pos*dist;   
       
        [chanpos_fluct,ori_fluct]=placement_fluct(chanpos);%introdusing fluctuation in sensor positions
        opm=opmSens(D/1000,L/1000,D*D,L,chanpos_fluct,ori_fluct);
        opm.unit='m';

        cfg                = [];
        cfg.grad           = opm;
        cfg.headmodel      = headmodel;
        cfg.sourcemodel.inside = ones(length(noise),1);
        cfg.dipoleunit = 'A*m';
        cfg.unit           = 'm';
        cfg.sourcemodel.pos     = noise;
        lf_noise  = ft_prepare_leadfield(cfg);        
        Nnoise = length(noise); % brain noise
        sens_noise = [];
        for i=1:1:Nnoise
            sens_noise(:,i) =10^(-9)*lf_noise.leadfield{1,i}*nrm_n(i,:)';
        end
        sens_brain_noise{1,k} = sens_noise;
        k=k+1;
    end
end