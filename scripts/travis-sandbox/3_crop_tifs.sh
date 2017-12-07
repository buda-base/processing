#!/bin/sh

for w in `ls -d W*`; do
  for f in `ls $w/converted/*.tif`; do 
    mogrify -crop 9925x2075+0+1300 -path $w/converted/a $f
  done
  
  for f in `ls $w/converted/*.tif`; do 
    mogrify -crop 9925x2075+0+3640 -path $w/converted/b $f
  done
done
