#!/bin/sh

cd /Users/tbrc/staging/sync2archive

for w in `ls -d W*`; do
    cd $w/images
    sh /Users/tbrc/staging/processing/scripts/travis-sandbox/rename_jpegs2.sh
    cd /Users/tbrc/staging/sync2archive
done
