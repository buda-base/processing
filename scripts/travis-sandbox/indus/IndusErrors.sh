#!/bin/bash
: <<'DOCUMENTATION'
Author: Morris Hopkins
Date: 20130812

Note: 	I am not sure if this will be useful, but in the future we may change 
		the program not to exit when an error is encountered and instead catch
		particular error codes within a loop and handle them as needed.  Right 
		now this functionality is not implemented.

ERROR EXIT STATUS:
		199 - There was a problem with the arguments supplied to the script
		198 - There was no images directory found for the work specified
		197 - No title pages found for volume
		196 - No .JOB folders were found for the volume
		195 - Wrong number of .JOB folders
		194 - Can't find order_pages.xml

DOCUMENTATION



function arg_error () {
	local DIR=$1 #Directory that can't be found
	echo "*****\nThe arguments supplied were not correct.  Please try again."
	if [ "$DIR" ]; then
		echo "Directory: $1 NOT FOUND"
		echo "sh IndusMain.sh -h for more information."
	fi
	echo "STOPPING...................."
	echo "*****"
	exit 199;
}

#Tabbing is important in this function. 
#Make sure the closing MissingErr is flush left
function no_images_error () {
	local DIR=$1
	echo "*****"
	echo "The directory specified does not contain an images directory."
	echo "Directory: $DIR"
	echo "sh IndusMain.sh -h for more information."
	echo "STOPPING...................."
	echo "*****"
	exit 198;
}

function missing_title_pages_error () {
	local DIR=$1
	echo "*****"
	echo "There were no title pages for the specified volume."
	echo "Directory: $DIR"
	echo "sh IndusMain.sh -h for more information."
	echo "CONTINUING..............."
	echo "*****"
	# exit 197;
}

function job_folder_missing_error () {
	local DIR=$1
	echo "*****"
	echo "There were no .JOB Folders for the specified volume."
	echo "Directory: $DIR"
	echo "sh IndusMain.sh -h for more information."
	echo "STOPPING...................."
	echo "*****"
	exit 196;
}


function job_folder_count_error () {
	local DIR=$1
	echo "*****"
	echo "There are an invalid number of JOB folders.  Must be 1 or 2."
	echo "Directory: $DIR"
	echo "sh IndusMain.sh -h for more information."
	echo "STOPPING...................."
	echo "*****"
	exit 195;
}

function order_pages_file_error() {
	local DIR=$1
	echo "*****"
	echo "The order_pages.xml file cannot be found."
	echo "Directory: $DIR"
	echo "sh IndusMain.sh -h for more information."
	echo "STOPPING...................."
	echo "*****"
	exit 194;
}

