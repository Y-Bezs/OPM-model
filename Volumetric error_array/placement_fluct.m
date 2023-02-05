% function placement_fluct.m
%
% OUTPUT:
%  pos_fluct, ori_fluct  - posinions of the sensors and their orientation
%  shifted and tilled randomly
%
%
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk 

function [pos_fluct, ori_fluct]=placement_fluct(chanpos)
    temp=size(chanpos);
    loc_fluct_xy=(rand(temp(1),2,1)-0.5).*0.01;
    loc_fluct_z=rand(temp(1),1,1)*0.004;
    loc_fluct=[loc_fluct_xy loc_fluct_z];
    chanpos1=chanpos+loc_fluct;        
    tmp=vecnorm(chanpos1');
    for kl=1:1:temp(1)
        newori(kl,:)=chanpos1(kl,:)/tmp(kl);
    end
    ori_fluct_xyz=(rand(temp(1),3,1)-0.5).*2*0.155;
    newori1=newori+ori_fluct_xyz;        
    tmp=vecnorm(newori1');
    for kl=1:1:temp(1)
        newori2(kl,:)= newori1(kl,:)/tmp(kl);
    end
    pos_fluct = chanpos1;
    ori_fluct = newori2;
end