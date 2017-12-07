#!/bin/sh

for w in `ls`; do

  hashDir=`printf "$w" | md5 | cut -c1-2`
  num=`aws s3 ls --recursive s3://archive.tbrc.org/Works/$hashDir/$w/images | wc -l`
  echo "$w:$num"

done
