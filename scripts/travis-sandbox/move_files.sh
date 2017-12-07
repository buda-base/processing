#!/bin/sh

for w in `ls -d W*`; do
echo $w
  cd $w/images

  for d in `ls`; do
    cd $d
    rm -rf converted
    cd ..
  done

  cd ../..
done
