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

    for f in `find * -iname "*.jpg"`; do
      #imgName=$f
      #tmpImgName="temp_$imgName"

      #convert $imgName -fuzz 30% -trim $tmpImgName
      #imgWidth=`identify -format "%w" -ping $tmpImgName`
      #resizeRatio=$(bc <<< "($reducedWidth/$imgWidth)")
      #rm $tmpImgName

      mogrify -fuzz 30% -trim -resize 2450x -quality 65 -path converted $f
    done

    cd ..
done

popd > /dev/null  
