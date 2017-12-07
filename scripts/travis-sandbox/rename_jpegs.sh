#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for dir in `ls -d W*`; do
  image_group=`basename $dir | cut -d"-" -f2`
  image_number=3

  cd $dir 

  for file in `ls *.jpg | xargs sh /Users/tbrc/staging/processing/scripts/travis-sandbox/sort-version-2.sh`; do
    image_number_zero_padded=`printf "%04d" $image_number`
    new_filename=$(echo ${image_group}${image_number_zero_padded}.jpg)
#    mv -nv $file $new_filename
    echo "$file-->$new_filename"
    ((image_number++))
  done

  cd ..
done

IFS="$OIFS"
