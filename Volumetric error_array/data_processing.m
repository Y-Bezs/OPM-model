% calculates volumetric error for each cell size - Xi
Nsens=139;
Nsen=69;
type=21;
k=1;
std_tmp1=[];
    std_tmp2=[];
    std_tmp3=[];
    std_all=[];
%for type = [5 2 4 3]
%mc=[1:55,58:200]
load('dipoles.mat')
for sori=[1,2,3,4,5,6,7,8,10]  
    local1=[];
    local2=[];
    local3=[];
    mc1=1;
    mc2=1;
    mc3=1;
    for mc=1:100
        
        load(['loc1_serf_ss_ne_100_'   num2str(mc) '.mat']);
        

        load(['loc2_serf_ss_ne_100_'   num2str(mc) '.mat']);
        

        load(['loc3_serf_ss_ne_100_'  num2str(mc) '.mat']);
       
        for i=1:1:49
            for j=2:1:16 
                if norm([loc1{1,sori}(i,j) loc2{1,sori}(i,j) loc3{1,sori}(i,j)])<0.08
                    tmp1{i,j-1}(mc)=loc1{1,sori}(i,j);
                    tmp2{i,j-1}(mc)=loc2{1,sori}(i,j);
                    tmp3{i,j-1}(mc)=loc3{1,sori}(i,j);
                else
                   tmp1{i,j-1}(mc)=nan; 
                   tmp2{i,j-1}(mc)=nan; 
                   tmp3{i,j-1}(mc)=nan; 
                    
                end                
%                 tmp2{i,j-1}(mc)=loc2{1,sori}(i,j);
%                 tmp3{i,j-1}(mc)=loc3{1,sori}(i,j);
            end
        end
        
    end
     
     
    
   % std_tmp11{1,sori}=cellfun(@std,tmp1);
   % std_tmp12{1,sori}=cellfun(@std,tmp2);
   % std_tmp13{1,sori}=cellfun(@std,tmp3);
%     for l=1:49
%         for w=1:15
%             std_tmp11{1,sori}(l,w)=std(tmp1{l,w});
%             std_tmp12{1,sori}(l,w)=std(tmp2{l,w});
%             std_tmp13{1,sori}(l,w)=std(tmp3{l,w});
%         end
%     end
    
     for l=1:49
         for w=1:15
             tmp1{l,w} = tmp1{l,w}(~isnan(tmp1{l,w}));
             tmp2{l,w} = tmp2{l,w}(~isnan(tmp2{l,w}));
             tmp3{l,w} = tmp3{l,w}(~isnan(tmp3{l,w}));
             std_tmp11{1,sori}(l,w)=rms(tmp1{l,w}-dipoles(sori,1));
             std_tmp12{1,sori}(l,w)=rms(tmp2{l,w}-dipoles(sori,2));
             std_tmp13{1,sori}(l,w)=rms(tmp3{l,w}-dipoles(sori,3));
         end
     end
    
    
   
   
end  

for ss=[1,2,3,4,5,6,7,8,10]  
    for i=1:1:49
        for j=1:1:15       
            std_all{1,ss}(i,j)=norm([std_tmp11{1,ss}(i,j) std_tmp12{1,ss}(i,j) std_tmp13{1,ss}(i,j)]);  
        end
    end
end

vol_err=[];
mid_step=[];
    for i=1:1:49
        for j=1:1:15 
            a=1;
            for ss=[1 2 3 4 5 6 7 8 10]  
                mid_step(a)=std_all{1,ss}(i,j);
                a=a+1;
            end
            vol_err(i,j)=mean(mid_step);
            %mid_step=[];
        end
    end

% %%
% for ss=1:1:10
%     check(ss)=std_all{1,ss}(7,3)
% end

Length=0.2:0.1:5;
Diam=0.2:0.1:1.6;
figure(1)
%set(figure(1),'Position',[96 96 336 336]);
contourf(Diam,Length,vol_err*10^3)

%colormap(spring(6))
c=colorbar;
%colorbar('off')
caxis([0 17])
%xlabel('R_{head} - r_{0}   (cm)','FontSize',24,'FontWeight','bold')
xlabel('D (cm)','FontSize',12,'FontWeight','bold')
ylabel('L (cm)','FontSize',12,'FontWeight','bold')

%xticks([1 2 5 10 50 100 200 500])
%xticklabels({'0','2', '5', '10', '50', '100', '200', '500'})
%colormap(hot(24))
c.Label.String = '\sigma (mm)';
%c.XTick=[0.2:0.5:2.7];

set(gca,'fontsize',12)
%%
Length=0.2:0.1:5;
Diam=0.2:0.2:1.6;
figure
contourf(Diam,Length,vol_err*10^3)

%colormap(jet(12))
c=colorbar;
%colorbar('off')
caxis([4 7])
%xlabel('R_{head} - r_{0}   (cm)','FontSize',24,'FontWeight','bold')
xlabel('D (cm)','FontSize',24,'FontWeight','bold')
ylabel('L (cm)','FontSize',24,'FontWeight','bold')

%xticks([1 2 5 10 50 100 200 500])
%xticklabels({'0','2', '5', '10', '50', '100', '200', '500'})
%colormap(hot(24))
c.Label.String = '\sigma_{vol} (mm)';
c.XTick=[2.4:0.4:4.8];

set(gca,'fontsize',25)


%%
L=0.2:0.2:5;
figure(1)
box on
hold on
scatter(L,vol_error_5(1:2:50).*10^3,100, 'filled', 'k')
scatter(L,vol_error_21.*10^3,100, 'filled', 'r')
hold off
xlabel('L (cm)') 
ylabel('\sigma (mm)')
xlim([0.2 5])
legend ('\rho_{env}' , '\rho_{env}+\rho_{brain}')
legend boxoff


set(gca,'fontsize',18)

%%


for i=1:1:99
    a=[error_int1(i) error_int2(i) error_int3(i)];
    b=[std_tmp1(i) std_tmp2(i) std_tmp3(i)];
    error_int(i)=norm(loc - a);
    std_all_int(i)=mean(b);
end

figure(4)
y = error_int*10^3; % your mean vector;
x = 0.2:0.1:10;
std_err=std_all_int*1e3;
curve1 = y + std_err;
curve2 = y - std_err;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'g');
hold on;
plot(x, y', 'r', 'LineWidth', 2);
xlim([0.2 10])
%ylim([-0.8 0.5])
xlabel('L (cm)')
ylabel('localization error (mm)')
title('int,env.noise 50fT/ depth 2.1cm')
%title('int,env.noise 50fT + brain 0.17nAm/ depth 2.1cm')
set(gca,'fontsize',18)

figure(5)
plot(x,std_err, 'LineWidth' ,3)
xlabel('L (cm)')
ylabel('volumetric error (mm)')
xlim([0.2 10])
title('int,env.noise 50fT/ depth 2.1cm')
%title('int,env.noise 50fT + brain 0.17nAm/ depth 2.1cm')
set(gca,'fontsize',18)

figure(6)
plot(x,y, 'LineWidth' ,3)
xlabel('L (cm)')
ylabel('localization error (mm)')
xlim([0.2 10])
title('int,env.noise 50fT/ depth 2.1cm')
%title('int,env.noise 50fT + brain 0.17nAm/ depth 2.1cm')
set(gca,'fontsize',18)

%%
k=1;
for i=[40 100 226 280]       
        load(['min_err_' num2str(i) '.mat']);
        all_err(k,:)=min_err;
        k=k+1;
end 

figure(2)
y = all_err.*10^3;
x = [20 58 100 156];
hold on;
plot(x, y,'-o', 'LineWidth', 2);
hold off
xlim([20 160])
xlabel('Number of sensors in array')
ylabel('volumetric error (mm)')
legend ('\deltaB_{env}=5ft', '\deltaB_{env}=50fT', '\deltaB_{br}(0.2nAm)+50ft' ,'\deltaB_{br}(0.3nAm)+50ft' )
set(gca,'fontsize',18)
%%
figure(3)
y = total.*10^3;
x = 0.2:0.1:10;
hold on;
plot(x, y,'-o', 'LineWidth', 2);
hold off
set(gca, 'YScale', 'log')
xlabel('Number of sensors in array')
ylabel('Normalized volumetric error (mm)')
legend ('\deltaB_{env}=5ft', '\deltaB_{env}=50fT', '\deltaB_{br}(0.2nAm)+50ft' ,'\deltaB_{br}(0.3nAm)+50ft' )
set(gca,'fontsize',18)
