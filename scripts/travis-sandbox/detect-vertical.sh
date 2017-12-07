#!/bin/sh

cd $1
for w in `ls -d W*`; do
  cd $w

  if [ -d "images" ]; then
    cd images

    for f in `find . -iname "*.jpg" -o -iname "*.tif"`; do
      size=`identify $f | cut -d" " -f3`
      w=`echo $size | cut -d"x" -f1`
      h=`echo $size | cut -d"x" -f2`

      if [ $h -gt $w ]; then
        if ! [[ $f =~ "0001.tif" ]]; then
          if ! [[ $f =~ "0002.tif" ]]; then
            echo "Vertical detected - $f"
          fi
        fi
      fi

    done

    cd ..
  else
    echo "images dir does not exist in $w"
  fi

  cd ..
done
