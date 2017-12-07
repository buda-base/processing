#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for dir in `ls -d W*`; do
  image_group=`basename $dir | cut -d"-" -f2`
  image_number=3
  echo "$dir:"
  echo ""
  cd $dir 

  for file in `gls -v *.jpg`; do
    image_number_zero_padded=`printf "%04d" $image_number`
    new_filename=$(echo ${image_group}${image_number_zero_padded}.jpg)
    echo "$file-->$new_filename"
    mv -nv $file $new_filename
    ((image_number++))
  done

  cd ..
done

IFS="$OIFS"
