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
  if [[ -n $(find $d -name "*.jpg" -size +300k) ]]; then
    echo "Compressing images in $d"
    for f in `find $d -name "*.jpg" -size +300k`; do
      imgHeight=`identify -format "%h" $f`
      resizeRatio=$(bc <<< "(140000/$imgHeight)")

      if [ $resizeRatio -lt 100 ]; then
        #echo "$f - resize $resizeRatio"
        mogrify -resize $resizeRatio% -quality 75 $f
      fi
    done
  else
    echo "Skipping images in $d.  Images already compressed."
  fi
done

popd > /dev/null  
