#!/bin/bash
#SBATCH --job-name='taxa_list'              # the name of your job
#SBATCH --output='./taxa_list.out'          # this is the file your output and errors go to
#SBATCH --time=00:01:00     # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'      # your work directory
#SBATCH --mem=1G      # 10GB of memory

cd data/bact/
ls *.fna | sed -e 's/\.fna//' | sed 's/$/.fna/' > prelim_list.txt
module load R
Rscript bacterial_taxaID_proportion3.R $1 $2
cd ../..

