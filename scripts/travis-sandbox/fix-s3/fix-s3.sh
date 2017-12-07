#!/bin/sh

ARCHIVE="/Volumes/Archive"
S3_WORKS="S3-BUCKET-00.txt"

for w in `cat $S3_WORKS`; do
  hashDir=`printf "$w" | md5 | cut -c1-2`
  if [ -d "$ARCHIVE/$w/eBooks" ]; then
    echo $w
    aws s3 sync $ARCHIVE/$w/eBooks s3://archive.tbrc.org/Works/$hashDir/$w/eBooks
  fi
done
