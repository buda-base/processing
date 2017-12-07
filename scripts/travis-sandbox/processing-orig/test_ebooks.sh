#!/bin/sh

#if [ $# -lt 1 ] ; then
#	echo "This script requires a single argument to indicate the type of sync being executed - \"all\" or \"web\""
#	exit 1
#fi

#syncType=$1

src="/Volumes/processing/sync2archive"

#if [ $syncType = "all" ] ; then
#	dest="/Volumes/Archive"
#elif [ $syncType = "web" ] ; then
#	dest="tbrc@10.0.1.4::repository_sync"
#fi

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

echo "***********************************************" | tee -a $logFile
echo "* Generating eBooks..." | tee -a $logFile
echo "*" | tee -a $logFile
echo "* ${xdate} | ${xtime}" | tee -a $logFile
echo "***********************************************" | tee -a $logFile

ebookHome="/Volumes/processing/eBooks"
ebookOutput="${ebookHome}/generated"
ebookWorklist="${ebookHome}/worklist/sync2archive.txt"
ebookLog="${ebookHome}/logs/sync2archive.txt"

if [ -d $ebookOutput ] ; then
  rm -rf $ebookOutput
fi
mkdir $ebookOutput

ls -1 $src > $ebookWorklist

cd $ebookHome

sh create-ebooks.sh $ebookWorklist $ebookOutput 2>$ebookLog

cd $ebookOutput

for workFolder in `ls -d eBook-* | cut -c 7-`;
do
  cp -r eBook-$workFolder/ $src/$workFolder/eBooks 
done

if [ $? -ne 0 ]; then
  printf "`cat $ebookLog`" | mail -s "eBook generation failures" travis@tbrc.org
fi