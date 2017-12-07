#/bin/sh

#curl -O "http://www.tbrc.org/scan-requests/scan-dirs-WXXXXX.zip"

worksDir=$1
scanReqURL="http://www.tbrc.org/scan-requests"
origDir=$PWD

if [ -d $worksDir ]; then
  cd $worksDir
else
  echo "$worksDir does not exist"
  exit 1
fi

for w in `ls -d W*`; do
  numVols=`curl -s "https://www.tbrc.org/public?module=work&query=num-vols&args=$w"`

  if [ "$numVols" -eq "1" ]; then
    if [ ! -d $w/images ]; then
      "Creating images dir for $w ..." 
      scanReqFile="scan-dirs-${w}.zip"

      cd $w

      echo "$scanReqURL/$scanReqFile"
      curl -O "$scanReqURL/$scanReqFile"

      if [ -f "$scanReqFile" ]; then
        unzip $scanReqFile
        rm $scanReqFile
        mv $w/images .
        rm -rf $w
        mv *.* images/W*
      else
        echo "Can't find $scanReqFile"
      fi

      cd ..
    else
      echo "$w: images dir already exists"
    fi
  else
    echo "$w: this is a multi-volume work.  skipping..."
  fi
done

cd $origDir
