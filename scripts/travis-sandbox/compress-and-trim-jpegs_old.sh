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
    mkdir -p $d/converted

    echo "Compressing images in $d"
    for f in `find $d -name "*.jpg"`; do
      mogrify -border 1x1 -bordercolor "rgb(170,170,170)" -fuzz 40% -trim -resize 50% -quality 70 -path $d/converted $f 
    done
done

popd > /dev/null  
