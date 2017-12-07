#!/bin/sh

for w in `ls -d W*`; do
  cd $w
  myDir=`find . -depth 1 -type d | cut -d"/" -f2`
  if [ "$myDir" != "" ]; then
    mv $myDir/*.* .
  fi
  cd ..
done
