#!/bin/sh

for w in `ls -d W*`; do
  hashDir=`printf "$w" | md5 | cut -c1-2`
  cd $w/images
  for d in `ls`; do
    echo $d
    aws s3 ls s3://archive.tbrc.org/Works/$hashDir/$w/images/$d/ | wc -l
  done
  cd ../..
done

