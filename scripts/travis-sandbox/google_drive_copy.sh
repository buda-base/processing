#!/bin/sh

for w in `cat ready2sync.txt`; do 
  for d in `find . -depth 2 -name "$w*" | cut -d"/" -f2- `; do
    mkdir -p /Users/tbrc/staging/sync2archive/$d
    rsync -av $d/ /Users/tbrc/staging/sync2archive/$d
  done
done
