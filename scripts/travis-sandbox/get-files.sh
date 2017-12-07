#!/bin/sh

for w in `cat redo.txt`; do
  rsync -av /Volumes/WebArchive/$w/ /Volumes/staging/redo/$w 
done
