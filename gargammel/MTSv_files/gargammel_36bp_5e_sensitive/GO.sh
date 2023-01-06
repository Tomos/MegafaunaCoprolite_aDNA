#!/bin/bash
#SBATCH --job-name='gargammel36bp_5e_sens'
#SBATCH --output='./gargammel36bp_5e_sens.out'
#SBATCH --time=1-10:00:00
#SBATCH --chdir='.'
#SBATCH --mem=10G
#SBATCH --mail-type=ALL

eval "$(conda shell.bash hook)"
module load anaconda3
conda activate mtsv-v2.0.0b

# srun mtsv analyze -c mtsv.cfg --jobs 100 --cluster-config cluster.cfg --cluster "sbatch --mem {cluster.mem} --output {cluster.log} --job-name {cluster.jobname} --time {cluster.time} --cpus-per-task {cluster.cpus}" --rerun-incomplete

srun -u /usr/bin/time -v mtsv analyze \
  -c mtsv.cfg \
  --jobs 1000 \
  --cluster-config cluster.cfg \
  --cluster "sbatch --mem {cluster.mem} --output {cluster.log} --job-name {cluster.jobname} --time {cluster.time} --cpus-per-task {cluster.cpus}" \
  --rerun-incomplete #\
  #-k
