% function Etot_SERF_NMOR.m
%
% OUTPUT:
%  answer_full - 49x15 array of Etot for each cell sizes / the ability of the array to reconstruct the 
%  temporal waveform of a dipolar source using a beamformer analysis   
%  
%
%
% More details in paper:
% https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk 

% change to calculate results for NMOR/SERF

%load('dB_i_nmor.mat')
load('dB_i_serf.mat')
dB_i=dB_i_serf;

load('dipoles.mat')
load('nrm_dip.mat')

N=69;  % optimal number of sensors  

WAITBAR=waitbar(0);
for sori=1:1:9%10
    waitbar((sori/10),WAITBAR,[num2str(sori) ' out of 10 ']);
    load(['source_' num2str(sori)])
    load(['dipole1000_all_new_' num2str(sori) '.mat']) % created to construct 1000 random data points
    mc=sori; % done so fluctuation in the sensors positions would be the same for ECD and br_noise
    %%
    for i=1:1:49 % Length of the cell
        for j=1:1:15 % width of the cell
            %% time course tale
            % for source
            n_sample=10000; 
            t_sample=1:n_sample;
            q=sin(2*pi*0.0002*t_sample)*1e-8;
            Q=rms(q,2);
    
            % for intrinsic noise 5 is BW
            b_sensor_noise=dB_i(i,j)*5*randn(N,n_sample);
            
            % for brain noise
            q_brain_noise=0.2e-9*randn(1000,n_sample);
            Q_brain_noise=rms(q_brain_noise,2);
            for dd=1:1:1000
                for ch=1:1:69
                    brain_noise_lf(ch,dd)=dipole1000_all_new{dd,ch}(i,j)/1e-9;
                end    
            end
            % 0,2nAm for brain dipoles   
            b_brain_noise=brain_noise_lf*(0.2e-9*randn(1000,n_sample));
            
            % for brain noise Gaussian  
            for jj=1:1:69               
                b_source(jj,:)=source_all{jj,mc}(i,j).*q/1e-8;
                l(jj,1)=source_all{jj,mc}(i,j)*1e8;                
            end
            
            C_brain_noise=0;
            for dd=1:1:1000
                    C_brain_noise=C_brain_noise+Q_brain_noise(dd)^2*brain_noise_lf(:,dd)*brain_noise_lf(:,dd)';
            end

                
            % for enviromental noise
            env_noise=25e-15;
            b_env_noise=env_noise*randn(N,n_sample);
            
            %% all in all
            
            b_brainNoiseOn=b_source+b_sensor_noise+b_brain_noise+b_env_noise;
            b_brainNoiseOff=b_source+b_sensor_noise+b_env_noise;
            %% covariances
            
            C_source=Q^2*(l*l');

            C_env_noise=v^2*eye(N);
            C_sensor_noise=(dB_i(i,j)*5)^2*eye(N);                        
          
           % C_br_noise_exp=cov(b_brain_noise.');
            %% Beamform
            b=b_brainNoiseOn;           
            C=C_source+C_sensor_noise+C_brain_noise+C_env_noise;
            
            %b=b_brainNoiseOff; 
            %C=C_source+C_sensor_noise+C_env_noise;
            iC=inv(C);
            omega_transpose_full=(l'*iC)/(l'*iC*l);
            q_hat_full=omega_transpose_full*b;
            answer(i,j)=rms(q_hat_full-q);
        end
    end
    answer_full{1,sori}=answer;
end

save(['Etot_new_right_nmor_ne_' num2str(env_noise*1e15) '_dB_10' num2str(mc)],  'answer_full', '-v7.3');
Length=0.2:0.1:5;
Diam=0.2:0.1:1.6;
close(WAITBAR);
%%
Length=0.2:0.1:5;
Diam=0.2:0.1:1.6;
answer=zeros(49,15);
for sori=[1 2 3 5 6 10]
    answer = answer + answer_full{1,sori}
end
%%
figure
contourf(Diam,Length,answer*1e9)
colorbar
xlabel('D')
ylabel('L')
title(['E tot (Ne=' num2str(env_noise*1e15 'fT)'])
