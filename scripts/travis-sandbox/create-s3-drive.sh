#!/bin/sh

srcDrive="/Volumes/Archive"
owcDrive="/Volumes/S3_ARCHIVE"

sourcesDir="$owcDrive/Sources"
worksDir="$owcDrive/Works"

if [ ! -d "$sourcesDir" ]; then
  mkdir -p $sourcesDir
fi

if [ ! -d "$worksDir" ]; then
  mkdir -p $worksDir
fi

worklist=(`find $srcDrive -name "W*" -type d -maxdepth 1 | cut -d"/" -f4`)

for w in "${worklist[@]}"; do
  hashDir=`printf "$w" | md5 | cut -c1-2`

  if [ ! -d "$sourcesDir/$hashDir" ]; then
    mkdir -p "$sourcesDir/$hashDir"
  fi

  # copy archive dir to Sources
  if [ -d "$srcDrive/$w/archive" ]; then
    rsync -av $srcDrive/$w/archive/ $sourcesDir/$hashDir/$w
  fi

  # copy everything else to hash dir in Works
  if [ ! -d "$worksDir/$hashDir" ]; then
    mkdir -p "$worksDir/$hashDir"
  fi

  rsync -av --exclude="archive" $srcDrive/$w/ $worksDir/$hashDir/$w
  
done
