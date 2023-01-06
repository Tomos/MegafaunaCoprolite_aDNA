#!/bin/bash
eval "$(conda shell.bash hook)"
while read file
do
  module load anaconda3
  conda activate gargammel_env
  rm -r $file/MTSv_files
  cp -r MTSv_files $file
  cd $file
  rm -r simulated_aDNA
  mkdir simulated_aDNA
  # Runs gargammel (however, I think we'll need to add the -damage flag)
  gargammel -n $2 --comp 1,0,0 -damage 0.03,0.4,0.01,0.3  -f ../Fu_et_al_sizefreq/sizefreq.size -se -ss MSv3 -o data/simulatedDNA  data/
  cd data/
  gunzip simulatedDNA_s.fq.gz
  cp simulatedDNA_s.fq ../simulated_aDNA
  cd ..

  # Running the individual programs in gargammel to: a) check fragment sizes, b) check deamination patterns; here we just generate the directories
  rm -r fragSim_results deamSim_results
  mkdir fragSim_results deamSim_results
  cp ../tot_length_dist.sh fragSim_results
  
  module load bwa/0.7.17
  module load samtools/1.11
  conda activate gargammel_env  
  cd data/bact
  while read file2
  do
    #echo $file2
    read TAXID PROP READ_NO <<< $(echo $file2 | awk -F '\t' '{print $1" "$2" "$3}')
    TAXID2=$(echo $TAXID | sed -e 's/\.fna$//')
    #echo $TAXID
    #echo $TAXID2
    #echo $READ_NO
    ### Generate fragmented sequences:
    fragSim -n $READ_NO -f /scratch/top23/gargammel/Fu_et_al_sizefreq/sizefreq.size /scratch/top23/gargammel/$file/data/bact/$TAXID2.fna > $TAXID2.fragSim.fasta
    mv *.fragSim.fasta ../../fragSim_results
    ### Add deamination pattern to the fragmented sequences
    deamSim -damage 0.03,0.4,0.01,0.3 ../../fragSim_results/$TAXID2.fragSim.fasta > ../../deamSim_results/$TAXID2.fragSim.deamSim.fasta

    ### Align the .fragSim.deamSim.fasta files against the reference FASTAs
    bwa aln -l 1024 -n 0.01 -o 2 $TAXID2.fna ../../deamSim_results/$TAXID2.fragSim.deamSim.fasta > ../../deamSim_results/$TAXID2.fragSim.deamSim.aligned.sai
    bwa samse $TAXID2.fna ../../deamSim_results/$TAXID2.fragSim.deamSim.aligned.sai ../../deamSim_results/$TAXID2.fragSim.deamSim.fasta >  ../../deamSim_results/$TAXID2.fragSim.deamSim.aligned.sam
    #samtools view -S -b ../../deamSim_results/$TAXID2.fragSim.aligned.sam > ../../deamSim_results/$TAXID2.fragSim.aligned.bam
    # Convert to fasta file too using samtools:
    #samtools bam2fq ../../deamSim_results/$TAXID2.fragSim.aligned.bam | seqtk seq -A > ../../deamSim_results/$TAXID2.fragSim.aligned.fa

    sleep 1
  done < list2.txt
  cd ../..

  conda activate mapdamage2
  cd data/bact
  while read file2
  do
    # run mapdamage2 on the .fragSim.deamSim.fasta files and output the files in deamSim_results
    read TAXID PROP READ_NO <<< $(echo $file2 | awk -F '\t' '{print $1" "$2" "$3}')
    TAXID2=$(echo $TAXID | sed -e 's/\.fna$//')
    echo "Running mapdamage2 on the $TAXID2.fragSim.aligned.sam file in the fragSim_results directory"
    sbatch ../../../run_mapDamage.sh $TAXID2
    #mapDamage --merge-reference-sequences  -i ../../deamSim_results/$TAXID2.fragSim.deamSim.aligned.sam -r $TAXID2.fna 
    # move the mapdamage directories to ../../deamSim_results/
    #mv -r *.fragSim.aligned ../../deamSim_results/
    sleep 1
  done < list2.txt
  cd ../..

  cd fragSim_results
  sbatch tot_length_dist.sh
  # The output of tot_length_dist.sh can be input into an R script to produce a graph of read lengths
  cd ..

  cd ..
done < $1

