Steps:
1) Calculate brain noise
		a. leadfields from 1000 dipoles 200 times 
			-run mc_noise
		b. to combine sum results from 1000 dipoles 
			-run noise_process 
2) Calculate lf from the ECD
		-run Rersponce_even
		-run Rersponce_odd
3) To calculate intrinsic noise as a function of length and width
		-run intrinsic_noise_serf
		-run intrinsic_noise_nmor
4) To calculaate SNR for optimal length and width
		-run maxXi_optimal_LD
		
The details of this pipeline can be found in the referenced paper.
https://doi.org/10.1016/j.neuroimage.2022.119747.
%
% Author Yulia Bezsudnova
% yxb968@student.bham.ac.uk
