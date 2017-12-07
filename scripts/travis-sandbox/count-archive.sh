#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d
    echo $d
    ls ../../archive/$d/*.* | wc -l
    ls *.* | wc -l
    cd ..
  done

  cd ../..
done
