## In .sh file:
## a) linearizes the qc reads - so that we can search for the whole reads versus queries, to measure their length and look for C->T transitions at the read termini
## b) Runs the TaxaID.R script to find the taxa ids for all the taxa identified in the results csvs (over a threshold specified in the R script)
## c) Creates a backup of the mtsv.cfg file -> mtsv_backup.cfg; This is necessary as the mtsv.cfg file will be modified later

## To run this file: bash step_1.sh

mkdir qc_reads_linear
cd qc_reads
ls *.fastq | sed -e 's/\.fastq$//' > ../linear_qc_reads.txt
cd ../

while read file
do
  echo "Linearizing file $file..."
  cat ./qc_reads/$file.fastq | awk '{printf("%s%s",$0,((NR+1)%4==1?"\n":"\t"));}' > ./qc_reads_linear/$file.linear.fastq
  sleep 1
done < linear_qc_reads.txt

module load R/4.1.0 
Rscript TaxaID.R results/
mv results/taxaID_list.txt ./
mv results/taxaID_list2.txt ./
cp mtsv.cfg mtsv_backup.cfg


