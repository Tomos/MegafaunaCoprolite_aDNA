#!/bin/bash
#SBATCH --job-name='extraction'              # the name of your job
#SBATCH --output='./output_extraction.out'                 # this is the file your output and errors go to
#SBATCH --time=18:00:00                         # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'                             # your work directory
#SBATCH --mem=50G                                # 10GB of memory

## This script changes the mtsv.cfg extract_taxids parameter to include all the taxa ids to include
## It then runs the extractions
## To run this file: sbatch step_2.sh

rm -r extracted_queries
TAXA_FILE=$(cat taxaID_list.txt)
sed -i "s|extract_taxids: \[\]|extract_taxids: $TAXA_FILE|g" mtsv.cfg
eval "$(conda shell.bash hook)"

export HOME=/scratch/top23/mtsv_env
module load anaconda3
conda activate mtsv-v2.0.0e
bash UNLOCK.sh
mtsv extract -c mtsv.cfg --cores 8 --ignore-changes -k


