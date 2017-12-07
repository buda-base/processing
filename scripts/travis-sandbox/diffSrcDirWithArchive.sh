#!/bin/sh

srcDir="/Volumes/Incoming/scans/Cataloged-completed/MONGOLIA-PROCESSING/12-1-2008-chopping"
archiveDir="/Volumes/Archive"

if [ ! -d "$srcDir" ]; then
  echo "$srcDir does not exist."
  exit 1
fi

if [ ! -d "$archiveDir" ]; then
  echo "$archiveDir does not exist."
  exit 1
fi

for w in `cat mongolia_works.txt`; do
  echo "sh compare.sh $srcDir/$w $archiveDir/$w $w"
  sh compare.sh $srcDir/$w $archiveDir/$w $w "SrcvsArchive"
done
