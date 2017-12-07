#!/bin/bash

# backup to bodhi in Cambridge

# assumes hrih is local to bodhi in Cambridge
REMHOST=10.0.1.31
REMUSER=tbrc

#PASSFILE="/indium/scripts/tbrcrs3.secrets"
#XDATE=`date '+%G%m%d%H%M'`
#XYEAR=`date +%Y`

WEBARCHIVE="/image/"

# sync webarchive
#rsync -a --password-file=$PASSFILE $WEBARCHIVE $REMUSER@$REMHOST::webarchive
rsync -av --exclude=".*" $WEBARCHIVE $REMUSER@$REMHOST::webarchive
