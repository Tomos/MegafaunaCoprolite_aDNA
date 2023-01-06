#!/bin/bash
#SBATCH --job-name='unzipping'              # the name of your job
#SBATCH --output='./out_unzipping.out'          # this is the file your output and errors go to
#SBATCH --time=00:02:00     # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'      # your work directory
#SBATCH --mem=10G      # 10GB of memory

srun -u /usr/bin/time -v unzip $1_assembly.zip -d $1
cat $1/ncbi_dataset/data/GCF_*/*.fna > ./data/bact/$1.fna
rm -r $1
rm $1_assembly.zip

