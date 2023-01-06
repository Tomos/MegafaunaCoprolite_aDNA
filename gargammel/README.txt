Steps:
##################################################################################
1) Download mulitple firmicute genomes run:

bash download_multiple_genome_batches4.sh reps.txt 300

- reps.txt is simply a list of directory names that will contain different batches of genome downloads. These directories will be used in the subsequent steps below.
- The second argument (300) is simply the max number of genomes you wish to download; the actual number of genomes may be slightly less than this number if no reference genome
exists for the taxid.

##################################################################################
2) Creates the list file in the data/bact directory & creates the list2 file in the data/bact directory

bash list_files2.sh reps.txt 1000000

-reps.txt needs to be the same file as used in step 1
-The second argument is the number of fragments that you intend to generate with gargammel
-The list file contains the names of each bacterial fasta file -> used by gargammel
-The list2.txt file contains the same infomration as the list file (above) as well as a column that contains the number of 
reads that will be generated based on the proportion * the number of reads -> to be used in the run_gargammel_breakdown.sh script 

##################################################################################
2b) (simpler version) Create the list file in the data/bact directory only

bash list_files.sh reps.txt

- reps.txt needs to be the same file as used in step 1
-The list file contains the names of each bacterial fasta file -> used by gargammel

##################################################################################
3) Create bwa indices for the reference genomes:

bash bwa_indexes.sh reps.txt 

- reps.txt needs to be the same file as used in step 1

##################################################################################
4) Run gargammel:

bash run_gargammel.sh reps.txt 1000000

- Again, reps.txt needs to be the same file as used in step 1
- The second argument (1000000) is the number of fragments you wish to simulate

##################################################################################
4b) Run gargammel as well as fragSim and deamSim -> to check read length distribution and deamination pattern (with mapDamage2)

bash run_gargammel_breakdown.sh reps2.txt 10000

- reps2.txt contains the test directory name e.g. 'test'
- reps2.txt needs to be used in steps 1), 2) and 3) above, before running step 4b)
- The 10000 represents the number of reads you want to generate; use a smaller number than step 4), as you are just 
checking the read length distribution and deamination pattern with mapDamage2. It will run faster.

##################################################################################




