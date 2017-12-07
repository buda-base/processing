#!/bin/sh

srcDir=$1
workDirs=($@)

fullPixelHeight=140000

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
    mkdir -p $d/converted
    for f in `find $d -name "*.jpg"`; do
      imgHeight=`identify -format "%h" $f`
      resizeRatio=$(bc <<< "($fullPixelHeight/$imgHeight)")

      if [ $resizeRatio -lt 100 ]; then
        #echo "$f - resize $resizeRatio"
        mogrify -fuzz 30% -trim -resize $resizeRatio% -quality 60 -path $d/converted $f
      fi
    done
#  else
#    echo "Skipping images in $d.  Images already compressed."
#  fi
done

popd > /dev/null  
