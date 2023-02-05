%% mc_noise(mc) 
%%calculates magnetic field from randomly distributed 1000 ECD representing
%%brain noise at the odd/even points of the biggest cells in
%%the array of 69 sensors
% 
%
% OUTPUT:
%  mc_noise(n) - magnetic field from ECD at the specific ponts from the
%  cloud of points representing sensors in the array
%
%Note: the calculatuion include value of optimal angle between
%sensor-center of sphere-ECD
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

function mc_noise(mc)

raw_folder = '/rds/projects/j/jenseno-opm/to_server/input';
addpath /rds/projects/j/jenseno-opm/fieldtrip-20200331
addpath /rds/projects/j/jenseno-opm/to_server/input

load ('mesh_noise.mat')  % locations of the ECDs
load ('nrm_noise.mat')   % orientation of the ECDs

% create locations of the cells in array of 69 sensors
Nsens=139;
vol.r = [0.08 0.091];
vol.o = [0 0 0];      % center of sphere
vol.unit = 'm';
vol.type = 'singlesphere';
vol.cond = [0.33 0.33];
headmodel = vol;

[X,Y,Z,~] = mySphere(Nsens);
pos1 = [];
pos1 = unique([X(:) Y(:) Z(:)], 'rows');
pos1 = pos1(pos1(:,3)>=0,:);
sens_noise = [];

for ns=1:1:13 %monte-carlo iterations 
    % prepare the orientations(sensing axis) of the sensors 
    pos=[];
    pos=pos1(ns,:);
    elecori = pos; 

    k=1;
    noise=[];
    noise=mesh_noise{1,mc};
    nrm_n=nrm_noise{1,mc};
    noise_br=[];
    
    dist=93/1000; % distance of the array sphere to the center of the head
    
    [chanpos1,newori]=placement_fluct(chanpos) %introdusing fluctuation in sensor positions

    
    % create the array of sensors with the biggest cells (even points)     
    clear opm 
    opm=opmSens(16/1000,50/1000,16*16,50,chanpos1,newori2);
    opm.tra=eye(16*16*50*2);
    %odd points
    %opm=opmSens(15/1000,50/1000,15*15,50,pos,ori);
    %opm.tra=eye(15*15*50);
    opm.unit='m';
    
    cfg                = [];
    cfg.grad           = opm;
    cfg.headmodel      = headmodel;
    cfg.sourcemodel.inside = ones(length(noise),1);
    cfg.dipoleunit = 'A*m';
    cfg.unit           = 'm';
    cfg.sourcemodel.pos     = noise; 
    lf_noise  = ft_prepare_leadfield(cfg);
%%% brain noise
    Nnoise = length(noise);


    for i=1:1:Nnoise
        sens_noise{1,ns}(:,i) =10^(-9)*lf_noise.leadfield{1,i}*nrm_n(i,:)';
    end
      
end
     save(['noise_mc_even_' num2str(mc)], 'sens_noise');
end
