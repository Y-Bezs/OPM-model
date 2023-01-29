%%mc_noise(n) calculates magnetic field from randomly distributed 1000 ECD representing brain
%%noise at the odd/even
%%points of the biggest cell
% 
%
% OUTPUT:
%  mc_noise(n) - magnetic field from ECD at the sspecific ponts from the
%  cloud of points representing sensor
%
%Note: the calculatuion include value of optimal angle between
%sensor-center of sphere-ECD
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

function mc_noise(n)

%%
vol.r = [0.088 0.091];
vol.o = [0 0 0];      % center of sphere
vol.unit = 'm';
vol.type = 'singlesphere';
vol.cond = [0.33 0.33];
headmodel = vol;

 noise=[];
 load('mesh_noise')
 load('nrm_noise')

    mesh_noise1=[];
    nrm_noise1=[];
    mesh_noise1 = mesh_noise{1,n};
    nrm_noise1 = nrm_noise{1,n};
    noise_br=[];
 
    
        dist=93/1000;
        clear opm 
        opm=SensCS(dist,19/1000,50/1000); %opm=SensCS(dist,20/1000,50/1000);
        opm.tra=eye(18050);
        opm.unit='m';
    
        cfg                = [];
        cfg.grad           = opm;
        cfg.headmodel      = headmodel;
        cfg.sourcemodel.inside = ones(length(mesh_noise1),1);
        cfg.dipoleunit = 'A*m';
        cfg.unit           = 'm';
        cfg.sourcemodel.pos     = mesh_noise1;
        lf_noise  = ft_prepare_leadfield(cfg);

        Nnoise = length(mesh_noise1);
        sens_noise = [];
   
        for i=1:1:Nnoise
            sens_noise(:,i) =10^(-9)*lf_noise.leadfield{1,i}*nrm_noise1(i,:)';
        end

        sens_brain_noise = sens_noise;


save(['noise_mc_new_' num2str(n) ], 'sens_brain_noise');
end
