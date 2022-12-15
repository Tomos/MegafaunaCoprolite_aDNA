rm -r reference_genomes
mkdir reference_genomes
curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'

while read file2
do
  echo "Downloading reference genome with taxanomic ID: $file2"
  job_id1=$(sbatch fetchGenomeByTaxID2.sh $file2 | awk '{ print $4 }')
  job_id2=$(sbatch --dependency=afterok:${job_id1} unzip_single2.sh $file2 | awk '{ print $4 }')
  job_id3=$(sbatch --dependency=afterok:${job_id2} preliminary_steps.sh $file2 | awk '{ print $4 }')
  sleep 1
done < taxaID_list2.txt

