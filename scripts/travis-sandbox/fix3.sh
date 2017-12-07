#!/bin/sh

for d in `ls -d W*`; do
  cd $d

  for f in `ls *.jpg`; do
    w=`identify -format "%w" $f`
     if [ "$w" -ge "3310" ]; then
      echo "$f:$w"
    fi
  done

  cd ..
done
