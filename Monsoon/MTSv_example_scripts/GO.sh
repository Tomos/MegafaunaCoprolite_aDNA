#!/bin/bash
#SBATCH --job-name='MTSv'
#SBATCH --output='./MTSv.out'
#SBATCH --time=12:00:00
#SBATCH --chdir='.'
#SBATCH --mem=10G
#SBATCH --mail-type=ALL

module load anaconda3
conda activate mtsv-v2.0.0
srun -u /usr/bin/time -v mtsv analyze \
  -c mtsv.cfg \
  --jobs 5000 \
  --cluster-config cluster.cfg \
  --cluster "sbatch --mem {cluster.mem} --output {cluster.log} --job-name {cluster.jobname} --time {cluster.time} --cpus-per-task {cluster.cpus}" \
  --rerun-incomplete \
  -k
