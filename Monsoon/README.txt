1) 
> sbatch GO.sh

Runs MTSv - See full details at https://github.com/FofanovLab/MTSv
Requires the cluster.cfg and mtsv.cfg files in the same directory.
Readsets are availabe at NCBI under BioProject Accession PRJNA861306.

2) 
> bash step_1.sh

Linearizes the fastq files into qc_reads_linear directory.
Runs the TaxID.R script, which takes the MTSv output csvs and extracts all taxa with over a threshold number of unique signature hits (USH), as measured by MTSv.  
TaxID.R outputs the taxa with over the USH threshold.