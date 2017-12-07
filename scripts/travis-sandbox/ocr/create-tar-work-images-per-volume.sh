#/bin/sh

workRID=$1
bdrcWorksDir="/mnt/bdrc/archive.tbrc.org/Works"
hashCode=`printf $workRID | md5sum | cut -c 1-2`
imageDir="$bdrcWorksDir/$hashCode/$workRID/images"

homeDir="/home/ubuntu"
scriptsDir="$homeDir/scripts"
tarDir="$homeDir/archive-sandbox"
#myDir=`pwd`

cd $imageDir


for d in `ls $imageDir`; do
  echo "Creating tar file for $d..."
#  cd $d
  tar -cf "$tarDir/$d-images.tar" $d/*
#  cd ..
  echo "Created $d-images.tar"
done

cd $scriptsDir
