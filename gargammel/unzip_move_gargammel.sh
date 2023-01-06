#!/bin/bash
#SBATCH --job-name='unzip_move_gargammel'
#SBATCH --output='./output_unzip_move_gargammel.out'
#SBATCH --time=00:10:00
#SBATCH --chdir='.'
#SBATCH --mem=2G

eval "$(conda shell.bash hook)"
gunzip simulatedDNA_s.fq.gz
cp simulatedDNA_s.fq ../simulated_aDNA


