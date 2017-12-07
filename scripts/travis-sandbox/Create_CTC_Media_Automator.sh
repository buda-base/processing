args=($@)
numArgs=${#args[@]}

destDir=${args[$numArgs-1]}
archiveDir=${args[$numArgs-2]}
ctcFiles=("${args[@]:0:$numArgs-2}")

logFile="$HOME/create_ctc_media_log.txt"

if [[ $archiveDir != *"Archive"* ]]; then
  echo "Invalid archive dir" >> $logFile
  exit 1
fi

echo "==========" > $logFile
echo "archive: $archiveDir" >> $logFile
echo "dest: $destDir" >> $logFile
echo "ctc files: ${ctcFiles[*]}" >> $logFile
echo "==========" >> $logFile
echo "" >> %logFile

for f in ${ctcFiles[@]}; do
  if [[ $f == *"works.txt"*  ]]; then
    ctcName=`basename $f | cut -d"-" -f1`

    echo "Copying works for $ctcName ..." >> $logFile

    for w in `cat $f`; do
      if [ ! -d $destDir/$ctcName/$w ]; then
        mkdir -p $destDir/$ctcName/$w
      fi    

      rsync -avq $archiveDir/$w/images/ $destDir/$ctcName/$w/images >> $logFile 2>&1
      rsync -avq $archiveDir/$w/eBooks/ $destDir/$ctcName/$w/eBooks >> $logFile 2>&1
    done

    echo "Finished copying works for $ctcName" >> $logFile
  else
    echo "File $f was selected but doesn't appear to be a CTC worklist." >> $logFile
    exit 1
  fi
done
