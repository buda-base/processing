#!/bin/sh

left_folder=$1
right_folder=$2
work_number=$3
job_name=$4

log_dir="/Users/tbrc/staging/logs/bc/$job_name"

if [ ! -d $log_dir ]; then
  mkdir -p $log_dir
fi

diff -rq --exclude-from=compareIgnore.txt $left_folder $right_folder > /dev/null

diffstatus=$?

if [ $diffstatus -eq 1 ]; then
  echo "$work_number" >> $log_dir/diff_worklist.txt
  bcomp -silent "@compare.bc" "$left_folder" "$right_folder" "$log_dir/$work_number.html"
else
  echo "$work_number" >> $log_dir/same_worklist.txt
fi
