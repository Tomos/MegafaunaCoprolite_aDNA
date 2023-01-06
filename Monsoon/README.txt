1) > sbatch GO.sh

Runs MTSv - See full details at https://github.com/FofanovLab/MTSv
Requires the cluster.cfg and mtsv.cfg files in the same directory.
Readsets are availabe at NCBI under BioProject Accession PRJNA861306.

2) > bash step_1.sh

Linearizes the qc reads - so that we can search for the whole reads versus queries, to measure their length and look for C->T transitions at the read termini.
Runs the TaxaID.R script to find the taxa ids for all the taxa identified in the results csvs (over a threshold specified in the R script). Creates two txt lists taxaID_list.txt and taxaID_list2.txt
Creates a backup of the mtsv.cfg file -> mtsv_backup.cfg; This is necessary as the mtsv.cfg file will be modified later.

3) > sbatch step_2.sh

Inserts the taxa from the taxaID_list.txt into the mtsv.cfg.
These taxa are then extracted using MTSv.

4) > bash step_3.sh

Creates the reference_genomes directory
Takes the taxaID_list2.txt and downloads a reference genome for each of the taxa where available.
It does this by running three additional .sh scripts: fetchGenomeByTaxID2.sh, unzip_single2.sh and preliminary_steps.sh

5) > bash step_4.sh

Copies the post_extraction.sh file into the extracted_queries directory and then creates the extracted_taxa.txt file
This txt file is used to run post_extraction.sh on each taxon.
post_extraction.sh adds damage into reads using MapDamage2, generated from the downloaded reference genomes

6) > bash step_5.sh

Moves output* files into output_files directory