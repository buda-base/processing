#!/bin/sh

for w in `ls`; do
  cd $w/images

  for d in `ls`; do
    rm $d/*.jpg
    mv $d/converted/*.jpg $d
    rm -rf $d/converted
  done

  cd ../..
done
