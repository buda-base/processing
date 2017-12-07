#!/bin/sh

srcDir=$1

if [ -d $srcDir/images ]; then
  pushd $srcDir/images > /dev/null
else
  echo "ERROR: $srcDir/images is not a valid path"
  exit 1
fi

for d in `ls`; do
    mkdir -p $d/converted

    echo "Compressing images in $d"

    cd $d

    for f in `find * -iname "*.tif"`; do
      mogrify $imgName -define tiff:ignore-tags=32934,34864,34866,42032,42033,42034,42036 -resize 2500x -quality 80 -path converted -format jpg $f
    done

    cd ..
done

popd > /dev/null  
