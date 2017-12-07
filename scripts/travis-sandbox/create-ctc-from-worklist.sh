#!/bin/sh

if [ $# -lt 2 ] ; then
  echo "Must provide worklist and destination as arguments"
  exit 1
fi

worklist=$1
destDir=$2
archiveDir="/Volumes/Archive"

if [ ! -d $destDir ]; then
  echo "ERROR: The destination $destDir does not exist."
  exit 1
fi

if [ ! -d $archiveDir ]; then
  echo "ERROR: $archiveDir does not mounted."
  exit 1
fi

while IFS= read -r w <&3; do
  workImages="$archiveDir/$w/images"
  workEbooks="$archiveDir/$w/eBooks"

  if [ -d $workImages ]; then
    mkdir -p $destDir/$w/images
    rsync -av $workImages/ $destDir/$w/images
  else
    echo "WARNING: $workImages does not exist and will not be copied."  
  fi  

  if [ -d $workEbooks ]; then
    mkdir -p $destDir/$w/eBooks
    rsync -av $workEbooks/ $destDir/$w/eBooks
  else
    echo "WARNING: $workEbooks does not exist and will not be copied."  
  fi  
done 3< "$worklist"
