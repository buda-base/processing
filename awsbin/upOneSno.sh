#!/usr/bin/env bash 
#
# Tar and diurectly copy to snowball using a set of files
# file format is
# nnn[GB]\s*/volume[123]/_sharename/*
# First, chop off the prefix

[ ! -f "$1" ]  && { echo source listing :"$1": not found ; exit 1 ; }

[ ! -d "$2" ] && { echo source dir :"$2": not found ; exit 1 ; }
srcd="$2"

[ -z  "$3" ] && { echo output tar:"$3": not given ; exit 1 ; }
tarf="$3"

modsrc=$(mktemp)
#
# sed  's?.*volume./??' "$1" > $modsrc
# take 2. use a input format
# n*M\trelative  path.
# See dircp.sh
awk -F '\t' '{print $NF}' "$1" > $modsrc


# Get a total est size ready
totalSize=$(awk -FM '{sum += $1} END {print sum }' "$1")
realSize=$(( $totalSize * 1024 * 1024 * 1024 ))


printf "Start %s Estimated total size = %dG\n" $(date +%H:%M:%S)  $(( $totalSize / 1024 ))
tar --ignore-failed-read  -C $srcd --exclude '*@*'  -c  -T $modsrc |  aws s3  cp - s3://rs34.incoming.bdrc.org/$tarf --metadata snowball-auto-extract=true --profile snowballEdge --endpoint https://10.0.1.141:8443 --ca-bundle ~/tmp/snowball/10-0-1-141.pem --expected-size  $(( 100 * 1024 * 1024 * 1024 ))

 rc=$?
 sno ls rs34.incoming.bdrc.org | grep $tarf
 (( $rc == 0 )) && { stat="success";} || { stat="fail" ; }
 printf "End  %s  status %s \n" $(date +%H:%M:%S) $stat  

