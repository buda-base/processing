#!/bin/sh

hostname=`hostname`

if [ $hostname == "TBRCRS3" ]; then
  # TBRCRS3
  archiveDir="/volume1/Archive"
  logDir="/volume2/Admin/logs"
else
  # hrih
  archiveDir="/image"
  logDir="/Users/tbrc/logs"
fi

logFile="$logDir/archive-collect-data-timestamp.csv"

if [ -d "$archiveDir" ]; then
  cd $archiveDir
else
  echo "ERROR: $archiveDir doesn't exist."
  exit 1
fi

echo "Collecting data about the archive - work#, volumes, pages, file types, size"
echo ""
echo "This will take awhile..."
echo ""

printf "work#,volumes,pages,filetypes,size" > $logFile
printf "\n" >> $logFile

for w in `ls -d W*`; do
  workNumber="$w"

  printf "$w," >> $logFile

  if [ -d "$w/images" ]; then
    activeDir="$w/images"   
  else
    if [ -d "$w/web" ]; then
      activeDir="$w/web"
    fi
  fi

  volumeCount=`ls $activeDir | wc -l`
  pageCount=`find $activeDir -type f | wc -l`
  size=`du -sh $activeDir | cut -f1`

  printf "$volumeCount," >> $logFile
  printf "$pageCount," >> $logFile
  printf "$size" >> $logFile

  printf "\n" >> $logFile
  
done
