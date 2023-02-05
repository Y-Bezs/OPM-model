%function process(b)
% function process_noise_for_Etot_calculation.m
%
% OUTPUT:
%  dipole1000_all_new - 1000x69 cell array/ each cell 49x15 - brain noise for each cell dimentions
%  rearrenges the noise for Etot calculation. 
%  Instead of 100 mc variation, creates time course of brain noise    
%  
%
%
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk
WAITBAR=waitbar(0);
for mc=1:1:10
    for i=1:1:3       
        name1=[num2str(i)]; % '_odd'];
        FolderName1 = ['.\' name1 '\'];    
        load([FolderName1 'noise_mc_even_1_' num2str(mc) '.mat'])
        %load([FolderName 'noise_mc_even_2_' num2str(mc) '.mat'])
        for chan=(1+23*(i-1)):1:(23*i)
            %noise_chan_odd{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
            FolderName = '\to_server\double_opt_array\mask_69\';
            name = [ FolderName 'ai_channel_' num2str(chan)];
            load([ name  '.mat'])
            tmp=sens_noise_1{1,chan};  
            waitbar((chan/69),WAITBAR,[num2str(mc) ' out of 10 ']);
            for dd=1:1:500                                      
                dipole_even=tmp(:,dd)';               
                for l=1:1:49
                    for w=1:1:8
                        dipole_even_lw{dd,chan}(l,w)=(sum(dipole_even(:,ia_ch{l,w}),2)./((2*w)*(2*w)*(l+1)));                                     
                    end
                end
            end  
        end
        clear sens_noise_1 tmp
        load([FolderName1 'noise_mc_even_2_' num2str(mc) '.mat'])
        for chan=(1+23*(i-1)):1:(23*i)
            %noise_chan_odd{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
            FolderName = '\to_server\double_opt_array\mask_69\';
            name = [ FolderName 'ai_channel_' num2str(chan)];
            load([ name  '.mat'])
            tmp=sens_noise_2{1,chan};   
            waitbar((chan/69),WAITBAR,[num2str(mc) ' out of 10 ']);
            for dd=501:1:1000                                      
                dipole_even=tmp(:,dd-500)';
                for l=1:1:49
                    for w=1:1:8
                        dipole_even_lw{dd,chan}(l,w)=(sum(dipole_even(:,ia_ch{l,w}),2)./((2*w)*(2*w)*(l+1)));                                     
                    end
                end
            end   
            
        end 
        clear sens_noise_2 tmp
    end   
   save(['dipole_even_lw_new_' num2str(mc)], 'dipole_even_lw', '-v7.3');
   clear dipole_even_lw dipole_even
   
end
close(WAITBAR);    
%%
WAITBAR=waitbar(0);
for mc=1:1:10

    for i=1:1:3       
        name1=[num2str(i) '_odd'];
        FolderName1 = ['.\' name1 '\'];    
        load([FolderName1 'noise_mc_even_1_' num2str(mc) '.mat'])
        %load([FolderName 'noise_mc_even_2_' num2str(mc) '.mat'])
        for chan=(1+23*(i-1)):1:(23*i)
            %noise_chan_odd{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
            FolderName = '\to_server\double_opt_array\mask_69\odd\';
            name = [ FolderName 'ai_channel_odd' num2str(chan)];
            load([ name  '.mat'])
            tmp=sens_noise_1{1,chan};  
            waitbar((chan/69),WAITBAR,[num2str(mc) ' out of 10 ']);
            for dd=1:1:500                                      
                dipole_odd=tmp(:,dd)';               
                for l=1:1:49
                    for w=1:1:7
                        dipole_odd_lw{dd,chan}(l,w)=(sum(dipole_odd(:,ia_ch{l,w}),2)./((2*w+1)*(2*w+1)*(l+1)));                                     
                    end
                end
            end  
        end
        clear sens_noise_1 tmp
        load([FolderName1 'noise_mc_even_2_' num2str(mc) '.mat'])
        for chan=(1+23*(i-1)):1:(23*i)
            %noise_chan_odd{1,chan}(mc,:)=sum([sens_noise_1{1,chan} sens_noise_2{1,chan}],2)';
            FolderName = '\to_server\double_opt_array\mask_69\odd\';
            name = [ FolderName 'ai_channel_odd' num2str(chan)];
            load([ name  '.mat'])
            tmp=sens_noise_2{1,chan};   
            waitbar((chan/69),WAITBAR,[num2str(mc) ' out of 10 ']);
            for dd=501:1:1000                                      
                dipole_odd=tmp(:,dd-500)';
                for l=1:1:49
                    for w=1:1:7
                        dipole_odd_lw{dd,chan}(l,w)=(sum(dipole_odd(:,ia_ch{l,w}),2)./((2*w+1)*(2*w+1)*(l+1)));                                     
                    end
                end
            end   
            
        end 
        clear sens_noise_2 tmp
    end   
   save(['dipole_odd_lw_new_' num2str(mc)], 'dipole_odd_lw', '-v7.3');
   clear dipole_odd_lw dipole_odd
end
close(WAITBAR);    

%%
WAITBAR=waitbar(0);
for mc=1:1:10
    waitbar((mc/10),WAITBAR,[num2str(mc) ' out of 10 ']);
    load(['dipole_even_lw_' num2str(mc) '.mat'])
    load(['dipole_odd_lw_new_' num2str(mc) '.mat'])
    for ch=1:1:69
    for dd=1:1:1000
    for lg=1:1:49
        w1=1;
        w2=1;
        for w=1:1:15
            if rem(w,2)==1
                dipole1000_all_new{dd,ch}(lg,w)=dipole_even_lw{dd,ch}(lg,w1);
                w1=w1+1;
            else
                dipole1000_all_new{dd,ch}(lg,w)=dipole_odd_lw{dd,ch}(lg,w2);
                w2=w2+1;
            end
        end
    end 
    end
    end
    
    save(['dipole1000_all_new_' num2str(mc)], 'dipole1000_all_new', '-v7.3');    
end
close(WAITBAR);    

%%
