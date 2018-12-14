#!/usr/bin/env bash 
#
# Tar using a set of files
# file format is
# nnn[GB]\s*/volume[123]/_sharename/*
# First, chop off the prefix

[ ! -f "$1" ]  && { echo source listing :"$1": not found ; exit 1 ; }

[ ! -d "$2" ] && { echo source dir :"$2": not found ; exit 1 ; }
srcd="$2"

[ -z  "$3" ] && { echo output tar:"$3": not found ; exit 1 ; }
tarf="$3"

modsrc=$(mktemp)
# Elide the leading size and any blanks
sed -E 's?^.*M[[:space:]]+??'  "$1" > $modsrc

# Get a total est size ready
totalSize=$(awk -FM '{sum += $1} END {print sum/1024"G" }' "$1")

echo "Estimated total size = $totalSize"
tar --ignore-failed-read --auto-compress -C $srcd --exclude '*@*' --checkpoint=50000 --checkpoint-action=ttyout='%{%Y-%m-%d %H:%M:%S}t (%d sec): #%u, %T%*\r' -cf $tarf -T $modsrc

