#!/bin/bash

# backup to TBRCRS2 disk station in Cambridge

# assumes hrih is local to tbrcrs2 in Cambridge
REMHOST=10.0.1.12
REMUSER=rsync
PASSFILE="/indium/scripts/tbrcrs2.secrets"

XDATE=`date '+%G%m%d%H%M'`
XYEAR=`date +%Y`

BROWSER="/indium/browser"
EXIST="/indium/exist"

BACKUPARCHIVE="/indium/backup-archives"
LOGARCHIVE="/indium/logs-archives"
SCRIPTS="/indium/scripts"


#indium exist config sync
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $EXIST/tomcat/bin/ $REMUSER@$REMHOST::hrih-indium-exist-tomcat-bin
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $EXIST/tomcat/conf/ $REMUSER@$REMHOST::hrih-indium-exist-tomcat-conf
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $EXIST/tomcat/webapps/exist/WEB-INF/conf.xml $REMUSER@$REMHOST::hrih-indium-exist-tomcat-webapps-exist-WEB-INF
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $EXIST/tomcat/webapps/exist/WEB-INF/log4j.xml $REMUSER@$REMHOST::hrih-indium-exist-tomcat-webapps-exist-WEB-INF

#indium browser config sync
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $BROWSER/tomcat/bin/ $REMUSER@$REMHOST::hrih-indium-browser-tomcat-bin
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $BROWSER/tomcat/conf/ $REMUSER@$REMHOST::hrih-indium-browser-tomcat-conf
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $BROWSER/tomcat/webapps/ROOT/WEB-INF/web.xml $REMUSER@$REMHOST::hrih-indium-browser-tomcat-webapps-ROOT-WEB-INF
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $BROWSER/tomcat/webapps/apps/ $REMUSER@$REMHOST::hrih-indium-browser-tomcat-webapps-apps

#sync scripts
rsync -azb --suffix=$XDATE --password-file=$PASSFILE $SCRIPTS $REMUSER@$REMHOST::hrih-indium-scripts

# sync database backups
rsync -az --password-file=$PASSFILE $BACKUPARCHIVE $REMUSER@$REMHOST::hrih-indium-exist-backups

# sync exist and browser logs
rsync -az --password-file=$PASSFILE $LOGARCHIVE $REMUSER@$REMHOST::hrih-indium-logs
