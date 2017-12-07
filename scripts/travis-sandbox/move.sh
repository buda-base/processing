#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
#    rm $d/*.jpg
#    mv $d/converted/*.jpg $d
ls $d/converted
  done

  cd ../..
done
