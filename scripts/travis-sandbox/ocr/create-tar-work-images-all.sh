#!/bin/sh

workRID=$1
bdrcWorksDir="/mnt/bdrc/archive.tbrc.org/Works"
hashCode=`printf $workRID | md5sum | cut -c 1-2`
imageDir="$bdrcWorksDir/$hashCode/$workRID/images"

homeDir="/home/ubuntu"
scriptsDir="$homeDir/scripts"
tarDir="$homeDir/archive-sandbox"
#myDir=`pwd`

cd $imageDir

echo "Creating tar file for $workRID..."

for d in `ls $imageDir`; do
  cd $d
  tar -rf "$tarDir/$workRID-images.tar" *
  cd ..
done

echo "Finished creating $workRID-images.tar"

cd $scriptsDir
