#!/bin/sh

for w in `ls -d W*`; do
  cd $w

  rm *0003.tif
  rm *0004.tif

  for f in `ls *.tif | tail -2`; do
    rm $f
  done
  
#  for f in `ls *.jpg | tail -2`; do
  for f in `ls *0003.jpg`; do
     mogrify -resize 3308x -quality 50 $f
  done

  n=`ls *.jpg | wc -l`
  x1=$((n-2))
  x2=$((x1-2))

  for f in `ls *.jpg | tail -$x1 | head -$x2`; do
    rm $f
  done

  cd ..
done
