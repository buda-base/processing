#!/bin/sh

srcDir=$1

if [ -d $srcDir ]; then
  pushd $srcDir > /dev/null
else
  echo "ERROR: $srcDir is not a valid path"
  exit 1
fi

for w in `ls -d W*`; do
  if [[ -n $(find $w/images -name "*.tif" -size +3M) ]]; then
    echo "Compressing images in $w/images"

    cd $w/images

    for f in `find . -name "*.tif" -size +3M`; do
      imgHeight=`identify -define tiff:ignore-tags=32934 -format "%h" $f`
      resizeRatio=$(bc <<< "(140000/$imgHeight)")

      if [ $resizeRatio -lt 100 ]; then
        #echo "$f - resize $resizeRatio"
        mogrify -define tiff:ignore-tags=32934 -resize $resizeRatio% -quality 75 -format jpg $f
        
        if [ $? -eq 0 ]; then
          rm $f
        fi
      fi
    done

    cd ../..
  else
    echo "Skipping images in $d.  Images already compressed."
  fi
done

popd > /dev/null  
