#!/bin/sh

src="/Volumes/processing/sync2archive"
dest_all="/Volumes/Archive"
dest_web="/image"

for workFolder in `ls $src`;
do
  echo "workfldr=${workFolder}"
  echo "size_src=`find ${src}/$workFolder -type f | wc -l`"
  echo "size_dest=`find ${dest_all}/$workFolder -type f ! -size 0 | wc -l`"
  echo "size_i_src=`find ${src}/$workFolder/images -type f | wc -l`"
  echo "size_i_dest=`ssh -l tbrc -p 15345 10.0.1.4 find ${dest_web}/$workFolder/images -type f ! -size 0 | wc -l`"
  echo $'\n'
done
