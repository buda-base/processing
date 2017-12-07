#!/bin/sh

for w in `ls`; do

  cd $w/images/W*

  echo "Working on $PWD..."  

  for f in `ls *.tif`; do
    if ! [[ $f =~ "0001.tif" ]]; then
      if ! [[ $f =~ "0002.tif" ]]; then

        file_type=`identify -quiet $f | cut -d" " -f2`

        if [ "$file_type" = "TIFF" ]; then

          compression_type=`identify -verbose -quiet $f | grep Compression | cut -d" " -f4`

          if [ "$compression_type" = "JPEG" ]; then
            mogrify -compress Group4 -quiet $f
          fi
        fi
      fi 
    fi
  done

  cd ../../..

done
