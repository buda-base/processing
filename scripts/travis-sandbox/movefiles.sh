#!/bin/sh

for f in `ls *.CR2`; do
  if (( ${f:5:3} % 2 )); then
    mv $f odd
  else
    mv $f even
  fi 
done
