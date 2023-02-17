%%Responce_even(n) 
% calculates the magnetic field from ECD at the odd points(cross-section) of the biggest cell
% 
%
% OUTPUT:
%  Response_even - magnetic field from ECD at the sspecific ponts from the
%  cloud of points representing sensor
%
%Note: the calculatuion include value of optimal angle between
%sensor-center of sphere-ECD
%
% Then, for each depth between 5cm and 8cm, 
% the function creates a new ECD with the same orientation and amplitude but with a position at the specified depth, 
% and calculates the leadfield for a sensor cloud ("Sensor") of even points representing the sensor. 
%
%More details in paper:
%https://doi.org/10.1016/j.neuroimage.2022.119747.
%
%Author Yulia Bezsudnova
function Responce_even()

lf=[];
lf_prep=[];
Response=[];
vol.r = [0.080 0.091];
vol.o = [0 0 0];      % center of sphere
vol.unit = 'm';
vol.type = 'singlesphere';
vol.cond = [0.33 0.33];
headmodel = vol;
%%
load('phi_whole.mat') %angle for maximazing signal for each ECD depth
%Source
a0=80/1000; % r-position of ECD
%phi=0.1222;
phi=0.0022; % starting
source.pos=[a0*cos(phi),a0*sin(phi),0];
source.ori=[0,0,1];
source.amp=10*10^(-9);

%Response
cfg                     = [];
cfg.headmodel           = headmodel;
cfg.sourcemodel.inside  = 1;
cfg.dipoleunit          = 'A*m';
cfg.unit                = 'm';
cfg.sourcemodel.pos     = source.pos;
k=1;
s=1;
l=1;
a=3;
    for depth=80/1000:-1/1000:50/1000
    
        if depth<0 
            a0=0;
        else
            a0=depth;
        end
        tmp=round(81-a0*1000)        
        source.pos=[a0*cos(phi_whole(tmp)),a0*sin(phi_whole(tmp)),0];
        cfg.sourcemodel.pos     = source.pos;    
        lf_prep=[];
        Sensor=SensCS((90+a)/1000,20/1000,50/1000); %% clounds of even points representing the sensor
        cfg.grad           = Sensor; 
        lf_prep = ft_prepare_leadfield(cfg);
        lf = source.amp*lf_prep.leadfield{1,1}*source.ori';       
        Response(l,:)=lf;   
        l=l+1;
    end
    save('Response_even', 'Response')
end

