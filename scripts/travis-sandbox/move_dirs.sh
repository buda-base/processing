#!/bin/sh

imageDirs=(images/*/)
i=0

for d in `seq -f '%02g' 1 111`; do
  echo "$d-->${imageDirs[i]}"
  mv "$d" "${imageDirs[i]}"
  (( i++ ))
done
