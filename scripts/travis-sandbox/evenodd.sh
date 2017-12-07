#!/bin/sh

for i in `ls -d W*`; do
  cd $i

  mkdir odd
  mkdir even

  mv -v *[13579].jpg odd  
  mv -v *[02468].jpg even

  cd ..
done
