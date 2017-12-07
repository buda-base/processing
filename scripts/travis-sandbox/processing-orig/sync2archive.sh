#! /bin/bash

if [ $# -lt 1 ] ; then
	echo "This script requires a single argument to indicate the type of sync being executed - \"all\" or \"web\""
	exit 1
fi

syncType=$1

src="/Volumes/processing/sync2archive"

if [ $syncType = "all" ] ; then
	dest="/Volumes/Archive"
elif [ $syncType = "web" ] ; then
	dest="tbrc@10.0.1.4::repository_sync"
fi

xdate=`date +"%m-%d-%Y"`
xtime=`date +"%r"`

emailFile="../logs/emailData.txt"
logFile="../logs/sync-${syncType}-${xdate}.txt"

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

# if [ $syncType = "all" ] ; then
# 
#   echo "***********************************************" | tee -a $logFile
#   echo "* Generating eBooks..." | tee -a $logFile
#   echo "*" | tee -a $logFile
#   echo "* ${xdate} | ${xtime}" | tee -a $logFile
#   echo "***********************************************" | tee -a $logFile
# 
#   ebookHome="/Volumes/processing/eBooks"
#   ebookOutput="${ebookHome}/generated"
#   ebookWorklist="${ebookHome}/worklist/sync2archive.txt"
#   ebookLog="${ebookHome}/logs/sync2archive.txt"
# 
#   if [ -d $ebookOutput ] ; then
#     rm -rf $ebookOutput
#   fi
#   mkdir $ebookOutput
# 
#   ls -1 $src > $ebookWorklist
# 
#   cd $ebookHome
# 
#   sh create-ebooks.sh $ebookWorklist $ebookOutput 2>$ebookLog
# 
#   cd $ebookOutput
# 
#   for workFolder in `ls -d eBook-* | cut -c 7-`;
#   do
#     cp -r eBook-$workFolder/ $src/$workFolder/eBooks 
#   done
# 
#   if [ $? -ne 0 ]; then
#     printf "`cat $ebookLog`" | mail -s "eBook generation failures" travis@tbrc.org
#   fi
#   
# fi

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
	
	if [ $syncType = "all" ] ; then	
		rsync -av --delete $src/$workFolder/ $dest/$workFolder | tail -3 | tee -a $logFile
	elif [ $syncType = "web" ] ; then
		rsync -av --delete --password-file=/Volumes/processing/scripts/hrih.scrt --progress --exclude="#recycle" --exclude="OCR" --exclude="eBooks" --exclude=".DS_Store" --exclude="Thumbs.db" --exclude="@eaDir" --exclude="archive" --exclude="prints" $src/$workFolder $dest | tail -3 | tee -a $logFile
	fi
	
	rsyncStatus=${PIPESTATUS[0]}
	
	if (( $rsyncStatus == 0 )) ; then
		totalWorksSynced=$((totalWorksSynced+1))
	fi
	
done

	if [ $syncType = "web" ] ; then
		echo $'\n' | tee -a $logFile
		echo "================================" | tee -a $logFile
		echo "= Refresh images on the website " | tee -a $logFile
		echo "================================" | tee -a $logFile
		curl "http://tbrc.org/browser/ImageService?refresh=yes" | tee -a $logFile
		
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
	
	if [ $syncType = "all" ] ; then	
		echo "Src=`find ${src}/$workFolder -type f | wc -l`" >> $emailFile
		echo "Dest=`find ${dest}/$workFolder -type f ! -size 0 | wc -l`" >> $emailFile
	elif [ $syncType = "web" ] ; then
		echo "Src=`find ${src}/$workFolder/images -type f | wc -l`" >> $emailFile
		echo "Dest=`ssh -l tbrc -p 15345 10.0.1.4 find /image/$workFolder/images -type f ! -size 0 | wc -l`" >> $emailFile
	fi	
done

echo $'\n' >> $emailFile
echo "${totalWorksSynced} out of ${totalWorks} Work(s) have been synced to ${dest}" >> $emailFile

cat $emailFile | mail -s "Sanity check for recent sync" travis@tbrc.org
rm $emailFile