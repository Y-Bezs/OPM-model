%%intrinsic_sens_nmor calculates the intrinsic noise of the NMOR single beam sensor.
%
% output dB_i - the values of intrinsic noise for NMOR as a function of
% length and width (LxW) of the vapour cell
%
% The main steps of the code are:
%
% 1. Define the range of lengths and widths of the cell to explore.
% 2. Calculate the spin-exchange, wall collision, and light-induced relaxation rates, and from them, the width of the resonance.
% 3. Calculate the atomic-shot noise and photon-shot noise.
% 4. Calculate the intrinsic sensitivity as the square root of the sum of the atomic-shot and photon-shot noises.
% 5. Plot the intrinsic noise as a function of the length and width of the cell.
%
%Note: one can explore dB_i as a fuction of any parameter in the model in
%similar way it's done here for cell volume (LxW)
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

%% parameters of the model

Lstrart=2/1000; %Lower limit of the length [m]
Lfinish=50/1000; %Upper limit of the length [m] 
L=Lstrart:1/1000:Lfinish; %m

Wstart=2/1000;  %Lower limit of the width [m]
Wfinish=20/1000;  %Upper limit of the width [m]
W=Wstart:1/1000:Wfinish;


m = 87*1.66*10^(-27);  % atomic mass Rb87
T = 22; % Temperature of the cell
Vthermal = sqrt(1.38*10^(-23)*8*(T + 273)/m); %[m/sec]
sSE = 2*10^(-14)*10^(-4); % spin exchange collision cross-section [m2]
gamma = 7*10^9*2*pi; %gyromagnetic ratio [Hz/T]
nai = 8.5*10^9*10^(6); % atomic number density [num/m^3]
crossec = W.^2; % cell cross0-section [m]
h = 1.054*10^(-34); % plank C

fr=377*10^12; %frequency of the pumping light
Iph=7*10^(-6)/(2*10^-6); %pump beam intensity [W/m^2]
kv=10^(-23); %microscopic absorption cross-section [m^2]

%% calculating width of the resonance

%spin-exchange collision relaxation rate
relother = sSE*Vthermal*nai*sqrt(2)*0.2; 

%wall collision relaxation rate
A=L'*W*4.+2*crossec; %cell shape factor
relwall = 1/10000*Vthermal*(A)./(4*L'*crossec);

%light-induced relaxation rate
int_part=[];
s=1;

for L1=Lstrart:1/1000:Lfinish
int_part(s)=integral(@(x)exp(-kv*nai*x),0,L1);
s=s+1;
end

Imean=Iph*int_part./L;
rellight= repmat((2*kv/(h*fr).*Imean)',1,length(W));

%width (HWHM) of the resonance
Width_sensor=rellight+relother+relwall;


%sanity check 
figure(1)
plot(L*100 ,Width_sensor(:,9),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\gamma ,Hz','FontSize',24,'FontWeight','bold')
xlim([0.2 5])
set(gca,'fontsize',18)

%% atomic-shot noise

dB_atm = 1/gamma.*sqrt(Width_sensor./(L'*crossec.*nai));

figure(2)
plot(L*100 ,dB_atm(:,9)*10^(15),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{atm} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.2 5])
set(gca,'fontsize',18)

%% photon-shot noise

h = 1.054*10^(-34);
pow=7*10^(-6);
Amp=0.6*10^(-3);

dB_phsh=1/gamma*1/2*sqrt(h*fr/(pow)).*Width_sensor./Amp;

figure(3)
plot(L*100 ,dB_phsh(:,9)*10^(15),'LineWidth',3)
xlabel('length of the cell (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{ph} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.2 5])
set(gca,'fontsize',18)
%% intrinsic sensitivity ft/sqrtHz

dB_i=sqrt(dB_phsh.^2+dB_atm.^2);

figure(4)
plot(L*100 ,dB_i(:,9)*10^(15),'LineWidth',3)
xlabel('L (cm)','FontSize',24,'FontWeight','bold')
ylabel('\delta B_{i} (10^{-15} T)','FontSize',24,'FontWeight','bold')
xlim([0.2 5])
set(gca,'fontsize',18)

save dB_i_nmor dB_i
%% plot

imagesc(L*100,W*100,dB_i.*10^15)
colorbar
xlabel('Length')
ylabel('diameter')
