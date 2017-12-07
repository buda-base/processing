#!/bin/sh

  echo "<synced when=\"$xmlDateTimeUTC\">" >> $xmlFile

  for workFolder in `ls $src`;
  do
    echo "<work>$workFolder</work>" >> $xmlFile
  done

  echo "</synced>" >> $xmlFile

  # upload xml file to database
  result=`curl --user USERNAME:PASSWORD -i -X PUT -H 'Content-Type: application/xml' --data-binary @$xmlFileFullPath http://www.tbrc.org:51173/exist/rest/db/tbrc/synced/$xmlFileName`
