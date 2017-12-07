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

for d in "${workDirs[@]}"; do
    echo "Converting images in $d"
    mkdir -p $d/converted
    for f in `find $d -name "*.pdf"`; do
        mogrify -density 300 -units PixelsPerInch -compress Group4 -format tif -path $d/converted $f
    done
done

popd > /dev/null  
