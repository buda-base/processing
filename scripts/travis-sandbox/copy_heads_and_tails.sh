#!/bin/sh

for w in `ls -d W*`; do
  cd $w

  cp *0003.jpg converted/
  cp *0004.jpg converted/

  for f in `ls *.jpg | tail -2`; do
    cp $f converted/
  done
  
done
