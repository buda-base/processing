#!/bin/sh

src="/Users/tbrc/staging/sync2archive"

xdate=`date +"%m-%d-%Y"`
xtime=`date +"%r"`
xmlDateTimeNum=`date -u +%F%H%M | sed 's/-//g' | sed 's/://g'`
xmlDateTimeUTC=`date -u +%FT%T.000Z`

emailFile="/Users/tbrc/staging/logs/emailData.txt"
logFile="/Users/tbrc/staging/logs/sync-${syncType}-${xdate}.txt"
xmlFileName="synced-${xmlDateTimeNum}.xml"
xmlFileFullPath="/Users/tbrc/staging/logs/$xmlFileName"
yncUserCreds="USERNAME:PASSWORD"
existDBSyncedURL="http://www.tbrc.org:51173/exist/rest/db/tbrc/synced"
syncUserCreds="USERNAME:PASSWORD"
  echo "<synced when=\"$xmlDateTimeUTC\">" >> $xmlFileFullPath

  for workFolder in `ls $src`;
  do
    echo "<work>$workFolder</work>" >> $xmlFileFullPath
  done

  echo "</synced>" >> $xmlFileFullPath

  result=`curl --user $syncUserCreds -s -i -X PUT -H 'Content-Type: application/xml' --data-binary @$xmlFileFullPath $existDBSyncedURL/$xmlFileName > /dev/null`
