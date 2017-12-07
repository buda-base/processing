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
    for f in `find $d -name "*.jpg"`; do
      imgWidth=`identify -format "%w" $f`
      resizeRatio=$(bc <<< "(255000/$imgWidth)")

      if [ $resizeRatio -lt 100 ]; then
        #echo "$f - resize $resizeRatio"
        mogrify -border 1x1 -bordercolor "rgb(170,170,170)" -fuzz 25% -trim -border 1x1 -bordercolor "rgb(255,255,255)" -trim -resize $resizeRatio% -quality 75 -path $d/converted $f
      fi
    done
done

popd > /dev/null  
