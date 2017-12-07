#!/bin/sh

src="/Volumes/Archive"
dest="/Volumes/Local_Archive"

if [ ! -d "$src" ]; then
  echo "ERROR: $src not found"
  exit 1
fi

if [ ! -d "$dest" ]; then
  echo "ERROR: $dest not found"
  exit 1
fi

cd $src

for w in `ls -d W*`; do
  mkdir -p "$dest/$w"

  if [ -d "$w/images" ]; then
    rsync -av --delete "$w/images/" "$dest/$w/images"
  fi
 
  if [ -d "$w/web" ]; then
    rsync -av --delete "$w/web/" "$dest/$w/web"
  fi
done
