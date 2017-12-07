#!/bin/sh

for f in `find . -name "*.jpg"`; do
  if [ `identify $f | awk '{print $6}'` = "Gray" ]; then
    rm $f
  fi 
done
