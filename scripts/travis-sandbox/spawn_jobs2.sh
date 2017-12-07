#!/bin/sh

# Example usage:
# sh spawn_jobs2.sh 10 copy-to-snowball.sh /Volumes/Archive worklist.txt

if [ $# -lt 4 ] ; then
  echo "This script requires four arguments."
  echo "Example usage:"
  echo "sh spawn_jobs2.sh 10 copy-to-snowball.sh /Volumes/Archive worklist.txt"
  exit 1
fi

numJobs=$1
scriptName=$2
archiveDir=$3
workList=$4

logDir="../logs/${scriptName%.sh}"

#if [ ! -z $numJobs ]; then
#  echo "Must specify a number of jobs"
#  exit 1
#fi

#if [ ! -f $scriptName ]; then
#  echo "Script $scriptName does not exist"
#  exit 1
#fi

if [ -d "$logDir" ]; then
  rm -rf $logDir
fi

mkdir -p $logDir

if [ -d "$archiveDir" ]; then
  pushd $archiveDir > /dev/null
else
  echo "$archiveDir not found"
  exit 1
fi

#numDirs=`ls -d W* | wc -l`
numDirs=`cat $workList | wc -l`

groupingSize=$(bc <<< "$numDirs/$numJobs")
groupingIndex=0

#read -a dirs <<< `ls -d W*`
read -a dirs <<< `cat $workList`

popd > /dev/null

for ((n=1; n<=$numJobs; n++)); do
  if [ "$numJobs" -eq 1 ]; then
    # single job
    workingDirs=( "${dirs[@]}")
  else
    # multiple jobs
    if [ "$n" -eq "$numJobs" ]; then
      workingDirs=("${dirs[@]:$groupingIndex:$numDirs-1}")
    else
      workingDirs=("${dirs[@]:$groupingIndex:$groupingSize}")
    fi

    groupingIndex=$groupingIndex+$groupingSize 
  fi

  sh $scriptName $archiveDir "${workingDirs[@]}" > $logDir/${scriptName%.sh}_job$n.txt 2>&1 &
done
