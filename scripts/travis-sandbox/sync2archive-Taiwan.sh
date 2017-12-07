#!/bin/sh

if [ $# -lt 1 ] ; then
	echo "This script requires a single argument to indicate the type of sync being executed - \"archive\" or \"web\""
	exit 1
fi

syncType=$1

src="/Users/tbrc/staging/sync2archive"

if [ $syncType = "archive" ] ; then
	dest="admin@inner.tbrc.org:/volume1/Archive"
elif [ $syncType = "web" ] ; then
	dest="S3"
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
    
    if [ syncType = "archive" ] && [ ! -d "${workFolder}/archive" ] ; then
	    echo "WARNING: ${workFolder}/archive not found.  ${workFolder} will not be synced until this is resolved." | tee -a $logFile
	    break
    fi

	echo $'\n' | tee -a $logFile
	echo "================================" | tee -a $logFile
	echo "= Syncing ${workFolder}" | tee -a $logFile
	echo "================================" | tee -a $logFile
	
	if [ $syncType = "archive" ] ; then	
		rsync -av -I $src/$workFolder/ $dest/$workFolder | tail -3 | tee -a $logFile
	fi
	
	rsyncStatus=${PIPESTATUS[0]}
	
	if (( $rsyncStatus == 0 )) ; then
		totalWorksSynced=$((totalWorksSynced+1))
	fi
	
	if [ $syncType = "web" ] ; then
		hashDir=`printf "$workFolder" | md5 | cut -c1-2`
		echo "Syncing $workFolder/images to s3://archive.tbrc.org/Works/$hashDir/$workFolder"
                aws s3 sync --only-show-errors $src/$workFolder/images s3://archive.tbrc.org/Works/$hashDir/$workFolder/images
	fi

done

	if [ $syncType = "web" ] ; then
		echo $'\n' | tee -a $logFile
		echo "================================" | tee -a $logFile
		echo "= Refresh images on the website " | tee -a $logFile
		echo "================================" | tee -a $logFile
		curl "https://www.tbrc.org/browser/ImageService?refresh=yes" | tee -a $logFile
		
		# email staff that Works have been synced to WebArchive
		printf "The following Work(s) have been synced to WebArchive and are now available on the website:\n\n`ls -1`" | mail -s "Works synced to WebArchive" travis@tbrc.org

	fi

echo $'\n' | tee -a $logFile
echo "${totalWorksSynced}\\${totalWorks} Work(s) have been synced to ${dest}" | tee -a $logFile
echo "***********************************************" | tee -a $logFile
echo $'\n' | tee -a $logFile

# email sanity check information
echo "File count comparison:" > $emailFile

for workFolder in `ls $src`;
do
	printf "\n${workFolder}\n" >> $emailFile
	
	if [ $syncType = "archive" ] ; then	
		echo "Src=`find ${src}/$workFolder -type f | wc -l`" >> $emailFile
		echo "Dest=`find ${dest}/$workFolder -type f ! -size 0 | wc -l`" >> $emailFile
	elif [ $syncType = "web" ] ; then
		echo "Src=`find ${src}/$workFolder/images -type f | wc -l`" >> $emailFile
                echo "Dest=`/usr/local/bin/aws s3 ls s3://archive.tbrc.org/Works/$hashDir/$workFolder/images --recursive | wc -l`" >> $emailFile
	fi	
done

echo $'\n' >> $emailFile
echo "${totalWorksSynced} out of ${totalWorks} Work(s) have been synced to ${dest}" >> $emailFile

cat $emailFile | mail -s "Sanity check for recent sync" travis@tbrc.org
rm $emailFile

if [ $syncType = "web" ] ; then
  # create XML data for WEB sync event
  echo "<synced when=\"$xmlDateTimeUTC\">" >> $xmlFileFullPath

  for workFolder in `ls $src`;
  do
    echo "<work>$workFolder</work>" >> $xmlFileFullPath
  done

  echo "</synced>" >> $xmlFileFullPath

  echo "---"

  # upload xml file to database
  echo "Uploading $xmlFileName to exist DB"
  result=`curl --user $syncUserCreds -s -i -X PUT -H 'Content-Type: application/xml' --data-binary @$xmlFileFullPath $existDBSyncedURL/$xmlFileName > /dev/null`

  # update database with page count info for each volume of every work
  for workFolder in `ls $src`;
  do
    for imageGroupFolder in `ls $workFolder/images`;
    do
      pushd $workFolder/images/$imageGroupFolder > /dev/null

      imageGroupRID=`echo $imageGroupFolder | cut -d"-" -f2`
      imageGroupPageCount=`find * -iname "*.jpg" -o -iname "*.tif" -o -iname "*.jpeg" -o -iname "*.tiff" | wc -l | xargs`
      imageGroupPageListing="$imageGroupRID-list.txt"

      find * -iname "*.jpg" -o -iname "*.tif" -o -iname "*.jpeg" -o -iname "*.tiff" | sort | tr '\n' '|' | sed 's/.$//' | tr -d '\n' > $imageGroupPageListing

      echo "Updating page count for ${imageGroupRID} - ${imageGroupPageCount} pages"
      result=`curl --user $syncUserCreds --form "list=@$imageGroupPageListing" --form ig=$imageGroupRID --form pages=$imageGroupPageCount $existDBIGUpdaterURL > /dev/null`
      
      rm $imageGroupPageListing

      popd > /dev/null
    done  
  done
fi
