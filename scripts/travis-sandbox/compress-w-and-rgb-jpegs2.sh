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
        mogrify -profile  /Library/Application\ Support/Adobe/Color/Profiles/Recommended/AdobeRGB1998.icc -colorspace sRGB -resize 2750x -quality 70 -path $d/converted $f
    done
done

popd > /dev/null  
