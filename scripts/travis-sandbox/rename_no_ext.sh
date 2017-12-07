#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for f in `ls`; do
  mv "$f" "${f%.*}.tif"
done

IFS="$OIFS"
