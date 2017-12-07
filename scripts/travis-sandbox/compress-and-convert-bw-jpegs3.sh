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
    echo "Compressing images in $d"

    mkdir -p $d/converted

    for f in `find $d -name "*.jpg"`; do
      mogrify -resize 3500x -compress Group4 -format tif -strip -path $d/converted $f
    done
done

popd > /dev/null  
