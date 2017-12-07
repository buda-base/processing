#!/bin/bash

#rsync -av W2PD16917/W2PD16917-I3PD655/ /Volumes/Archive/W2PD16917/archive/W2PD16917-I3PD655

#rsync -av W2PD16917/W2PD16917-I3PD825/ /Volumes/Archive/W2PD16917/archive/W2PD16917-I3PD825

#rsync -av W2PD16917/W2PD16917-I3PD826/ /Volumes/Archive/W2PD16917/archive/W2PD16917-I3PD826

for w in `find W* -type d -depth 2`; do
  echo "Syncing $w to Archive"
  rsync -av --delete $w/ /Volumes/Archive/$w
done

for w in `find W* -type d -depth 2 | grep images`; do
  echo "Syncing $w to WebArchive"
  rsync -av --delete $w/ /Volumes/WebArchive/$w
done

#for w in `find W301* -type d -depth 2`; do
#  rsync -av --delete $w/ /Volumes/Archive/$w
#done

#for w in `find W301* -type d -depth 2 | grep images`; do
#  rsync -av --delete $w/ /Volumes/WebArchive/$w
#done
