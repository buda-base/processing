#!/bin/sh

# Example usage:
# sh spawn_jobs.sh 4 compress-images.sh /Volumes/W2PD16917A/W3PD446

numJobs=$1
scriptName=$2
pathToWork=$3

imagesDir="$pathToWork/images"
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

if [ -d "$imagesDir" ]; then
  pushd $imagesDir > /dev/null
else
  echo "$imagesDir not found"
  exit 1
fi

numDirs=`ls | wc -l`
groupingSize=$(bc <<< "$numDirs/$numJobs")
groupingIndex=0

read -a dirs <<< `ls`

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

  sh $scriptName $imagesDir "${workingDirs[@]}" > $logDir/${scriptName%.sh}_job$n.txt 2>&1 &
done
