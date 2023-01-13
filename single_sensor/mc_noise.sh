#!/bin/bash
#SBATCH --ntasks 1
#SBATCH --time 36:00:00
#SBATCH --qos bbdefault
#SBATCH --mem 50GB
#SBATCH --array 1-100
set -e

module purge; module load bluebear
module load MATLAB/2019b


matlab -nodisplay -r "mc_noise(${SLURM_ARRAY_TASK_ID});quit;"
