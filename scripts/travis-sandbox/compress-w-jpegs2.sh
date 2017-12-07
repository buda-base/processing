#!/bin/sh

srcDir=$1
workDirs=($@)

fullPixelWidth=255000
reducedWidth=225000

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
#  if [[ -n $(find $d -name "*.jpg" -size +300k) ]]; then
    echo "Compressing images in $d"
    for f in `find $d -name "*.jpg"`; do
#      imgWidth=`identify -format "%w" $f`
#      resizeRatio=$(bc <<< "($fullPixelWidth/$imgWidth)")

#      if [ $resizeRatio -lt 100 ]; then
#        #echo "$f - resize $resizeRatio"
        mogrify -density 300 -units PixelsPerInch -resize 2126x -quality 75 $f
#      fi
    done
#  else
#    echo "Skipping images in $d.  Images already compressed."
#  fi
done

popd > /dev/null  
