#!/bin/sh

if [ $# -lt 1 ] ; then
	echo "This script requires a single argument to indicate the type of sync being executed - \"all\" or \"web\""
	exit 1
fi

syncType=$1

src="/Users/tbrc/staging/sync2archive"

if [ $syncType = "all" ] ; then
	dest="/Volumes/Archive"
elif [ $syncType = "web" ] ; then
	dest="tbrc@10.0.1.4::repository_sync"
fi

xdate=`date +"%m-%d-%Y"`
xtime=`date +"%r"`
xmlDateTimeNum=`date -u +%F%H%M | sed 's/-//g' | sed 's/://g'`
xmlDateTimeUTC=`date -u +%FT%T.000Z`

emailFile="/Users/tbrc/staging/logs/emailData.txt"
logFile="/Users/tbrc/staging/logs/sync-${syncType}-${xdate}.txt"
xmlFileName="synced-${xmlDateTimeNum}.xml"
xmlFileFullPath="/Users/tbrc/staging/logs/$xmlFileName"

syncUserCreds="USERNAME:PASSWORD"
existDBSyncedURL="http://www.tbrc.org:51173/exist/rest/db/tbrc/synced"
existDBIGUpdaterURL="http://www.tbrc.org:51173/exist/rest/db/modules/admin/imagegroups-updater.xql"

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
echo "* Syncing the following folders in ${src} to ${dest}:" | tee -a $logFile
echo "* "`ls ${src}` | tee -a $logFile
echo "*" | tee -a $logFile
echo "* ${xdate} | ${xtime}" | tee -a $logFile
echo "***********************************************" | tee -a $logFile

cd $src

for workFolder in `ls ${src}`; 
do
	totalWorks=$((totalWorks+1))

    if [ ! -d "${workFolder}/images" ] ; then
	    echo "WARNING: ${workFolder}/images not found.  ${workFolder} will not be synced until this is resolved." | tee -a $logFile
	    break
    fi
    
    if [ syncType = "all" ] && [ ! -d "${workFolder}/archive" ] ; then
	    echo "WARNING: ${workFolder}/archive not found.  ${workFolder} will not be synced until this is resolved." | tee -a $logFile
	    break
    fi

	echo $'\n' | tee -a $logFile
	echo "================================" | tee -a $logFile
	echo "= Syncing ${workFolder}" | tee -a $logFile
	echo "================================" | tee -a $logFile
	
	rsyncStatus=${PIPESTATUS[0]}
	
	if (( $rsyncStatus == 0 )) ; then
		totalWorksSynced=$((totalWorksSynced+1))
	fi
	
	if [ $syncType = "web" ] ; then
		hashDir=`printf "$workFolder" | md5 | cut -c1-2`
		echo "Syncing $workFolder/images to s3://archive.tbrc.org/Works/$hashDir/$workFolder"
                aws s3 sync --only-show-errors $src/$workFolder/images s3://archive.tbrc.org/Works/$hashDir/$workFolder/images
	fi

	if [ $syncType = "all" ] ; then
		hashDir=`printf "$workFolder" | md5 | cut -c1-2`
		echo "Syncing $workFolder/eBooks to s3://archive.tbrc.org/Works/$hashDir/$workFolder"
                aws s3 sync --only-show-errors $src/$workFolder/eBooks s3://archive.tbrc.org/Works/$hashDir/$workFolder/eBooks
	fi
done

	if [ $syncType = "web" ] ; then
		echo $'\n' | tee -a $logFile
		echo "================================" | tee -a $logFile
		echo "= Refresh images on the website " | tee -a $logFile
		echo "================================" | tee -a $logFile
		curl "https://www.tbrc.org/browser/ImageService?refresh=yes" | tee -a $logFile
		
	fi
