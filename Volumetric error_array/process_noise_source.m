%% process_noise_source 
% calculates brain nose and magnetic field from ECD(source) for each cell
% in the array
% 
%
% OUTPUT:
%  br_noise_all 100X69 cell array with 100 different noise sets and sensors' tilts for array of
%  69 sensors incide the cell results for different cell sizes
%  source_1(2,3,4,5,6,7,9,10) - 69x100 cell array 100 different sensors' tilts for array of
%  69 sensors incide the cell results for different cell sizes
%
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

for k=1:1:69
         FolderName = '.\mask_69\odd\';
         name = [ FolderName 'ai_channel_odd' num2str(k)];
         load([ name  '.mat']);

         for i=1:1:49
             for j=1:1:7
                 tmp=(sum(noise_chan_odd{1,k}(:,ia_ch{i,j}),2)./((2*j+1)*(2*j+1)*(i+1)));
                 for mc=1:1:100
                     all_noise_br_odd{mc,k}(i,j)=tmp(mc);
                 end
             end
         end  
 
%          FolderName = '.\sourse\even\';
%          name = [FolderName 'source_data_' num2str(k)];
%          load([ name  '.mat']);
%          source_even=source_data;

         FolderName = '.\sourse\even\';
         name = [FolderName 'source_data_odd_' num2str(k)];
         load([ name  '.mat']);
        
         for mc=1:1:100
         %for ss=1:1:10

             for i=1:1:49                
                 for j=1:1:7
                     source_dt_odd_1{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},1))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_2{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},2))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_3{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},3))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_4{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},4))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_5{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},5))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_6{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},6))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_7{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},7))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_8{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},8))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_9{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},9))./((2*j+1)*(2*j+1)*(i+1));
                     source_dt_odd_10{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},10))./((2*j+1)*(2*j+1)*(i+1));
                 end
             end
         %end
          end
       
end

for k=1:1:69
         FolderName = '.\mask_69\';
         name = [ FolderName 'ai_channel_' num2str(k)];
%         %name = [ num2str(type)]        
          load([ name  '.mat']);
          for i=1:1:49
               for j=1:1:7
                   tmp=(sum(noise_chan_odd{1,k}(:,ia_ch{i,j}),2)./((2*j+1)*(2*j+1)*(i+1)));
                   for mc=1:1:100
                   all_noise_br_odd{mc,k}(i,j)=tmp(mc);
                   end
               end
          end          
%          FolderName = '.\sourse\even\';
%          name = [FolderName 'source_data_' num2str(k)];
%          load([ name  '.mat']);
%          source_even=source_data;

         FolderName = '.\sourse\even\';
         name = [FolderName 'source_data_' num2str(k)];
         load([ name  '.mat']);
        
         for mc=1:1:100
         %for ss=1:1:10

             for i=1:1:49                
                 for j=1:1:8
                     source_dt_even_1{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},1))./((2*j)*(2*j)*(i+1));
                     source_dt_even_2{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},2))./((2*j)*(2*j)*(i+1));
                     source_dt_even_3{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},3))./((2*j)*(2*j)*(i+1));
                     source_dt_even_4{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},4))./((2*j)*(2*j)*(i+1));
                     source_dt_even_5{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},5))./((2*j)*(2*j)*(i+1));
                     source_dt_even_6{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},6))./((2*j)*(2*j)*(i+1));
                     source_dt_even_7{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},7))./((2*j)*(2*j)*(i+1));
                     source_dt_even_8{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},8))./((2*j)*(2*j)*(i+1));
                     source_dt_even_9{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},9))./((2*j)*(2*j)*(i+1));
                     source_dt_even_10{k,mc}(i,j)=sum(source_data{1,mc}(ia_ch{i,j},10))./((2*j)*(2*j)*(i+1));
                 end
             end
         %end
          end
       
end

%%

for mc=1:1:100
    for ch=1:1:69

for lg=1:1:49
    w1=1;
    w2=1;
for w=1:1:15
    if rem(w,2)==1
        br_noise_all{mc,ch}(lg,w)=all_noise_br_even{mc,ch}(lg,w1);
        w1=w1+1;
    else
        br_noise_all{mc,ch}(lg,w)=all_noise_br_odd{mc,ch}(lg,w2);

        w2=w2+1;
    end
end
end 
    end
end

save(['br_noise_all')],'br_noise_all');
%%
for i=1:1:200
    for j=1:1:100
        tmp=(16*16*50*(j-1)+1):(16*16*50*(j));
        noise_all{1,i}(tmp)=noise_chan{1,j}(i,:);
    end
end

%%
for k=1:1:200
    for i=2:1:50
        for j=2:2:16
            br_noise{i-1,j}(:,k)=sum(noise_all{1,k}(ia{i-1,j}))/(j*j*i);
        end
    end
end

%%

        br_noise_std=cellfun(@std,br_noise);
    for i=1:1:8
        br_noise_ready(:,i)=br_noise_std(:,i*2)/5;
    end

 %% 
 br_n_std_w=[];
 br_n_std_l=[];
for k=1:1:100
    for ch=1:1:69
    for j=1:1:15
            br_n_std_w{j}(k,ch)=br_noise_all{k,ch}(1,j)/5;
    end
    for i=1:1:49
            br_n_std_l{i}(k,ch)=br_noise_all{k,ch}(i,1)/5;
    end
    
    end
end
tmp_w=[];
tmp_l=[];
for j=1:1:15
    tmp_w(j)=std((mean(br_n_std_w{j},2)))
end

for i=1:1:49
    tmp_l(i)=(std(mean(br_n_std_l{i},2)))
end

%%
for ss=1:1:10
    %load(['source_dt_even_' num2str(ss)])
    %load(['source_dt_odd_' num2str(ss)])
for ch=1:1:69
    for mc=1:1:100
      switch ss
        case 1
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_1{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_1{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_1{ch,mc}(:,8);
        case 2
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_2{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_2{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_2{ch,mc}(:,8);
                case 3
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_3{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_3{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_3{ch,mc}(:,8);
                case 4
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_4{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_4{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_4{ch,mc}(:,8);
                case 5
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_5{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_5{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_5{ch,mc}(:,8);
                case 6
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_6{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_6{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_6{ch,mc}(:,8);
                case 7
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_7{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_7{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_7{ch,mc}(:,8);
                case 8
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_8{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_8{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_8{ch,mc}(:,8);
                case 1
        for j=1:1:9         
                source_all{ch,mc}(:,2*j-1)=source_dt_even_9{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_9{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_9{ch,mc}(:,8);
                case 10
        for j=1:1:7          
                source_all{ch,mc}(:,2*j-1)=source_dt_even_10{ch,mc}(:,j)           
                source_all{ch,mc}(:,2*j)=source_dt_odd_10{ch,mc}(:,j)           
        end
        source_all{ch,mc}(:,15)=source_dt_even_10{ch,mc}(:,8);
        
      end
    end
end
save(['source_' num2str(ss)],'source_all');
end



