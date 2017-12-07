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
      mogrify -gravity north -chop 0x500 -gravity south -chop 0x500 -resize 25% -quality 75 -path $d/converted $f
    done
done

popd > /dev/null  
