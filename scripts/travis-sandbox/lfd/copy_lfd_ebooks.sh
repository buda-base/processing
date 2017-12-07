#!/bin/sh

csvFile=$1
eBooksSrc="/Volumes/DLD_2016"

OIFS="$IFS"
IFS=$'\n'

for l in `cat $csvFile`; do
  w=`echo $l | cut -d"|" -f1`
#echo $w
  if [ ! -d /Volumes/Archive/$w/eBooks ]; then
#    ls /Volumes/Archive/$w/eBooks
#  else
echo $w
    echo "Cannot find eBooks...looking in 2016 DLD..."
    find $eBooksSrc -name "$w-*" -type d 2>/dev/null | head -1
  fi
done

IFS="$OIFS"
