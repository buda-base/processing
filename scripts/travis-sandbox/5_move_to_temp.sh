#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for w in `ls -d W*`; do
  cd $w

  if [ ! -d "temp" ]; then
    mkdir -p temp
  fi

  for f in `ls T*.tif`; do
    mv $f temp  
  done

  for f in `ls t*.tif`; do
    mv $f temp  
   done

  for f in `ls P*.tif`; do
    mv $f temp  
  done

  for f in `ls D*.tif`; do
    mv $f temp  
  done

  mv converted/*.tif temp

  cd ..
done

IFS="$OIFS"
