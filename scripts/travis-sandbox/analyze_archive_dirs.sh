#!/bin/sh

for w in `ls -d W*`; do
  if [ -d $w/archive ]; then
    if [[ -n $(find $w/archive -type d -maxdepth 1 ! -name "W*") ]]; then
      echo "*** $w/archive ***"
      find $w/archive -type d -maxdepth 1 ! -name "W*" | cut -d"/" -f3
      #find $w/archive -type f -maxdepth 1
      echo "************************"
    fi
  fi
done
