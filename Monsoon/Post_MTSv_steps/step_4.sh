cp post_extraction.sh extracted_queries/
cd extracted_queries/
rm extracted_taxa.txt
ls *.fasta -1 | sed -e 's/\.fasta$//' > extracted_taxa.txt
while read file
do
  echo "Running post extraction steps on $file ..."
  sbatch post_extraction.sh $file
  sleep 1
done < extracted_taxa.txt
