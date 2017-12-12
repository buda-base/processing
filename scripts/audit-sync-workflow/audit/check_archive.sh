#!/bin/sh

for w in `ls -d W*`; do
  ssh -p 15363 admin@inner.tbrc.org "ls -d /volume1/Archive/$w" &> /dev/null

  if [ $? -eq "0" ]; then
    echo $w
  fi
done
