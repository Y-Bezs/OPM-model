%% parameters of the model

Lstrart=2/1000;
Lfinish=50/1000;
L=Lstrart:1/1000:Lfinish; %m

Wstart=2/1000;
Wfinish=20/1000;
W=Wstart:1/1000:Wfinish;


m = 87*1.66*10^(-27);
T = 22;
Vthermal = sqrt(1.38*10^(-23)*8*(T + 273)/m); %m/sec
sSE = 2*10^(-14)*10^(-4); %m2
gamma = 7*10^9*2*pi; %hz/T
nai = 8.5*10^9*10^(6); %num/m^3
crossec = W.^2; %m
h = 1.054*10^(-34); %m

fr=377*10^12;
Iph=7*10^(-6)/(2*10^-6);
kv=10^(-23);

%% calculating width of the resonance

% spin-exchange collision
relother = sSE*Vthermal*nai*sqrt(2)*0.2;
A=L'*W*4.+2*crossec;
relwall = 1/10000*Vthermal*(A)./(4*L'*crossec);
int_part=[];
s=1;

% light induced relaxation
for L1=Lstrart:1/1000:Lfinish
int_part(s)=integral(@(x)exp(-kv*nai*x),0,L1);
s=s+1;
end

Imean=Iph*int_part./L;

rellight= repmat((2*kv/(h*fr).*Imean)',1,length(W));

Width_sensor=rellight+relother+relwall;

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