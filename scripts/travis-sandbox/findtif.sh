#!/bin/sh

scanReqsDir="/Users/tbrc/Downloads/scan-dirs"

for w in `ls -d W*`; do
  cd $w
  if [ -d "images" ]; then
    cd images
    for i in `ls`; do
      cd $i

      imgGrp=`echo $i | cut -d'-' -f 2`
      if ! ls $imgGrp"0001.tif" &> /dev/null; then
        echo $w"-->"$imgGrp"0001.tif"
#        if [ -d $scanReqsDir/$w/images/$i ]; then
#          cp $scanReqsDir/$w/images/$i/*.tif .
#        fi
      fi

      cd ..
    done
    cd ..
  fi
  cd .. 
done
