Steps:
1)calculate brain noise
	in brain noise folder
		a)run mc_noise
		b)run noise_chan
		c)run process_noise_source
2)calculate lf from 10 soursces
	in Source(ECD) folder
	`	a)run leadfields_for_10_sourses
		b)run process_noise_source
3)to do sourse localization 
		a)run frw_inv_1av_nmor
		b)run frw_inv_20av_nmor
4)calculate volumetric error
	run data_processing


the same steps for serf (change intrinsic noise)
