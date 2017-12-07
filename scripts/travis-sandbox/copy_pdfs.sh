#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

folder_num=16

for d in `ls archive/PDFS | sort -n`; do
    i="W1KG14-I1KG$folder_num"

    echo "Copying $d-->$i"
    cp -rv "archive/PDFS/$d/" "images/$i"

    ((folder_num++))
done

IFS="$OIFS"
