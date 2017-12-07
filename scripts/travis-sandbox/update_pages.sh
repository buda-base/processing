#!/bin/sh

workDir=$1

SYNC_USER_CREDS="USERNAME:PASSWORD"

if [ -d $workDir/images ]; then
  pushd $workDir/images > /dev/null
  
  for d in `ls`; do
    pushd $d > /dev/null

    IG_RID=`pwd | cut -d"-" -f2`

    PAGE_COUNT=`find * -iname "*.jpg" -o -iname "*.tif" -o -iname "*.jpeg" -o -iname "*.tiff" | wc -l | xargs`

    PAGE_LIST="$IG_RID-list.txt"
    find * -iname "*.jpg" -o -iname "*.tif" -o -iname "*.jpeg" -o -iname "*.tiff" | sort | tr '\n' '|' | sed 's/.$//' | tr -d '\n' > $PAGE_LIST

echo "**************************"
echo $IG_RID
echo $PAGE_COUNT
cat $PAGE_LIST
echo "**************************"

    curl --user $SYNC_USER_CREDS --form "list=@$PAGE_LIST" --form ig=$IG_RID --form pages=$PAGE_COUNT "http://www.tbrc.org:51173/exist/rest/db/modules/admin/imagegroups-updater.xql"

    rm $PAGE_LIST
    popd > /dev/null
  done
  
  popd > /dev/null
else
  echo "ERROR: $workDir does not contain a proper images folder."
  exit 1
fi

