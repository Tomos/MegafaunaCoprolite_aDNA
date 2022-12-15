#!/bin/bash
#SBATCH --job-name='post_extraction'              # the name of your job
#SBATCH --output=output-%x.%j.out                 # this is the file your output and errors go to
#SBATCH --time=01:31:00                         # 20 min, shorter time, quicker start, max run time
#SBATCH --chdir='.'                             # your work directory
#SBATCH --mem=1G                                # 10GB of memory

# load a module, for example
eval "$(conda shell.bash hook)"
module load anaconda3
conda activate bio_stack
module load samtools/1.11

SAMPLE=$(echo $1 | cut -d "_" -f 1)
echo $SAMPLE
SAMPLE2=$(echo $1 | sed 's/_taxid.*//')
echo $SAMPLE2
TAXID=$(echo $1 | cut -d "_" -f 3)
TAXID=$(echo $TAXID | sed 's/.fasta*//')
SUFFIX=".fna"  # "_assembly.fna"
ASSEMBLY=$TAXID$SUFFIX
echo $ASSEMBLY
LINEAR_SUFFIX="_qc.linear"
LINEAR_QC=$SAMPLE2$LINEAR_SUFFIX
echo $LINEAR_QC
ASSEMBLY_DIR="../reference_genomes/"
ASSEMBLY_PATH=$ASSEMBLY_DIR$ASSEMBLY
echo $ASSEMBLY_PATH

# SELECTING THE LINES OF THE FASTA FILES THAT CONTAIN THE READS:
srun -u /usr/bin/time -v awk 'NR%2 == 0' $1.fasta > $1_queries.txt

# NUMBER OF QUERIES PER FILE:
wc $1_queries.txt | awk -F '\t' '{s += $1}END{print s}' > $1_query_lengths.txt

# CONVERT THE EXTRACTED FASTA FILES TO FASTQ FILES:
seqtk seq -F '?' $1.fasta > $1.fastq

conda deactivate
module load bwa/0.7.17

# ALIGN QUERIES AGAINST THE ASSMEBLY:
#bwa mem -k 19 -r 2.5 $ASSEMBLY_PATH $1.fastq > $1_aligned.sam
bwa aln -l 1024 -n 0.01 -o 2  $ASSEMBLY_PATH $1.fastq > $1_aligned.sai
bwa samse $ASSEMBLY_PATH $1_aligned.sai $1.fastq > $1_aligned.sam

# BOWTIE2 ALIGNER USED BY MTSV (-N is number of mismatches per seed, zero for mtsv I think; -i is interval between seed or seed_gap in mtsv.cfg;
# -L is seed length or seed_size in mtsv.cfg; need to figure out what bowtie2 parameter corresponds to edits and min_seeds in mtsv.cfg)

#module load bowtie2/2.4.2
#bowtie2 

# LOOK AT QUERY COVERAGE ACROSS THE ASSEMBLY:
module load samtools/1.11
samtools sort -O sam $1_aligned.sam > $1_aligned_sorted.sam
samtools coverage $1_aligned_sorted.sam > $1_coverage_stats.txt
samtools coverage $1_aligned_sorted.sam -m --n-bins 100 > $1_coverage_hist.txt

# RUN MAPDAMAGE2:
conda activate mapdamage2
mapDamage -i $1_aligned.sam -r $ASSEMBLY_PATH

####################################################################
####################################################################

# SEARCHING THE EXTRACTED QUERIES AGAINST THE LINEARIZED QC_READS
# FINDS THE READS THAT MATCH AT LEAST ONE OF THE QUERIES
grep -f $1_queries.txt ../qc_reads_linear/$LINEAR_QC.fastq > $1_reads_linear.fastq
cat $1_reads_linear.fastq | sed 's/\t\+/\n/g' > $1_reads.fastq

# NUMBER OF READS PER FILE:
wc $1_reads_linear.fastq | awk -F '\t' '{s += $1}END{print s}' > $1_read_lengths.txt

conda deactivate
module load bwa/0.7.17

# ALIGN THE READS AGAINST THE REFERENCE GENOME:
# bwa mem -k 19 -r 2.5 $ASSEMBLY_PATH $1_reads.fastq > $1_reads_aligned.sam
bwa aln -l 1024 -n 0.01 -o 2 $ASSEMBLY_PATH $1_reads.fastq > $1_reads_aligned.sai
bwa samse $ASSEMBLY_PATH $1_reads_aligned.sai $1_reads.fastq > $1_reads_aligned.sam


# SORT AND ALIGN THE READS AGAINST THE REFERENCE GENOME:
module load samtools/1.11
samtools sort -O sam $1_reads_aligned.sam > $1_reads_aligned_sorted.sam
samtools coverage $1_reads_aligned_sorted.sam > $1_reads_coverage_stats.txt
samtools coverage $1_reads_aligned_sorted.sam -m --n-bins 100 > $1_reads_coverage_hist.txt

# RUN THE DIFFERENT DNA DAMAGE TOOLS:

# Make this into an sbatch submission of run_mapdamage.sh
conda activate mapdamage2
mapDamage -i $1_reads_aligned.sam -r $ASSEMBLY_PATH
