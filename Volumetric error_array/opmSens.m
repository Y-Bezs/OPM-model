%% opmSens 
% 
%  opmSens that creates a cloud of points to represent a cell with a specified length, width, and location.
% The function takes in several input arguments:

% R: the radius of the cell
% L: the length of the cell, in number of points
% Nxy: the number of points in a cross-section of the cell
% Nz: the number of points along the length of the cell
% pos: a 3-element vector that specifies the location of the cell center point
% ori: a 3-element vector that specifies the sensing axis of the cell
%
% The function returns an output structure called opmSens, which contains information about the cell's position, orientation, and labels for each point in the cloud. The output structure has the following fields:

% coilpos: an Nx3 matrix that contains the x, y, and z coordinates of each point in the cloud
% coilori: an Nx3 matrix that contains the x, y, and z components of the sensing axis at each point in the cloud
% tra: a 1xN vector that contains the location of each point in the cloud, relative to the cell center
% unit: a string that specifies the unit of measurement for the coordinates (in this case, 'm')
% label: a cell array of strings that contains a label for each point in the cloud (in this case, 'OPM001', 'OPM002', etc.)
% chanunit: a cell array of strings that specifies the unit of measurement for each channel (in this case, 'T')
% chantype: a cell array of strings that specifies the channel type (in this case, 'megmag')
% chanpos: an Nx3 matrix that contains the x, y, and z coordinates of each channel in the cloud
% chanori: an Nx3 matrix that contains the x, y, and z components of the sensing axis at each channel in the cloud.  
% 
%
% OUTPUT:
%  location of points that represents a cell.
%
% Note: opmSens output structure contains all the information necessary to model the response of a sensor 
% that is located near the cloud of points.
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
