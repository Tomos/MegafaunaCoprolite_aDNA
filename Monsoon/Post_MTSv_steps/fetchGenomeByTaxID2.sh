#!/bin/bash
#SBATCH --job-name='downloadNCBI'              # the name of your job
#SBATCH --output='./out_downloadNCBI.out'          # this is the file your output and errors go to
#SBATCH --time=00:02:00     # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'      # your work directory
#SBATCH --mem=20G      # 10GB of memory



######## Uses NCBI Datasets API  ################
# Install with:
# curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
#
# website: https://www.ncbi.nlm.nih.gov/datasets/
##################################################

# If small, downloads TaxID in $1 and writes to .zip  


chmod +x datasets
#srun -u /usr/bin/time -v
./datasets download genome taxon $1 --reference --filename reference_genomes/$1_assembly.zip --refseq

#while read file
#do
 # echo "Fetching genome of $file..."
 # ./datasets download genome taxon $file --reference --filename  $file_genome.zip --refseq
 # sleep 1
#done


# If large, use:

# datasets download assembly tax-id $1 --filename $2.zip --dehydrated
# unzip $2.zip
# datasets rehydrate -f .
