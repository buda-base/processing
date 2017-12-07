#!/bin/sh

#image group dir
igDir=$1

# "l" or "r"
if [ "$2" = "r" ]; then
  direction=90
else
  direction=270
fi

#script intended to work on image group folders (W*-*)
      cd $1

      for f in `ls *.jpg *.tif`; do
        size=`identify $f | cut -d" " -f3`
        w=`echo $size | cut -d"x" -f1`
        h=`echo $size | cut -d"x" -f2`

        if [ $h -gt $w ]; then
          if ! [[ $f =~ "0001.tif" ]]; then
            if ! [[ $f =~ "0002.tif" ]]; then
              mogrify -rotate $direction $f
            fi
          fi
        fi
      done
