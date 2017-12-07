#!/bin/sh

echo ""
echo "*****************************************************************"
echo "* #1 - ARCHIVE/IMAGES FILE COUNT MATCH"
echo "*****************************************************************"

auditCheck1Failed=false

for w in `ls -d W*`; do
  cd $w/images

  for d in `ls`; do
    cd $d

    archive_num=`ls ../../archive/$d/*.* | wc -l`
    images_num=`ls *.* | wc -l`

    if [ $archive_num -ne $images_num ]; then
      auditCheck1Failed=true

      echo "-- DISCREPANCY FOUND --"
      echo "$d"
      echo "a: $archive_num"
      echo "i: $images_num"
    fi

    cd ..
  done

  cd ../..
done

echo ""

if $auditCheck1Failed; then
  echo "AUDIT CHECK #1 STATUS -- FAILED"
else
  echo "AUDIT CHECK #1 STATUS -- PASSED"
fi

echo ""

echo ""
echo "*****************************************************************"
echo "* #2 - CHECK FILENAME CORRECTNESS"
echo "*****************************************************************"
echo ""

auditCheck2Failed=false

for w in `ls -d W*`; do
  cd $w

  if [ -d "images" ]; then
    cd images
    for i in `ls`; do
      cd $i
      imgGrp=`echo $i | cut -d'-' -f2`
      echo "$w:"
      for f in `find . ! -name "$imgGrp*"`; do
        echo $f
      done
      cd ..
    done
    cd ..
  fi
  cd ..
done


echo ""
echo "*****************************************************************"
echo "* #3 - CHECK FOR UNCOMPRESSED TIFS IN ARCHIVE FOLDER"
echo "*****************************************************************"
echo ""

for w in `ls -d W*`; do
    for f in `find $w -name "*.tif"`; do

    if ! [[ $f =~ "0001.tif" ]]; then
      if ! [[ $f =~ "0002.tif" ]]; then

        file_type=`identify -quiet $f | cut -d" " -f2`

        if [ "$file_type" = "TIFF" ]; then

          compression_type=`identify -verbose -quiet $f | grep Compression | cut -d" " -f4`
          if [ "$compression_type" = "None" ]; then
            echo "***UNCOMPRESSED TIF FOUND: $f***"
          fi
        fi
      fi 
    fi

    done
done

echo ""
echo "*****************************************************************"
echo "* #4 - CHECK FOR FILES > 400K in IMAGES FOLDER"
echo "*****************************************************************"
echo ""

for w in `ls -d W*`; do
  find $w/images -size +400k
done
