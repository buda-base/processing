#!/bin/sh


  OIFS="$IFS"
  IFS=$'\n'

  src="/Users/tbrc/staging/sync2archive"
  eBookHome="/Users/tbrc/staging/eBooks"
  eBookOutput="${eBookHome}/generated/sync2archive"
  eBookWorklist="${eBookHome}/worklist/sync2archive.txt"
  eBookLog="${eBookHome}/logs/sync2archive.txt"

echo $src
echo $eBookHome
echo $eBookOutput
echo $eBookWorklist
echo $eBookLog

  if [ -d $eBookOutput ] ; then
    rm -rf $eBookOutput
  fi
  mkdir -p $eBookOutput

  cd $src

  ls -1 > $eBookWorklist

  cd $eBookHome

  sh scripts/create-ebooks.sh $eBookWorklist $eBookOutput 2>$eBookLog

  if [ $? -ne 0 ]; then
    printf "`cat $eBookLog`" | mail -s "eBook generation failures" travis@tbrc.org
  fi

  cd $eBookOutput

  for workFolder in `ls`;
  do
    w=`echo $workFolder | cut -d"-" -f1`
    echo "cp -r $workFolder/ $src/$w/eBooks"
    cp -r "$workFolder/" "$src/$w/eBooks"
  done

  IFS="$OIFS"
