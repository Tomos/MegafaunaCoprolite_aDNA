#!/bin/bash
eval "$(conda shell.bash hook)"
while read file
do
  module load anaconda3
  conda activate gargammel_env
  rm -r $file/MTSv_files
  cp -r MTSv_files $file
  cd $file
  rm -r simulated_aDNA
  mkdir simulated_aDNA
  echo "Running gargammel on genomes in $file/data/bact/ to generate $2 simulated reads" >> ../output_run_gargammel.txt
  job_id1=$(sbatch ../gargammel.sh $2 | awk '{ print $4 }')
  cd data/
  echo "Unzipping and moving the $2 gargammel reads to the $file/simulated_aDNA directory" >> ../../output_run_gargammel.txt
  job_id2=$(sbatch --dependency=afterok:${job_id1} ../../unzip_move_gargammel.sh | awk '{ print $4 }')
  cd ..

  cd ..
done < $1

