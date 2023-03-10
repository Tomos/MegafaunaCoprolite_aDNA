#!/bin/bash
eval "$(conda shell.bash hook)"
module load anaconda3
conda activate mtsv-v2.0.0b

mtsv analyze \
  -c mtsv.cfg \
  --jobs 200 \
  --cluster-config cluster.cfg \
  --cluster "sbatch --mem {cluster.mem} --output {cluster.log} --job-name {cluster.jobname} --time {cluster.time} --cpus-per-task {cluster.cpus}" \
  --rerun-incomplete \
  --unlock


