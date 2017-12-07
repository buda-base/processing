#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for f in `find . -name "*.pdf"`; do
  mv "$f" "${f// /-}"
done

IFS="$OIFS"
