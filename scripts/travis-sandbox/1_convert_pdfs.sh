#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for f in `find . -name "*.pdf" -depth 2`; do
   gs -q -dNOPAUSE -r600x600 -sDEVICE=tiffg4 -sOutputFile="${f%.*}.tif" "${f%.*}.pdf" -c quit
done

IFS="$OIFS"
