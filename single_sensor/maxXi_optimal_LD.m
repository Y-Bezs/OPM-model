%%maxXi_optimal_LD 
% calculates the optimal dipole length, dipole width, and Xi as a function of residual noise and depth of the dipole. 
% The calculation includes results from calculating brain noise and ECD signal for each cell dimension. 
% The optimal values are calculated by scanning through all possible LxD combinations and finding the maximum Xie (Fig.2)
%
% 
%
% OUTPUT:
%  optimal 1-length/2-width/3-Xi as a function of residual noise(rho) Depth of the dipole(delta) 
%   1-rho_delta_lngth_nmor/serf(dd,kk)=L(1,i);
%   2-rho_delta_width_nmor/serf(dd,kk)=D(j,1);
%   3-rho_delta_snr_nmor/serf(dd,kk)=val;  
%
%Note: the calculatuion include results from calculation brain noise (eq.5) and ECD signal (eq.6) for
%each cell dimention 
%
% The code first sets some parameters for the L and W values. 
% Then, it loads data for the ECD signal and brain noise for each cell size. 
% It constructs signals for each cell size from values for points of clouds representing the biggest cell.
%
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk


%% parameters

Lstrart=2/1000;
Lfinish=50/1000;
L=Lstrart:1/1000:Lfinish; %m

Wstart=2/1000;
Wfinish=20/1000;
W=Wstart:1/1000:Wfinish;

%% Load signal data and brain noise data

FileName   = 'Response_even.mat';
FolderName = 'Calculate_ECD_signal';
File       = fullfile(FolderName, FileName);
load(File); 
Resp_even=Response;


FileName   = 'Response_odd.mat';
FolderName = 'Calculate_ECD_signal';
File       = fullfile(FolderName, FileName);
load(File);
Resp_odd=Response;


FileName   = 'all_noise_odd.mat';
FolderName = 'Calculate_brain_noise';
File       = fullfile(FolderName, FileName);
load(File); 
FileName   = 'all_noise_even.mat';
FolderName = 'Calculate_brain_noise';
File       = fullfile(FolderName, FileName);
load(File);

% construct signals for each cell size from values for points of clouds
% representing biggest cell

load('mask.mat') % ai - masks to extract the cell with given size


    
 for i=2:1:50
    for j=2:2:20 
        for dep=1:1:31
            v=numel(Resp_even(dep,ia{i-1,j}));
            signal{1,dep}(i-1,j-1)=sum(Resp_even(dep,ia{i-1,j}))./v;
        end
         br_noise_old(i-1,j-1)=sum(all_noise_even(dep,ia{i-1,j}))./(j*j*i);
        for mc=1:200
            v=numel(Resp_even(dep,ia{i-1,j}));
            br_noise_tmp{1,mc}(i-1,j-1)=sum(all_noise_even(mc,ia{i-1,j}))./v;
        end
    end
    for j=3:2:19 
        for dep=1:1:31
            v=numel(Resp_even(dep,ia{i-1,j}));
            signal{1,dep}(i-1,j-1)=sum(Resp_odd(dep,ia{i-1,j}))./v;
        end
        br_noise_old(i-1,j-1)=sum(all_noise_odd(dep,ia{i-1,j}))./(j*j*i);
        for mc=1:200
            v=numel(Resp_even(dep,ia{i-1,j}));
            br_noise_tmp{1,mc}(i-1,j-1)=sum(all_noise_odd(mc,ia{i-1,j}))./v;
        end
    end
 end

% rms of the brain noise
for l=1:49
    for w=1:19
        for mc=1:200
            tmp(mc)=br_noise_tmp{1,mc}(l,w);
        end
        br_noise(l,w)=rms(tmp);
    end
end

%
Noise_env=[];
temp = [0:1:50];
Noise_env=temp*10^(-15);

%% interpolation for more values
clear L D S_dip
load('dB_i_nmor.mat')
[L,D]=meshgrid(2:0.1:50,2:0.1:20);
L_list=2:1:50;
D_list=2:1:20;

dB_int=interp2(D_list,L_list,dB_i,D,L,'cubic');
N_b=interp2(D_list,L_list,br_noise,D,L,'cubic');
for dep=1:31
    S_dip{1,dep}=interp2(D_list,L_list,signal{1,dep},D,L,'cubic');
end
%% NMOR
% calculating actual sensitivity (rms of all the noises)
% brain noise initially calculated for 1nAm - in the model we use 0.2 nAm
% BW of the measurements is 25 Hz therefore dB_i*sqrt(BW)=dB_i*5 (fT/sqrtHz->fT)
sens = [];
for env=1:1:numel(Noise_env)    
    sens{1,env} = sqrt(Noise_env(env)^2+(N_b./5).^2.+(dB_int*5).^2);    %(br_noise./5).^2    
end


%% SNR, Lopt,Dopt for each depth and enviromental noise
sens_new=[];
ind=[];
kk=1;
msen=[];
for k=1:1:51
    dd=1;
    for dep=9:1:30
        sens_tmp = S_dip{1,dep}./sens{1,k}; %SNR with fixed Ne and depth of the dipole
        
        val=max(sens_tmp(:)); 
        [i,j]=find(sens_tmp'==val,1);

        rho_delta_lngth(dd,kk)=L(1,i);
        rho_delta_width(dd,kk)=D(j,1);
        rho_delta_snr(dd,kk)=val;        
        dd=dd+1;
    end
    kk=kk+1;
end  

%% same for serf
load('dB_i_serf.mat')
dB_int_serf=interp2(D_list,L_list,dB_i_serf,D,L,'cubic');

sens = [];
for env=1:1:numel(Noise_env)   
    sens{1,env} = sqrt(Noise_env(env)^2+(dB_int_serf*5).^2.+(N_b./5).^2.);  %  
end


ind=[];
kk=1;
sens_tmp=[];
for k=1:1:51
    dd=1;
    for dep=9:1:30
        sens_tmp = S_dip{1,dep}./sens{1,k};
        
        val=max(sens_tmp(:)); 
        [i,j]=find(sens_tmp'==val,1);

        rho_delta_lngth_serf(dd,kk)=L(1,i);
        rho_delta_width_serf(dd,kk)=D(j,1);
        rho_delta_snr_serf(dd,kk)=val;  
        dd=dd+1;
    end
kk=kk+1;
end 

%% example of plotting
figure(1)
set(figure(1),'Position',[96 96 344 300]);
clf;
contourf(2.1:0.1:4.2,0:0.2:10,rho_delta_lngth'/10,'LineColor','none')%,'ShowText','on')

colormap(pink(11))
c=colorbar;
colorbar('off')
caxis([0.2 1.3])

ylabel('$N_{e} / \sqrt{BW} (fT/ \sqrt{Hz}$ )','interpreter','latex','FontSize',30,'FontWeight','bold')
%xticks([])
%xticks([1 2 5 10 50 100 200 500])
xticklabels([])
title('NMOR')
set(gca,'fontsize',12,'FontWeight','bold','LineWidth',1.5,'TickDir','both')
