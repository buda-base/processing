#!/bin/sh

for w in `ls -d W*`; do
  cd $w

  if [ -d "images" ]; then
    cd images
    for i in `ls`; do
      cd $i
      imgGrp=`echo $i | cut -d'-' -f 2`

      if ls 1* &> /dev/null; then
        for f in `ls 1*`; do
          echo $f"-------------->"$imgGrp$f

          if [ $f != "${imgGrp}0001.tif" ]; then
            if [ $f != "${imgGrp}0002.tif" ]; then
              mv $f $imgGrp$f
            fi
          fi
        done
      fi
      cd ..
    done
    cd ..
  fi
  cd .. 
done
