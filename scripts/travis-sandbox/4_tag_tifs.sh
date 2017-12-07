#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for dir in `ls -d W*`; do

  cd $dir/converted/a 

  for f in `ls *.tif`; do
    echo "$f-->${f%.*}a.tif"
    mv $f ${f%.*}a.tif
  done

  cd ../../..

  cd $dir/converted/b

  for f in `ls *.tif`; do
    echo "$f-->${f%.*}b.tif"
    mv $f ${f%.*}b.tif
  done

  cd ../../..

done

IFS="$OIFS"
