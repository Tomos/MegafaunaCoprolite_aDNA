
while read file
do
  echo "Making directory number $file..."
  # remove any older version of the folder, if it already exists
  rm -r $file
  # makes directory with appropriate name
  mkdir $file
  # move R script to generate firmicute taxanomic IDs and the necessary RDS object into the directory
  cp Generate_bacterial_taxaIDs3.R $file
  cp firmicutes.rds $file
  cp bacteroidetes.rds $file
  # move into the directory
  cd $file
  # remove the data/ directory if present
  rm -r data/
  # copies the default data directory into the newly generated directory
  cp -r ../gargammel_mtsv/data ./
  # copies the script that generates a random proportion for each firmicute into the data/bact directory
  #cp ../bacterial_taxaID_proportion.R  ./data/bact
  #cp ../bacterial_taxaID_proportion2.R  ./data/bact
  cp ../bacterial_taxaID_proportion3.R ./data/bact
  module load R/4.1.0
  # runs the R script that gives a list of random firmictues; the output list (firmicute_list.txt) is used in the first while loop
  Rscript Generate_bacterial_taxaIDs2.R $2
  # loads the tools to download ncbi data:
  curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets'
  # while lop that downloads each fimricute genome, uzips it and gives and faidx index
  while read file2
  do
    echo "Attempting to download reference genome for firmicute taxonomic ID: $file2"
    job_id1=$(sbatch ../fetchGenomeByTaxID2.sh $file2 | awk '{ print $4 }')
    job_id2=$(sbatch --dependency=afterok:${job_id1} ../unzip_single2.sh $file2 | awk '{ print $4 }')
    job_id3=$(sbatch --dependency=afterok:${job_id2} ../faidx.sh $file2 | awk '{ print $4 }')
    sleep 0.5
  done < firmicute_list.txt
   
  cd ..
  

  sleep 1
done < $1



