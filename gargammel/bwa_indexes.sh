while read file
do
  cd $file/data/bact
  while read file2
  do
    echo "creating bwa index for $file2 in $file/data/bact"
    sbatch ../../../preliminary_steps.sh $file2
    sleep 0.5
  done < prelim_list.txt
  sleep 0.5
  cd ../../..
done < $1



