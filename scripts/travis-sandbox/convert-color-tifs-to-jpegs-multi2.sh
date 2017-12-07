#!/bin/sh

srcDir=$1
workDirs=($@)

fullPixelWidth=252500
reducedWidth=222500

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
    echo "Converting images in $d"
    mkdir -p $d/converted
    for f in `find $d -name "*.tif"`; do

    if ! [[ $f =~ "0001.tif" ]]; then
      if ! [[ $f =~ "0002.tif" ]]; then

        file_type=`identify -quiet $f | cut -d" " -f2`

        if [ "$file_type" = "TIFF" ]; then

          compression_type=`identify -verbose -quiet $f | grep Compression | cut -d" " -f4`
          # only convert files with "old-style JPEG" compression
          if [ "$compression_type" = "JPEG" ]; then
            mogrify -resize 2850x -quality 70 -path $d/converted -format jpg $f
          fi
        fi
      fi 
    fi

    done
done

popd > /dev/null  
