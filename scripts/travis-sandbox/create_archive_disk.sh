#!/bin/sh

src="/volume2/Archive"
dest="/volumeUSB1/usbshare"

for w in `ls $src/W*`; do
  rsync -av --dry-run $src/$w/ $dest/$w
done
