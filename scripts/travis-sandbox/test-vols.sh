#/bin/sh

worksDir="/Users/tbrc/staging/sync2archive"
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
    echo "$w: single volume work"
  else
    echo "$w: this is a multi-volume work.  skipping..."
  fi
done

cd $origDir
