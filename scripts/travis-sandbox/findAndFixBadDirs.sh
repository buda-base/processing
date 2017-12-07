#!/bin/sh

dest="/Volumes/WebArchive"
folder_name="images"

cd $dest

for w in `ls -d W*`;
do
if [ -d $dest/$w/$folder_name ]; then
  if ! ls $dest/$w/$folder_name | grep 'W[0-9A-Z]*-I[0-9]*' &> /dev/null; then
    if ! ls $dest/$w/$folder_name | grep 'W[0-9A-Z]*-[0-9]*' &> /dev/null; then
      #echo "==$w=="
      bad_dir=`ls $dest/$w/$folder_name | grep -v 'W[0-9A-Z]*-I[0-9]*' | grep -v 'W[0-9A-Z]*-[0-9]*'`
      #echo "$bad_dir"

      if ls $dest/$w/$folder_name/$bad_dir/*0001.tif &> /dev/null; then
        ig_filename=`ls $dest/$w/$folder_name/$bad_dir/*0001.tif | xargs basename`
        image_group_tag=`echo $ig_filename | cut -c -$((${#ig_filename}-8))`
        #echo "$image_group_tag"

        echo "Renaming $bad_dir to $w-$image_group_tag..."
        mv $dest/$w/$folder_name/$bad_dir $dest/$w/$folder_name/$w-$image_group_tag
      else
        if ls $dest/$w/$folder_name/$bad_dir/*0003.* &> /dev/null; then
          ig_filename=`ls $dest/$w/$folder_name/$bad_dir/*0003.* | xargs basename`
          image_group_tag=`echo $ig_filename | cut -c -$((${#ig_filename}-8))`
          #echo "$image_group_tag"
	
          echo "Renaming $bad_dir to $w-$image_group_tag..."
          mv $dest/$w/$folder_name/$bad_dir $dest/$w/$folder_name/$w-$image_group_tag
        else
          echo "cannot determine image group tag"
        fi
      fi
    fi
  fi
fi 
done
