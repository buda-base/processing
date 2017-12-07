#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d

    f1=`ls | tail -1`
    f2=`ls | head -3 | tail -1`
    f3=`ls | head -50 | tail -1`

    r1=`identify -verbose $f1 | grep Res | cut -d":" -f2`
    r2=`identify -verbose $f2 | grep Res | cut -d":" -f2`
    r3=`identify -verbose $f3 | grep Res | cut -d":" -f2`

    echo $d
    echo "$f1 : $r1"
    echo "$f2 : $r2"
    echo "$f3 : $r3"

    cd ..
  done

  cd ../..
done
