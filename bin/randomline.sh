#!/usr/bin/env bash
# Randomly sample a file line.
# $RANDOM returns a different random integer at each invocation.
# Nominal range: 0 - 32767 (signed 16-bit integer).

MAXCOUNT=$1
srcFile=$2

srcLen=$(wc -l $srcFile | awk '{print $1}')

[  $MAXCOUNT -gt $srcLen ] && { MAXCOUNT=$((srcLen - 8 )) ;}
count=1
randomLineNumbers=()

#echo
#echo "$MAXCOUNT random numbers:"
#echo "-----------------"

while [ "$count" -le $MAXCOUNT ]      # Generate 10 ($MAXCOUNT) random integers.
do
    randomLineNumbers+=($((  ${RANDOM} % ${srcLen}  )))
   # printf ":%d\t%d\n" $count ${randomLineNumbers[((count-1))]}

  let "count += 1"  # Increment count.
done

# Sort the random array
IFS=$'\n' randomLineNumbers=($(sort -un <<<"${randomLineNumbers[*]}"))
#
#rlen=${#randomLineNumbers[@]}
#i=0
#while  [ $i -le $rlen  ]   ; do
#    printf "%d\t%d\n" $i ${randomLineNumbers[$i]}
#    (( i++ ))
#done

#
#for frelm in ${randomLineNumbers[*]} ; do
#    echo $frelm
#done


randIndex=0
linesRead=0


while read aLine ; do
#    printf "::ln%s\n" $linesRead
    # printf "::ln%s\taLine=%s\n" $linesRead $aLine
    [[ "${linesRead}" -eq "${randomLineNumbers[$randIndex]}" ]] && {
        # printf "ln=%d\tri=%d\t%s\n" $linesRead $randIndex "$aLine"
        echo  $aLine
        (( randIndex++ ))
    }
    (( linesRead += 1 ))

done < $srcFile

# If you need a random int within a certain range, use the 'modulo' operator.
# This returns the remainder of a division operation.

#RANGE=500
#
#echo
#
#number=$RANDOM
#let "number %= $RANGE"
##           ^^
#echo "Random number less than $RANGE  ---  $number"
#
#echo
