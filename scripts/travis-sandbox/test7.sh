#!/bin/sh

f1="I12340001.tif"
f2="I12340003.tif"

if ! [[ $f1 =~ "0001.tif" ]]; then
  echo $f1
fi
if ! [[ $f2 =~ "0001.tif" ]]; then
  echo $f2
fi
