

%Nsens=[20 25 30 40 35 50 55 60 65 70 90 95 105 110 135 140 145 150 155 160 165 190 225 230 235 240 245 250 255 260 265 270 275 280];
%Nsens=[30 40 50 60 70 90 105 110 135 140 150 160 175 190 225 230 240 250 260 270  280];
%Nsens=[50 90 135 140 150 190 225 232 250 272 280 320 346 380]

N=1:1000;
area=4*pi./N;
distance=sqrt(area);
M_theta_raw=pi./distance;
M_theta_desired=5:2:17;
N_desired=round(interp1(M_theta_raw,N,M_theta_desired));
Nsens=N_desired;
load('../dipoles.mat')
std_1=[];
std_2=[];
std_3=[];
std_whole=[];
ns=[];
std_Nsens=[];
k=1;
for i=1:1:7
%    name = [num2str(Nsens(i))];
     name = [num2str(i)]; 
     load(['loc1_' name '_20s.mat']);
     load(['loc2_' name '_20s.mat']);
     load(['loc3_' name '_20s.mat']);
     int=1;
     
     for sori=[1 2 3 4 5 6 7 8 10]
         f=1;
         ind=[];
         for mc=1:100
            if norm([loc1{1,sori}(mc) loc2{1,sori}(mc) loc3{1,sori}(mc)])<0.08
                ind(f)=mc;
                f=f+1;
            end
         end
        % reconstruction error
        std_1(int)=rms(loc1{1,sori}(ind)-dipoles(sori,1));
        std_2(int)=rms(loc2{1,sori}(ind)-dipoles(sori,2));
        std_3(int)=rms(loc3{1,sori}(ind)-dipoles(sori,3));
        std_whole(int)=norm([std_1(int),std_2(int),std_3(int)]);
        int=int+1;
     end

    err(k)=std(std_whole);    
    std_Nsens(k)=mean(std_whole);
    [X,Y,Z,N_new] = mySphere(Nsens(i));
    pos = [];
    pos = unique([X(:) Y(:) Z(:)], 'rows');
    pos = pos(pos(:,3)>=-eps,:);
    ns(k)=size(pos,1);
    k=k+1;
end

% just checking
plot(ns(2:end),std_Nsens(2:end)*10^3)

