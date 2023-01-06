#!/bin/bash
#SBATCH --job-name='faidx'              # the name of your job
#SBATCH --output='./faidx.out'          # this is the file your output and errors go to
#SBATCH --time=00:02:00     # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'      # your work directory
#SBATCH --mem=1G      # 10GB of memory

#conda init biostack
module load samtools/1.11
cd data/bact
samtools faidx $1.fna 
cd ../..

