#!/bin/bash
: <<'DOCUMENTATION'
Author: Morris Hopkins
Date: 20130804
Description: Redone version of the Image Procession script for the Indus

Dependencies:  For now it is dependent on a reasonably smart user.

Instructions for use:
1)



DOCUMENTATION

#Includes START here (ORDER IS IMPORTANT)
MY_DIR=`dirname $0`
. $MY_DIR/IndusErrors.sh
. $MY_DIR/IndusFunctions.sh
. $MY_DIR/IndusDriver.sh 

#Includes END here


# Make sure that some arguments are passed to the function.
################################################################################
if [[ -z "$@" ]]; then
	echo "Script must be run with arguments."
	help_menu
	exit 1;
fi


# Check if help is asked for anywhere in the args
################################################################################
array_contains_help "${@}" 
if [ $? == 0 ]; then 
	help_menu
	exit 1;
fi


# Loop over command line arguments.
# Instatntiate variables for processing
################################################################################
INDEX=0
ARGS=("${@}")
BIG_FOLDER=''
WORK_NUMBER=''
WORK_PATH=''
OFFSET=0
for var in "$@"; do
	# echo "$var"
	# echo "$INDEX"
	# echo "${ARGS[$INDEX]}"
	if [[ $var == "-d" ]]; then
		BIG_FOLDER="${ARGS[$INDEX+1]}"
		all_in_folder "$BIG_FOLDER"
		echo processing work in directory $BIG_FOLDER
	elif [[ $var == "-dw" ]];then
		BIG_FOLDER="${ARGS[$INDEX+1]}"
		WORK_NUMBER="${ARGS[$INDEX+2]}"
		work_in_folder "$BIG_FOLDER" "$WORK_NUMBER"
		echo $BIG_FOLDER
		echo $WORK_NUMBER
	elif [[ $var == "-w" ]];then
		WORK_PATH="${ARGS[$INDEX+1]}"
		if [[ ${ARGS[$INDEX+2]} == "-o" ]]; then
			OFFSET="${ARGS[$INDEX+3]}"
		fi
		echo processing work $WORK_PATH
		process_work "$WORK_PATH" "$OFFSET"
	fi
	let INDEX=INDEX+1
done

