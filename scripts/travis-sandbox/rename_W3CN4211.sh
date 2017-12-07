#!/bin/sh

cd /Users/tbrc/staging/sync2archive

for w in `ls -d W3CN4211`; do
    cd $w/images
    sh /Users/tbrc/staging/processing/scripts/travis-sandbox/rename_all.sh
    cd /Users/tbrc/staging/sync2archive
done
