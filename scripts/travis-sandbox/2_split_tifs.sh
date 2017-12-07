#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for w in `ls -d W*`; do
  cd $w

  if [ ! -d "converted" ]; then
    mkdir -p converted
  fi

  for f in `ls T*.tif`; do
    convert $f converted/${f%.*}_%d.tif
  done

  for f in `ls t*.tif`; do
    convert $f converted/${f%.*}_%d.tif
  done

  for f in `ls P*.tif`; do
    convert $f converted/${f%.*}_%d.tif
  done

  for f in `ls D*.tif`; do
    convert $f converted/${f%.*}_%d.tif
  done

  cd ..
done

IFS="$OIFS"
