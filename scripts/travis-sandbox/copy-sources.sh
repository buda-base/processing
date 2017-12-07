#!/bin/sh

srcDir="/Volumes/Sources"

cd $srcDir

for w in `ls`; do
  hashDir=`printf "$w" | md5 | cut -c1-2`
  echo "$hashDir/$w"
  rsync -av $w/ /Volumes/S3_ARCHIVE/Sources/$hashDir/$w
done
