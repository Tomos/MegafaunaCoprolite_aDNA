while read file
do
  cd $file
  job_id4=$(sbatch ../taxid_list.sh $file $2 | awk '{ print $4 }')
  rm *.zip
  sleep 0.5
  cd ..
done < $1



