#!/bin/sh

archiveDir="/volume1/Archive"
#logDir="/volume2/Admin/logs"
#logFile="$logDir/archive-audit-files-larger-than-5mb.txt"

if [ -d "$archiveDir" ]; then
  cd $archiveDir
else
  echo "ERROR: $archiveDir doesn't exist."
  exit 1
fi

echo "Finding files larger than 5MB in Archive - \"images\" folders"
echo ""

for w in `ls -d W*`; do
  if [ -d "$w/images" ]; then
#    echo "===$w/images===" | tee $logFile
    for f in `find $w/images -type f -size +5000k`; do
      echo `du -m $f`
    done
  fi
 
  if [ -d "$w/web" ]; then
#    echo "===$w/web===" | tee $logFile
    for f in `find $w/web -type f -size +5000k`; do
      echo `du -m $f`
    done
  fi

done

#loop through each work
# if images or web dir exists
#  look for > 5mb files
#   #log file name and size
#find W1KG16449 -name "images" -type d -print0 | xargs -0 -I{} find '{}' -type f -size +5M | tee $logFile
