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
    echo "Compressing images in $d"
    mkdir -p $d/converted
    for f in `find $d -name "*.jpg"`; do
      imgWidth=`identify -format "%w" $f`
      resizeRatio=$(bc <<< "($fullPixelWidth/$imgWidth)")

      if [ $resizeRatio -lt 100 ]; then
        #decho "$f - resize $resizeRatio"
        mogrify -profile  /Library/Application\ Support/Adobe/Color/Profiles/Recommended/AdobeRGB1998.icc -colorspace sRGB -resize 2300x -quality 75 -path $d/converted $f
      fi
    done
done

popd > /dev/null  
