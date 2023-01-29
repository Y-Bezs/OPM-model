%% opmSens 
% Create a cloud of points that represents a cell with length L(Nz number of points) 
% width D(Nxy number of points in a cross-section DxD) 
% Cell sensing axis is ori,
% location of the cell center point (center of the cross-ssection closer to the head) - loc  
% 
%
% OUTPUT:
%  location of points that represents a cell.
%
%Note: averaging magnetic field around these points yeilds the sensor's
%response
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk

function opmSens=opmSens(R,L,Nxy,Nz,pos,ori)

    opm=[];
    tra=[];
    coilori=[];
    posXYZ=[];
    Nchan = size(pos,1);
    Nxy=round(Nxy);
    Nz=round(Nz);
    line=zeros(round(Nxy*Nz*Nchan),1)';

%%  opm
    for i=1:Nchan
        row=line;
        for j=((i-1)*Nxy*Nz+1):1:(Nxy*Nz*i)
            row(j)=1;
        end
        if i==1

            posXYZ= cellsqrt(R,L,Nxy,Nz,pos(i,:),ori(i,:));
            coilori=repmat(ori(i,:),[Nxy*Nz 1]);
            tra=row;
        else
            posXYZ = cat(1,posXYZ,cellsqrt(R,L,Nxy,Nz,pos(i,:),ori(i,:)));
            coilori=cat(1,coilori,repmat(ori(i,:),[Nxy*Nz 1])); 
            tra=cat(1,tra,row);
        end
    end
    
    opm.coilpos=posXYZ; 
    opm.coilori=coilori;
    opm.tra=tra;
    opm.unit='m'; 
    for k=1:length(coilori)
         opm.label{k} = sprintf('OPM%03d', k);
         opm.chanunit{k} = 'T';
         opm.chantype{k}= 'megmag';
    end
    opm.chantype = opm.chantype';
    opm.chanpos=opm.coilpos;
    opm.chanori=opm.coilori; 
opmSens=opm;
end
