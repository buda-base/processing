#!/bin/sh

csvFile=$1
dataFile="/Volumes/Admin/logs/eBooks-data-size2.csv"

totalSize=0

while IFS= read -r l <&3; do
  w=`echo $l | cut -d"|" -f1`
  size=`grep ",$w$" $dataFile | cut -d"," -f1`
  totalSize=$((totalSize+size))
#echo $w
#echo $size
done 3< "$csvFile"

echo $csvFile
echo "total size KB: $totalSize"
echo "$totalSize / 1024 / 1024" | bc
