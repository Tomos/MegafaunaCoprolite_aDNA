#!/bin/bash
#SBATCH --job-name='gargammel'
#SBATCH --output='./output_gargammel.out'
#SBATCH --time=00:30:00
#SBATCH --chdir='.'
#SBATCH --mem=10G

eval "$(conda shell.bash hook)"
module load anaconda3/2021.05
conda activate gargammel_env
gargammel -n $1 --comp 1,0,0 -damageb 0.03,0.4,0.01,0.3  -f ../Fu_et_al_sizefreq/sizefreq.size -se -ss MSv3 -o data/simulatedDNA  data/


