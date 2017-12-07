#!/bin/bash
#Islam Adel
#2014-03-27 First Lines
#2014-03-31 Added help text
#Sort Version Numbers
# Tested on Mac OS X 10.9

# 9 digits held by "#" (sorted before numbers in alphabetical order)
# Translate each separated input into 9 digited field (17.0.8 --> ######17.########0.########8
# sort
# Translate back

#######################################

#Readme

#Usage: sort-version.sh numeric-version-numbers
# Use "." separated version numbers as input arguments
# example: sort-version.sh $(echo -ne "17.0.9\n17.0.11\n17.0.8")
# OR: sort-version.sh 17.0.7 17.0.11 17.0.8

#######################################

#SET Global Variables here
#SET full lenght 9x #
full="#########"

#SET Default delimiter here
IFS=" 
"
#default?
#IFS=$' \t\n'

#backup old IFS
#OLDIFS=$IFS

#define input version numbers
#echo ${@}
p=${@}

#exit error code 1 if no arguments defined
if [[ -z ${@} ]]; then exit 1; fi

####sample input
#p="17.0.8
#17.0.11
#17.0.9"

#####################################

#List all input Values
for i in $(echo ${p})
do
	x=
	#Trim the dots between the values and treat separately
	for k in $(echo ${i} | sed 'y/./\n/')
	do
		#count the number of characters in version number
		#trim this number from the full length of #########
		#set the a new value for the version number with a fixed length
		#combine the divided numbers by dots previously to one string
		#add the dots again
		x=${x}${full:$(echo ${k} | wc -m)}${k}.
		#a dot remains at the end
	done
	#divide each version number by new line
	#trim the last dot
	#add the previous version to a new line
	#only if a previous version is available
	if [[ ! -z ${y} ]];then
		y="${y}
$(echo ${x} | sed 's/.$//')"
	else
		y=$(echo ${x} | sed 's/.$//')
	fi
done
#SET New delimiter as new line break
IFS='\n'
#Now sort Alphabetically and remove the fixed length
echo ${y} | sort | sed 's/#//g'
#Restore IFS?
#IFS=$OLDIFS
exit 0