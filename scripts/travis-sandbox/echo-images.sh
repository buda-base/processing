#!/bin/sh

srcDir=$1
workDirs=($@)

workDirs=("${workDirs[@]:1:${#workDirs[@]}-1}")
#workDirs=("${workDirs[@]:1:2}")

echo $srcDir

if [ -d $srcDir ]; then
  pushd $srcDir > /dev/null
else
  echo "$srcDir is not a valid path"
  exit 1
fi

for d in "${workDirs[@]}"; do
  echo "Images in $d"
  for f in `ls $d/*.jpg`; do
    echo $f
  done
done

popd > /dev/null  
