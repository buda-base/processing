#!/bin/sh

for w in `cat completed_works.txt`; do
  hashDir=`printf "$w" | md5 | cut -c1-2`
  echo "$w:$hashDir"
  aws s3 ls s3://archive.tbrc.org/Works/$hashDir/$w
done
