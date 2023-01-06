1) > sbatch GO.sh

Runs MTSv - See full details at https://github.com/FofanovLab/MTSv
Requires the cluster.cfg and mtsv.cfg files in the same directory.
Readsets are availabe at NCBI under BioProject Accession PRJNA861306.

2) > bash step_1.sh

Linearizes the qc reads - so that we can search for the whole reads versus queries, to measure their length and look for C->T transitions at the read termini.
Runs the TaxaID.R script to find the taxa ids for all the taxa identified in the results csvs (over a threshold specified in the R script).
Creates a backup of the mtsv.cfg file -> mtsv_backup.cfg; This is necessary as the mtsv.cfg file will be modified later.

3) > sbatch step_2.sh

Inserts the taxa from the taxaID_list.txt into the mtsv.cfg.
These taxa are then extracted using MTSv.

