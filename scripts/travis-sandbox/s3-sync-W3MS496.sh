#!/bin/sh

#workslist="/Volumes/Admin/AWS/Works-c1.txt"

#for w in `cat $workslist`; do 
w="W3MS496"  
  echo "aws s3 sync /Volumes/Archive/$w/images s3://archive.tbrc.org/Works/c1/$w/images"

  if [ -d /Volumes/Archive/$w/images ]; then
    aws s3 sync /Volumes/Archive/$w/images s3://archive.tbrc.org/Works/c1/$w/images
  fi

  echo "aws s3 sync /Volumes/Archive/$w/eBooks s3://archive.tbrc.org/Works/c1/$w/eBooks"

  if [ -d /Volumes/Archive/$w/eBooks ]; then
    aws s3 sync /Volumes/Archive/$w/eBooks s3://archive.tbrc.org/Works/c1/$w/eBooks
  fi
#done
