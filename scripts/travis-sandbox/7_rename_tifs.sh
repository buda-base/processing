#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for dir in `ls -d W*`; do
  image_group=`basename $dir | cut -d"-" -f2`
  image_number=15

  cd $dir 

  for file in `ls *.tif | sort -n`; do
    image_number_zero_padded=`printf "%04d" $image_number`
    new_filename=$(echo ${image_group}${image_number_zero_padded}.tif)
    #mv -nv $file $new_filename
    echo $file $new_filename
    ((image_number++))
  done

  cd ..
done

IFS="$OIFS"
