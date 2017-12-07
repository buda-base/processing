#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d

    archive_num=`ls ../../archive/$d/*.* | wc -l`
    images_num=`ls *.* | wc -l`

    if [ $archive_num -ne $images_num ]; then
      echo $d
      echo "a: $archive_num"
      echo "i: $images_num"
    fi

    cd ..
  done

  cd ../..
done
