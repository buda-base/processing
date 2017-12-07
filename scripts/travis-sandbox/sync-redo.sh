#!/bin/sh

src=`pwd`
dest1="/Volumes/Archive"
dest2="/Volumes/WebArchive"

for d in `find . -type d -depth 3 | cut -c 2-`; do
  rsync -av --delete "$src$d/" "$dest1$d"
  rsync -av --delete "$src$d/" "$dest2$d"
done
