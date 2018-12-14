#!/usr/bin/env bash 
#
# Tar using a set of files
# file format is
# nnn[GB]\s*/volume[123]/_sharename/*

[ ! -f "$1" ]  && { echo source listing :"$1": not found ; exit 1 ; }

[ ! -d "$2" ] && { echo source dir :"$2": not found ; exit 1 ; }
srcd="$2"

# Get a total est size ready
totalSize=$(awk -FM '{sum += $1} END {print sum/1024"G" }' "$1")

# modsrc=$(mktemp)

# Chop the prefix
# awk -F$'\t' '{print $NF}' $1 > $modsrc
#

echo "Estimated total size = $totalSize"
# tar --ignore-failed-read --auto-compress -C $srcd --exclude '*@*' --checkpoint=50000 --checkpoint-action=ttyout='%{%Y-%m-%d %H:%M:%S}t (%d sec): #%u, %T%*\r' -cf $tarf -T $modsrc

declare -i t0
declare -i t1
declare -i szM
declare -i rate
while read adir ; do
    begin=$(date +%H:%M:%S)
    t0=$(date +%s)   #tick
    # separate size and path
    # Achtung! These quotes around $adir preserve the tab
    bdir=$(echo "$adir" | awk -F '\t' '{print $NF  }')
    # Translate out spaces
    cdir=$(echo $bdir | tr ' ' '_')
    
    # If a folder has spaces, tar it to a changed directory name 
    if [ "$bdir" != "$cdir" ] ; then
	echo "tar $cdir"
	tar --ignore-failed-read --auto-compress -C $srcd --exclude '*@*' --checkpoint=10000 --checkpoint-action=ttyout='%{%Y-%m-%d %H:%M:%S}t (%d sec): #%u, %T%*\r' --recursive -c  "${bdir}" | $snob/sno cp - s3://rs34.incoming.bdrc.org/${cdir}.tar --metadata snowball-auto-extract=true
#	mkdir -p "${srcd}${cdir}"
#	cp -rpv  "${srcd}${bdir}*/*" $srcd/$cdir
	#	bdir=$cdir
    else
	echo "Straight copy $bdir"
	$snob/sno cp $srcd/$bdir  s3://rs34.incoming.bdrc.org/$cdir --recursive --quiet
    fi

    t1=$(date +%s)  # tock
    szM=$(echo $adir | awk -FM '{print $1}')

    if ((t1 == t0)) ; then
	rate="(null)"
    else
	rate=$((szM/(t1-t0)))
    fi

    echo $(date +%H:%M:%S)  : $begin :   $rate "MiB/sec" $adir
done < $1
