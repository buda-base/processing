#!/bin/sh

srcDir=$1

fullPixelWidth=255000
reducedWidth=225000

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

    for f in `find * -iname "*.jpg"`; do
#      imgName=$f
#      tmpImgName="temp_$imgName"

#      convert $imgName -fuzz 30% -trim $tmpImgName
#      imgWidth=`identify -format "%w" -ping $tmpImgName`
#      resizeRatio=$(bc <<< "($reducedWidth/$imgWidth)")
#      rm $tmpImgName

#      mogrify $imgName -resize $resizeRatio% -quality 70 -path converted $f
      mogrify $imgName -resize 2550x -quality 70 -path converted $f
    done

    cd ..
done

popd > /dev/null  
