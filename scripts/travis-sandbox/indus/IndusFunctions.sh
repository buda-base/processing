#!/bin/bash


# Checks if archive directory exists in 
################################################################################
function check_images_archive () {
	local DIR=$1
	has_images_dir "$DIR"
	if [ $? -eq 0 ]; then
		if [ ! -d "$DIR/archive" ]; then 
			make_archive "$DIR"
		fi
	else
		no_images_error "$DIR"
	fi
}

function has_images_dir () {
	local DIR=$1
	if [ ! -d "$DIR/images" ]; then
		return 1
	fi
	return 0
}

# Create archive folder
# Create image directories e.g. W1111/archive/W1111-I1KG124
# Copy tiffs over to archive
################################################################################
function make_archive () {
	local DIR=$1
	mkdir "$DIR"/archive
	for image_dir in "$DIR"/images/*; do
		dirname=`basename "$image_dir"`
		imagenum=`echo $dirname | awk -F "-" '{print $2}'`
		mkdir "$DIR"/archive/"$dirname"
		check_title_pages "$DIR" "$dirname" "$imagenum"
		cp "$DIR"/images/"$dirname"/"$imagenum"*.tif "$DIR"/archive/"$dirname"/
		local count=`ls -1 "$DIR"/images/"$dirname"/*.JOB* 2>/dev/null | wc -l`
		if [ "$count" -gt 0 ]; then
			mv "$DIR"/images/"$dirname"/S*.JOB*  "$DIR"/archive/"$dirname"/
		else
			job_folder_missing_error "$DIR"/images/"$dirname"
		fi
	done
}


function check_title_pages () {
	local DIR="$1"
	local dirname="$2"
	local imagenum="$3"
	title_page_count=`ls -1 $DIR/images/$dirname/$imagenum*.tif 2>/dev/null | wc -l`
	if [ "$title_page_count" -le 0 ]; then 
		missing_title_pages_error "$DIR/images/$dirname/"
		get_title_pages "$DIR" "$dirname" "$imagenum"
	fi
}


# This is just a stub 
# Try to get the scan request from the ftp server and grab the title 
# pages from there
function get_title_pages() {
	local DIR="$1"
	local dirname="$2"
	local imagenum="$3"
	convert -size 500x800 xc:white "$DIR"/images/"$dirname"/"$imagenum"0001.jpg
	convert -size 500x800 xc:white "$DIR"/images/"$dirname"/"$imagenum"0002.jpg
	echo "Placeholder files created."
}


function move_rename_files() {
	local DIR="$1"
	local OFFSET="$2"
	for image_dir in "$DIR"/archive/*; do
		dirname=`basename "$image_dir"` # W111-I111
		imagenum=`echo $dirname | awk -F "-" '{print $2}'` #I111
		# Job count already checked.  So it is safe to assume this will return
		# a valid number.
		job_count=`ls -1d "$DIR"/archive/"$dirname"/*.JOB* 2>/dev/null | wc -l | tr -d ' '`
		 echo "$DIR"/archive/"$dirname"
		 echo "$job_count"
		if [ "$job_count" -eq "1" ]; then
			JOB_FOLDER=`ls -1d "$DIR"/archive/"$dirname"/*.JOB*`
			echo "Job Folder: $JOB_FOLDER"
			echo "Image Directory: `echo $image_dir | sed 's/archive/images/g'`"
			move_to_images "`echo $image_dir | sed 's/archive/images/g'`" "$JOB_FOLDER" 1 "$OFFSET"
		elif [ "$job_count" == "2" ]; then
			echo processing 2 job folders in dirname
			echo 2 jobs not yet supported
		else
			job_folder_count_error "$DIR"/archive/"$dirname"
		fi 
	done
}


function move_to_images () {
	local CURRENT_DIR="$1"
	local JOB_FOLDER="$2"
	local STEP_SIZE=$3
	local OFFSET="$4"
	dirname=`basename "$CURRENT_DIR"`
	imagenum=`echo $dirname | awk -F "-" '{print $2}'` # e.g. I43562
	if [ ! -e "$JOB_FOLDER/order_pages.xml" ]; then
		order_pages_file_error "$JOB_FOLDER"
	fi
	#Get the order of the images from the file.
	grep -i ".jpg" "$JOB_FOLDER"/order_pages.xml | awk -F "<|>" '{ print $3 }'>"$JOB_FOLDER"/images.txt
	
	# Find out if preview images exist 
	IMG_INDEX=3;
	preview_count=`ls -1 "$JOB_FOLDER"/*_pr* 2>/dev/null | wc -l | tr -d ' '`
	# echo "Preview Count: $preview_count"
	exec<"$JOB_FOLDER"/images.txt
	while read line
	do
		newname=$imagenum`printf "%04d" $IMG_INDEX`
		if [ "$preview_count" -gt 0 ]; then 
			cp `echo "$JOB_FOLDER"/"$line" | sed 's/.JPG/_pr.JPG/g'` "$CURRENT_DIR"/"$newname".jpg
		else
			cp "$JOB_FOLDER"/"$line" "$CURRENT_DIR"/"$newname".jpg

		fi
		let IMG_INDEX+="$STEP_SIZE"
	done
	if [ ! "$preview_count" -gt 0 ]; then 
		mogrify -format jpg -resize 50% -quality 50% "$CURRENT_DIR"/*.jpg
	fi


	# mkdir "$JOB_FOLDER"/images
	# mkdir "$JOB_FOLDER"/optimized
	# if [ ! -e "$CURRENT_DIR"/*.JOB*
}


