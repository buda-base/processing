#!/bin/sh

archiveData="archive-full-size-info-09-26-2016.csv"

totalDataSize=0

while IFS= read -r w <&3; do
  workSize=`echo $w | cut -d"," -f2`
  totalDataSize=$((totalDataSize+workSize))
  echo $totalDataSize
done 3< "$archiveData"
