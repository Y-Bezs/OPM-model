%%intrinsic_sens_serf calculates the intrinsic noise of the SERF single beam sensor.
%
% output dB_i - the values of intrinsic noise for NMOR as a function of
% length and width (LxW) of the vapour cell
%
%Note: one can explore dB_i as a fuction of any parameter in the model in
%similar way it's done here for cell volume (LxW)
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
%More comments in *intrinsic_sens_nmor.m*
% Author Yulia Bezsudnova

%% parameters of the model
Lstrart=2/1000; % Length of cell
Lfinish=50/1000;
L=Lstrart:1/1000:Lfinish; %m

Wstart=2/1000; % Width of the cell
Wfinish=20/1000;
W=Wstart:1/1000:Wfinish; %m

m = 87*1.66*10^(-27);
T = 450;
Vthermal = sqrt(1.38*10^(-23)*8*(T + 273)/m); %m/sec
sSE = 2*10^(-14)*10^(-4); %m2
gamma = 7*10^9*2*pi; %hz/T
%mu_b=927.400*10^(-26);

h = 1.054*10^(-34);
gammae=1.7*10^(11)/(2*3/2+1); %the gyromagnetic ratio of a bare electron.

R= W./2; %m
h = 1.054*10^(-34); %m

fr=377*10^12;
Iph=0.5*10^(-3)/(10^-4); %pump beam intensity [W/m^2]
kv=10^(-23); %microscopic absorption cross-section [m^2]
crosssec=W.*W; %m
Iph=0.5*10^(-3)/(10^-4);
n_ai = 10^(14) * 10^6;

%% constants for spin-destruction collisions (eq. A.2.5)
s_self = 1.6*10^(-17)*10^(-4); %m2

p_bg = 600; %Torr
s_bg = 9*10^(-24)*10^(-4); %m2

M_bg = 20*1.66*10^(-27);
m_bg_rb = (1/M_bg+1/m)^(-1);
V_bg = sqrt(1.38*10^(-23)*8*(T + 273)/m_bg_rb);

p_q = 20; %Torr
s_q = 10^(-22)*10^(-4); %m2

M_q = 14*1.66*10^(-27);
m_q_rb = (1/M_bg+1/m)^(-1);
V_q = sqrt(1.38*10^(-23)*8*(T + 273)/m_q_rb);

%% spin-destraction

rel_sd_self = 1/4*s_self*n_ai*sqrt(2)*Vthermal;

n_bg = 2.68*10^(25)*p_bg/760;
rel_sd_bg = 1/4*s_bg*V_bg*n_bg;

n_q = 2.68*10^(25)*p_q/760;
rel_sd_q = 1/4*s_q*V_q*n_q;

rel_sd = rel_sd_self+rel_sd_bg+rel_sd_q;

%% wall collision

Do = 0.2*10^(-4); %m2/s shape factor
rel_wall = Do.*760./p_bg.*(2.4^2./R.^2+pi^2./L'.^2);

%% light-induced relaxation

int_part=[];
s=1;

for L1=2/1000:1/1000:50/1000
int_part(s)=integral(@(x)exp(-kv*n_ai*x),0,L1);
s=s+1;
end

Imean=Iph*int_part./L;

rellight= 2*kv/(h*fr).*Imean;

%% width (HWHM) of the resonance

width_serf = rel_wall + repmat(rel_sd,49,19)+rellight(1);

figure(1)
plot(L*100 ,2*width_serf(:,9),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\gamma ,Hz','FontSize',24,'FontWeight','bold')
xlim([0.5 5])
set(gca,'fontsize',18)

%% atomic-shot noise


dB_atm = 4/gammae.*sqrt(2.*width_serf./(L'*crosssec*n_ai));

figure(2)
plot(L*100 ,dB_atm*10^(15),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{atm} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.5 5])
set(gca,'fontsize',18)

%% photon-shot noise


pow=Iph*10^(-4);
gammae=2*mu_b/h*2*pi;
dB_phsh=4/gammae*sqrt(h*fr/(pow)).*width_serf;

figure(3)
plot(L*100 ,dB_phsh*10^(15),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{ph} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.5 5])
set(gca,'fontsize',18)
%% intrinsic sensitivity ft/sqrt(Hz)

dB_i_serf=sqrt(dB_phsh.^2+dB_atm.^2);

figure(4)
imagesc(dB_i_serf)
colorbar
%plot(L*100 ,dB_i_serf*10^(15),'LineWidth',3)
xlabel('L (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{i} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.5 5])
set(gca,'fontsize',18)

save dB_i_serf dB_i_serf