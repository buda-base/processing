#!/bin/sh

array1=(1 2 3 4)
array2=( "${array1[@]}")
echo ${array1[*]}
#array2=("${array1[@]:0:1}")
echo ${array2[*]}
