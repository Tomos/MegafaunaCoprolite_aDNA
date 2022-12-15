#!/bin/bash
#SBATCH --job-name='preliminary_steps'              # the name of your job
#SBATCH --output='./output_prelim_steps.out'			# this is the file your output and errors go to
#SBATCH --time=00:10:00				# 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'		 		# your work directory
#SBATCH --mem=10G				# 10GB of memory


# load a module, for example
#module load anaconda3
#conda deactivate
module load bwa/0.7.17

# For BWA to work, this needs to be run beforehand:
bwa index reference_genomes/$1.fna

## To build the bowtie2 indices
#module load bowtie2/
#bowtie2-build reference-genomes/$1.fna $1
