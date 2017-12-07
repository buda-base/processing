#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for d in `ls`; do
  cd $d
  for n in `find . -type d -depth 1`; do
    cd $n
    for f in `ls *.tif`; do
      echo "Working on $f"
      convert $f ${f%.*}_%d.jpg
    done
    cd ..
  done
  cd ..
done

IFS="$OIFS"
