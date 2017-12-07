#!/bin/sh

cd $1

for w in `ls -d W*`; do
  cd $w

  if [ -d "images" ]; then
    cd images
    for i in `ls`; do
      cd $i
      imgGrp=`echo $i | cut -d'-' -f2`

#      if ls $imgGrp* &> /dev/null; then
        echo "$w:"
        for f in `find . ! -name "$imgGrp*"`; do
          echo $f

        done
#      fi
      cd ..
    done
    cd ..
  fi
  cd .. 
done
