#!/bin/sh

srcDir=$1
workDirs=($@)

if [ -d $srcDir ]; then
  pushd $srcDir > /dev/null
else
  echo "ERROR: $srcDir is not a valid path"
  exit 1
fi

if [ ${#workDirs[@]} -lt 2 ]; then
  echo "ERROR: No directories to work on"
  exit 1
else 
  workDirs=("${workDirs[@]:1:${#workDirs[@]}-1}")
fi

echo "Processing ${#workDirs[@]} directories..."

for d in "${workDirs[@]}"; do

#  checkDir=$(snowball ls s3://archive.tbrc.org/$d 2>&1)

#  if [[ "$checkDir" = *"Cannot find"* ]]; then
    echo "Copying $d..."
    snowball cp -r /Volumes/Archive/$d s3://archive.tbrc.org/
#  else
#    echo "Skipping $d..."
#  fi
done

popd > /dev/null  
