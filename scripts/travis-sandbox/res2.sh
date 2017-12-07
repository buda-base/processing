#!/bin/sh

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d

    f1=`ls | head -1`
    f2=`ls | head -2 | tail -1`
    f3=`ls | head -3 | tail -1`
    f4=`ls | tail -2 | head -1`
    f5=`ls | tail -1`

    r1=`identify -verbose $f1 | grep Res | cut -d":" -f2`
    r2=`identify -verbose $f2 | grep Res | cut -d":" -f2`
    r3=`identify -verbose $f3 | grep Res | cut -d":" -f2`
    r4=`identify -verbose $f4 | grep Res | cut -d":" -f2`
    r5=`identify -verbose $f5 | grep Res | cut -d":" -f2`

    echo $d
    echo "$f1 : $r1"
    echo "$f2 : $r2"
    echo "$f3 : $r3"
    echo "$f4 : $r4"
    echo "$f5 : $r5"

    cd ..
  done

  cd ../..
done
