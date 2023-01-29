function posXYZ = cellsqrt(R,L,Nxy,Nz,pos,ori)
    %R = 2; %cm radius
    %L = 2; %cm height
    %Nxy = 16; % How many parts in square
    %Nz = 4;
    Xo=pos(1);
    Yo=pos(2);
    Zo=pos(3);
    aph1=ori(1);
    aph2=ori(2);
    aph3=ori(3);
    stepxy = R/sqrt(Nxy);  
    stepz = L/ Nz;
    if Zo>= 0 
        [X,Y,Z]=meshgrid(stepxy/2-R/2:stepxy:R/2-stepxy/2 , stepxy/2-R/2:stepxy:R/2-stepxy/2 , stepz/2:stepz:L-stepz/2);
    else
        [X,Y,Z]=meshgrid(stepxy/2-R/2:stepxy:R/2-stepxy/2 , stepxy/2-R/2:stepxy:R/2-stepxy/2 , -L+stepz/2:stepz:-stepz/2);
    end
    posXYZ = unique([X(:) Y(:) Z(:)], 'rows');
%shift to brain surface
    if aph1==0 & aph2==0
            fi = 0;
    else
        fi = aph2/aph1;
    end
    if Xo==0
        k=1;
    else
        k=-sign(aph1);
    end

    posXYZ=(posXYZ*roty(atan(sqrt(aph1^2+aph2^2)/aph3)*180/pi*k))*rotz(-atan(fi)*180/pi);
    posXYZ(:,1)=(posXYZ(:,1)+Xo);
    posXYZ(:,2)=(posXYZ(:,2)+Yo);
    posXYZ(:,3)=(posXYZ(:,3)+Zo);
    %scatter3(posXYZ(:,1),posXYZ(:,2),posXYZ(:,3))
    %xlim([-R/2 R/2]);
    %ylim([-R/2 R/2]);
    %zlim([0 L]);
end

