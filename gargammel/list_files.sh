while read file
do
  cd $file
  job_id4=$(sbatch ../taxid_list.sh $file | awk '{ print $4 }')
  cd ..
done < $1



