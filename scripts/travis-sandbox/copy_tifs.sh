#!/bin/sh

for w in `ls -d W*`; do
  cd $w/archive

  for d in `ls`; do
#    cp $d/*0001.tif ../images/$d
    cp $d/*0002.tif ../images/$d
  done

  cd ../..
done
