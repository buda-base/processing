#!/bin/bash

XDATE=`date '+%G%m%d%H%M'`
XYEAR=`date +%Y`

# NOTES
# print file ctime in seconds since epoch time
# stat -r  full* | awk '{print $10}'
# 
# print filename of newest fullbackup
# stat -t "%D %R" -f "%Sc %N"  full* | tail -n 1 | awk '{print $3}'
#

BACKUPDIR="/indium/db-backups"
BACKUPARXIV="/indium/backup-archives"
BROWSER="/indium/browser"
EXIST="/indium/exist"
LOGXEXIST="/indium/logs-archives/exist"
LOGXBROWSER="/indium/logs-archives/browser/tomcat"


NEWEST=`stat -t "%D %R" -f "%Sc %N"  $BACKUPDIR/full* | tail -n 1 | awk '{print $3}'`
SPLITTIME=`stat -r  $NEWEST | awk '{print $10}'`
NEW2=`stat -t "%D %R" -f "%Sc %N"  $BROWSER/tomcat/logs/localhost.log.* | tail -n 1 | awk '{print $3}'`
SPLIT2=`stat -r  $NEW2 | awk '{print $10}'`
NEW3=`stat -t "%D %R" -f "%Sc %N"  $EXIST/tomcat/logs/localhost.log.* | tail -n 1 | awk '{print $3}'`
SPLIT3=`stat -r  $NEW3 | awk '{print $10}'`
# NEW4=`stat -t "%D %R" -f "%Sc %N"  $EXIST/tomcat/webapps/exist/WEB-INF/logs/* | tail -n 1 | awk '{print $3}'`
# SPLIT4=`stat -r  $NEW3 | awk '{print $10}'`

#echo "NEWEST: $NEWEST"
#echo "SPLITTIME: $SPLITTIME"

echo db backups
for i in $BACKUPDIR/*.zip; do
#	temptime=`stat -r $i | awk '{print $10}'`
#	if [ "$temptime" -lt "$SPLITTIME" ]; then
		echo "Moving $i"
		mv $i $BACKUPARXIV/
#	fi
done

echo browser tomcat logs: SPLIT2 $SPLIT2
for i in "$BROWSER"/tomcat/logs/*; do
	temptime=`stat -r $i | awk '{print $10}'`
	if [ "$temptime" -lt "$SPLIT2" ]; then
		echo "Moving $i $LOGXBROWSER/"
		mv $i $LOGXBROWSER/
	fi
done

echo eXist tomcat logs: SPLIT3 $SPLIT3
for i in "$EXIST"/tomcat/logs/*; do
	temptime=`stat -r $i | awk '{print $10}'`
	if [ "$temptime" -lt "$SPLIT3" ]; then
		echo "Moving $i $LOGXEXIST/tomcat/"
		mv $i $LOGXEXIST/tomcat/
	fi
done

echo eXist logs
for i in "$EXIST"/tomcat/webapps/exist/WEB-INF/logs/*.log.*; do
	echo "Moving $i $LOGXEXIST/exist/$XDATE.`echo $i | awk -F "/" '{print $NF}'`"
	mv $i $LOGXEXIST/exist/$XDATE.`echo $i | awk -F "/" '{print $NF}'`
done
