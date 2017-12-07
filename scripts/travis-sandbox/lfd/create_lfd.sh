#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

eBooksSrc1="/Volumes/Archive"
eBooksSrc2="/Volumes/DLD_2016"
destDrive="/Volumes/Lineage"

for f in `ls *.csv`; do
  collection=`echo $f | cut -d"-" -f3`

  if [ ! -d $destDrive/$collection ]; then
    echo "Creating $collection directory..."
    mkdir -p $destDrive/$collection
  fi

  for l in `cat $f`; do
    workNum=`echo $l | cut -d"|" -f1`
    workTitle=`echo $l | cut -d"|" -f2`
    workDir="$workNum-$workTitle"
    
    #
    #if ! ls "$src_dir"/*.pdf &> /dev/null; then
    #

    if [ -d $eBooksSrc1/$workNum/eBooks ]; then
      if [ ! -d $destDrive/$collection/$workNum ]; then
        echo "Populating $workDir"
        rsync -qav $eBooksSrc1/$workNum/eBooks/ $destDrive/$collection/$workNum
      fi
    else
      echo "Checking for $workNum in $eBooksSrc2"
      srcDir=`find $eBooksSrc2 -name "$workNum-*" -type d 2>/dev/null | head -n 1`
      
      if [ ! -z $srcDir ]; then
        if [ ! -d $destDrive/$collection/$workNum ]; then
          echo "Populating $workDir" 
          rsync -qav $srcDir/ $destDrive/$collection/$workNum
        fi
      else
        echo "EBOOKS NOT FOUND - $workNum"
      fi      
    fi
  done
###

  echo "Done creating $collection"
done

IFS="$OIFS"
