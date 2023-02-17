# OPM-MEG system in realistic conditions 
# This code was used to calulating results for the paper 
#
# Optimising the sensing volume of OPM sensors for MEG source reconstruction
# https://doi.org/10.1016/j.neuroimage.2022.119747
# 
# The model can be used as a toolkit for optimising OPM-MEG systems in a wide range of experimental conditions
# Here we show how the optimal cell dimensions and number of sensors in the array depend on the environmental and brain noise.

# Toolkit is devided into to parts: 
#   Calculation for single sensors
#   Calculations for array of sensors
#
#  All computations are performed using the FieldTrip toolbox (Oostenveld et al., 2011) and custom MATLAB scripts (R2019b, Mathworks, USA)
#
# If you have any quiestions contact Yulia Bezsudnova yxb968@student.bham.ac.uk
