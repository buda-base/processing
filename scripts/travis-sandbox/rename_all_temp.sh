#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for dir in `ls -d W*`; do
  image_group=`basename $dir | cut -d"-" -f2`
  image_number=3
  echo "$dir:"
  echo ""
  cd $dir 

  for file in `gls -v`; do

    scanReqFile1=`echo $file | grep 'I.*0001.tif'`
    scanReqFile2=`echo $file | grep 'I.*0002.tif'`

    if [ "$scanReqFile1" == "" ]; then
      if [ "$scanReqFile2" == "" ]; then
        image_number_zero_padded=`printf "%04d" $image_number`
        file_ext="${file##*.}"
        new_filename=$(echo ${image_number_zero_padded}.${file_ext})
#        echo "$file-->$new_filename"
        mv -nv $file $new_filename
        ((image_number++))
      fi
    fi
  done

  cd ..
done

IFS="$OIFS"
