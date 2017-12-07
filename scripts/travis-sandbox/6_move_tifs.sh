#!/bin/sh

for w in `ls -d W*`; do

  mv $w/converted/a/*.tif $w
  mv $w/converted/b/*.tif $w
  
done
