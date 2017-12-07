#!/bin/sh

for w in `ls`; do

  cd $w/images

  for d in `ls`; do
    cd $d
    
    for f in `ls`; do
      r=`identify -ping -verbose $f | grep "Resolution:"`
      echo "$f : $r"
    done

    cd ..
  done

  cd ../..

done
