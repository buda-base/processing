#!/bin/sh

srcDir=$1
workDirs=($@)

fullPixelWidth=252500
reducedWidth=222500

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
    for f in `find $d -name "*.tif"`; do
        mogrify -resize 2850x -quality 70 -path $d/converted -format jpg $f
    done
done

popd > /dev/null  
