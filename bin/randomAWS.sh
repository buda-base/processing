#!/usr/bin/env bash
inList=$1
nLines=${2-800}   # ${x-...} means use ... if ${x} is not declared
nPasses=${3-10}

randFile=$(mktemp)

for i in $(seq 1 $nPasses); do
    oList=${inList}_${i}.lst
    errList=${inList}_${i}.err
    printf "Pass:%05d o:%s e:%s\n" $i $oList $errList

    # Fresh start into randFile
    $snob/bin/randomline.sh $nLines $inList > $randFile

    # we dont care about successes, only fails
    while read anInc ; do
         # echo $anInc
         aws s3 ls "$inc/$anInc" >> ${oList} 2>> $errList
    done < $randFile
done

rm $randFile