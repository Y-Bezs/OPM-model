% creates masks to extract smaller-size sensors array from the araay with biggest cell
function create_mask(ns)

raw_folder = '/rds/projects/j/jenseno-opm/to_server/input';
addpath /rds/projects/j/jenseno-opm/fieldtrip-20200331
addpath /rds/projects/j/jenseno-opm/to_server/input

Nsens=139;

[X,Y,Z,N_new] = mySphere(Nsens);
pos1 = [];
pos1 = unique([X(:) Y(:) Z(:)], 'rows');
pos1 = pos1(pos1(:,3)>=0,:);
 sens_noise = [];
 hj=1;
%for ns=1:1:50
    pos=[];
    chanpos=pos1(ns,:);
    elecori = chanpos;

    k=1;
    noise=[];
    dist=93/1000;
    
   
      
    clear opm 
    opm_all=opmSens(16/1000,50/1000,16*16,50,chanpos,elecori);
    
    for i=2:1:50
     for j=2:2:16
        tmp=opmSens(j/1000,i/1000,j*j,i,chanpos,elecori);                
            
                originals=opm_all.chanpos;
                tmp1=tmp.chanpos;
                
                [~,ia_ch{i-1,j/2},ib]=intersect(round(originals,4),round(tmp1,4),'rows');
            
           
      end
    end
%end

save(['ai_channel_' num2str(ns)], 'ia_ch');
end
     
     
