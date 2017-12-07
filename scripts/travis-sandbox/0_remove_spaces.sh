#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for f in `find . -name "*.pdf" -depth 2`; do
  mv "$f" "${f// /-}"
done

IFS="$OIFS"
