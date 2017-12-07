#!/bin/sh

for w in `ls -d W*`; do
  for f in `ls $w/images/*/*.JPG`; do
    mv -f $f ${f%.*}.jpg
  done
done
