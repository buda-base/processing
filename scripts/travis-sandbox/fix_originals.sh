#!/bin/sh

for w in `ls -d W*`; do
  cd $w

  for f in `ls *original`; do
    length=${#f}-9
    echo "***$f***"
    mv $f ${f:0:$length}
  done 
  
  cd ..
done
