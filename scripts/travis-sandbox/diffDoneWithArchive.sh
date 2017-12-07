#!/bin/sh

doneDir="/Volumes/ProcessingTBR/DONE"
archiveDir="/Volumes/Archive"

if [ ! -d "$doneDir" ]; then
  echo "$doneDir does not exist."
  exit 1
fi

if [ ! -d "$archiveDir" ]; then
  echo "$archiveDir does not exist."
  exit 1
fi

for w in `cat DONE_works.txt`; do
  sh compare.sh $doneDir/$w $archiveDir/$w $w "DONEvsArchive"
done
