#!/bin/bash

module load anaconda3
conda activate mtsv-v1.1.0

mtsv analyze \
  -c mtsv.cfg \
  --jobs 200 \
  --cluster-config cluster.cfg \
  --cluster "sbatch --mem {cluster.mem} --output {cluster.log} --job-name {cluster.jobname} --time {cluster.time} --cpus-per-task {cluster.cpus}" \
  --rerun-incomplete \
  --unlock


