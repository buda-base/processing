#!/bin/bash


function help_menu(){
	echo "\n\n"     
	echo "____________________________ Help ____________________________"     
	echo "MUST BE RUN AS FOLLOWS:"     
	echo "  sh IndusMain.sh <option_1> <option_2>... <option_n>\n"
	echo "OPTIONS"
	echo "  -h:  prints this menu\n"  
	echo "  -d:  process a directory full of MANY works"
	echo "       sh IndusMain.sh -d <Directory of works>\n" 
	echo "  -w:  process the work at the specified path"
	echo "       sh IndusMain.sh -w <Absolute path to work>\n"   
	echo "  -dw: process SINGLE work from directory"
	echo "       sh IndusMain.sh -dw <Directory> <Work number>\n"
	echo "  -o:  page offset. Only to be used wtih -w\n"
	echo "  \n\n\n\n"
}


function array_contains_help () { 
	# echo "in array_contains function."
    local in=1
    for element in "${@}"; do
        if [[ $element == "-h" ]] || [[ $element == "-help" ]]; then
            in=0
            break
        fi
    done
    return $in
}


function all_in_folder () {
	local DIR=$1
	if [ ! -d  "$DIR" ]; then 
		arg_error "$DIR"
	fi
	for sub_dir in "$DIR"/*; do
		process_work "$sub_dir" 0 #passing in default offset
	done
}

function work_in_folder () {
	# $1 = Directory
	# $2 = Work number
	if [ ! -d  "$1/$2" ]; then 
		arg_error "$1/$2"
	fi
	process_work "$1/$2"
}

# Check for archive folder and make if needed.
# Move the S.JOB folder to the archive file.
function process_work () {
	local WORKPATH=$1
	local OFFSET=$2
	local WNUMBER=`basename "$WORKPATH"`
	echo "Working on : $WNUMBER"
	if [ ! -d  "$WORKPATH" ]; then 
		arg_error "$WORKPATH"
	fi
	check_images_archive "$WORKPATH"
	move_rename_files "$WORKPATH" "$OFFSET"
}