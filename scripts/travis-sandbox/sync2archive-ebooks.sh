#! /bin/bash

src="/Users/tbrc/staging/sync2archive"

dest="/Volumes/Archive"

xdate=`date +"%m-%d-%Y"`
xtime=`date +"%r"`
xmlDateTimeNum=`date -u +%F%H%M | sed 's/-//g' | sed 's/://g'`
xmlDateTimeUTC=`date -u +%FT%T.000Z`

emailFile="/Users/tbrc/staging/logs/emailData.txt"
logFile="/Users/tbrc/staging/logs/sync-ebooks-${xdate}.txt"
xmlFileName="synced-${xmlDateTimeNum}.xml"
xmlFileFullPath="/Users/tbrc/staging/logs/$xmlFileName"

totalWorks=0
totalWorksSynced=0

if [ ! -d $src ] ; then
	echo "ERROR: ${src} does not exist" | tee -a $logFile
	exit 1
fi

#if [ ! -d $dest ] ; then
#	echo "ERROR: ${dest} is not mounted" | tee -a $logFile
#	exit 1
#fi	

  echo "***********************************************" | tee -a $logFile
  echo "* Generating eBooks..." | tee -a $logFile
  echo "*" | tee -a $logFile
  echo "* ${xdate} | ${xtime}" | tee -a $logFile
  echo "***********************************************" | tee -a $logFile

  OIFS="$IFS"
  IFS=$'\n'

  eBookHome="/Users/tbrc/staging/eBooks"
  eBookOutput="${eBookHome}/generated/sync2archive"
  eBookWorklist="${eBookHome}/worklist/sync2archive.txt"
  eBookLog="${eBookHome}/logs/sync2archive.txt"

  if [ -d $eBookOutput ] ; then
    rm -rf $eBookOutput
  fi
  mkdir -p $eBookOutput

  cd $src

  ls -1 > $eBookWorklist

  cd $eBookHome

  sh scripts/create-sync2archive-ebooks.sh $eBookWorklist $eBookOutput 2>$eBookLog

  if [ $? -ne 0 ]; then
    printf "`cat $eBookLog`" | mail -s "eBook generation failures" travis@tbrc.org
  fi

  cd $eBookOutput

  for workFolder in `ls`;
  do
    w=`echo $workFolder | cut -d"-" -f1`
    echo "cp -rv $workFolder/ $src/$w/eBooks"
    cp -rv "$workFolder/" "$src/$w/eBooks"
  done
 
  IFS="$OIFS"
