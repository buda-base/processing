#!/bin/sh

args=("$@") 

for (( i=0;i<${#args[@]};i++)); do 
  echo ${args[${i}]} 
done
