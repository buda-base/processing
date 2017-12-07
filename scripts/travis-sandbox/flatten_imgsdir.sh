#!/bin/sh

for d in `ls -d W*`; do
  cd $d

  for n in `find . -type d -depth 1`; do
    echo "$n"
#    mv "$n"/*.* .
#    ls $n 
  done

  cd ..
done
