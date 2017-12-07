#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d
    echo $d
    ls *.jpg | wc -l
    ls converted/*.jpg | wc -l
    cd ..
  done

  cd ../..
done
