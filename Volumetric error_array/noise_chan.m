%% rearrenge brain noise data
for mod=1:1:2
    for mc=1:1:100
        for i=1:1:3
            if mod==1
                name=[num2str(i)] % '_odd'];
            else
                name=[num2str(i)]  '_odd'];
            end
            FolderName = ['.\' name '\'];    
            load([FolderName 'noise_mc_even_1_' num2str(mc) '.mat'])
            load([FolderName 'noise_mc_even_2_' num2str(mc) '.mat'])
            for chan=(1+23*(i-1)):1:(23*i)
                %noise_chan_odd{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
                tmp=[sens_noise_1{1,chan} sens_noise_2{1,chan}];
                for dd=1:1:1000
                    noise_chan{dd,chan}(mc,:)=tmp(:,dd)';
                end

            end
        end
    end
    if mod==1
        save noise_chan_even noise_chan
    else 
        save noise_chan_odd noise_chan
    end
end
%save noise_chan_odd noise_chan_odd
%%
pp=1/84;
%waitbar(pp,'saving..') 
for mc=85:1:100
  
    load(['noise_mc_even_1_' num2str(mc) '.mat'])
    load(['noise_mc_even_2_' num2str(mc) '.mat'])
    for chan=47:1:69
        noise_chan{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
    end
    
end

