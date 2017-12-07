#!/bin/sh

cd /Users/tbrc/staging/sync2archive

for w in `ls -d W*`; do
    cd $w/images
    sh /Users/tbrc/staging/scripts/rename_jpegs2.sh
    cd /Users/tbrc/staging/sync2archive
done
