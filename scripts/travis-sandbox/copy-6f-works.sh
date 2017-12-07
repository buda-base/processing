#!/bin/sh

workslist="/Volumes/Admin/AWS/Works-6f.txt"

for w in `cat $workslist`; do 
  
  echo "aws s3 sync /Volumes/Archive/$w/images s3://archive.tbrc.org/Works/6f/$w/images"

  if [ -d /Volumes/Archive/$w/images ]; then
    aws s3 sync /Volumes/Archive/$w/images s3://archive.tbrc.org/Works/6f/$w/images
  fi

  echo "aws s3 sync /Volumes/Archive/$w/eBooks s3://archive.tbrc.org/Works/6f/$w/eBooks"

  if [ -d /Volumes/Archive/$w/eBooks ]; then
    aws s3 sync /Volumes/Archive/$w/eBooks s3://archive.tbrc.org/Works/6f/$w/eBooks
  fi
done
