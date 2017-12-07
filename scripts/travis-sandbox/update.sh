#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for i in `ls`; do
    rm $i/*.jpg
    mv $i/converted/*.jpg $i 
  done

  cd ../..
done
