#!/bin/sh

currentDir=`pwd`
archiveData="archive-full-size-info-09-26-2016.csv"

# 3.9TB in kilobytes
maxDiskSize=3905945600
totalDataSize=0

worklistNum=1
worklistFile="worklist$worklistNum.txt"

while IFS= read -r w <&3; do
  workNumber=`echo $w | cut -d"," -f1`
  workSize=`echo $w | cut -d"," -f2`
echo "$totalDataSize" >> "size$worklistNum.txt"
  totalDataSize=$((totalDataSize+workSize))

  if [ $totalDataSize -lt $maxDiskSize ]; then
    echo "$workNumber" >> $worklistFile
echo "Total size: $totalDataSize"
  else
echo "Resetting..."
    ((worklistNum++))
    worklistFile="worklist$worklistNum.txt"
    echo "$workNumber" >> $worklistFile
    totalDataSize=0
  fi
done 3< "$archiveData"
