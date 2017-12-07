#!/bin/sh

for w in `ls -d W*`; do
  cd $w
  
  for f in `ls *.pdf`; do
    pdftk $f burst output ${f%.*}_%d.pdf
  done

  cd ..
done
