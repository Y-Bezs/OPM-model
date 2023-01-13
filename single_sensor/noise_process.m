%% sum all 1000 dipoles
all_noise_odd=[]; 
for i=1:1:100
        name = [ 'noise_mc_new_' num2str(i)];
        %name = [ num2str(type)]        
        load([ name  '.mat']);
        all_noise_odd(i,:)= sum(sens_brain_noise,2);
      
       
end
%% go to the right folder!
all_noise_even=[]; 
for i=1:1:100
        name = [ 'noise_mc_new_' num2str(i)];
        %name = [ num2str(type)]        
        load([ name  '.mat']);
        all_noise_even(i,:)= sum(sens_brain_noise,2);
      
       
end
 %% check the brain noise level
 
 std_noise_even=std(all_noise'); 
 std_noise_odd=std(all_noise_odd');

 for i=2:1:50
    for j=2:2:20 
        br_noise(i-1,j-1)=std(sum(all_noise_even(:,ia{i-1,j}),2)./(j*j*i));
    end
    for j=3:2:20 
        br_noise(i-1,j-1)=std(sum(all_noise_odd(:,ia{i-1,j}),2)./(j*j*i));
    end
 end

 figure()
 L=2:1:50;
 plot(L,br_noise(:,9)*10^(15))
 

