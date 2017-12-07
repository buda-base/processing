#!/bin/bash
# Author: Morris Hopkins 
# Email: mo@tbrc.org
# Date (of last revision): 20120928
# Title: IndusImageProcessor.sh
# Version: 1.0.1

# Potential Revisions:  This script needs to be broken down into separate functions so the code can be more easily maintained.
# Dependencies: A working installation of imagemagick. 
#

# Description: This program accepts a folder of pre-structured scans from the Indus 
#              scanner and processes, renames, and prepares for archive.
#
# Instructions for preparation for archive:
#	0) After scanning is complete DO NOT USE the built in transfer function of the BCS2 Software.
#	   Instead a Completed_Scans folder should be created e.g. C:\Completed_Scans\
#	1) Download the scan request and unzip the work folder to the Completed_Scans folder.
#	2) Navigate to the scn_data folder under  C:\ProgramData\ImageWareComponents\BCS2\scn_data\ 
#	   and manually move the S000XXXX.JOB folders for the scanned work to the images directory
#	   in the Work folder just unzipped.  e.g. C:\Completed_Scans\W#\images\S000XXXX.JOB 
#	2.1) Scanning - Two scan jobs/volume
#		 If scanning is done with two S000XXXX.JOB folders per volume (e.g. odds/evens) than rename the S000XXXX.JOB folders
#		 to S000XXXX.JOB-A and S000XXXX.JOB-B
#
#		*Note - If two S000XXXX.JOB folder are being created per volume there should be no offset between the S000XXXX.JOB's
#				In other words, each S000XXXX.JOB  should comprised exactly half of the work, every other page (including the
#				cover and copyright pages) per S000XXXX.JOB.

# Formatting of input folder is as follows
# Work Directory>W#
# Work Directory>W#
# Work Directory>W#
# Work Directory>W#>images>image_group(s)>Title Pages
# Work Directory>W#>images>image_group(s)>S000XXXX.JOB (if a single S#.JOB folder is used per volume)
# Work Directory>W#>images>image_group(s)>S000XXXX.JOB-A (if two S#.JOB folders are used per volume)
# Work Directory>W#>images>image_group(s)>S000XXXX.JOB-B (if two S#.JOB folders are used per volume)
#										 >
#				   >archive>image_group(s)>TitlePages (nothing else)
#				...



#This line should be commented out befor this can be used.
#echo "Please open the file and read the documentation before using this tool."
#exit 1;

if [ ! $1 ]; then
	echo "ERROR: Missing arguments.";
	echo "IndusImageProcessor.sh <Directory with works to be processed>"
	exit 1;
fi

WORKDIR=$1;




for j in $WORKDIR/*/images/*/*/; do
	WORKLIST=$j/../offset.txt
	if [ -f $j/../offset.txt ]; then
  		echo "offset exists"
	else
		echo "0" >>$j/../offset.txt
	fi
	exec 3<&0
	exec 0<$WORKLIST
	#reads contents of current dir
	while read OFFSET
	do
		echo $j
		#echo "Is this a split Volume (y/n)?"
		#read ANSWER
		m=`echo $j | grep $"\-[A]/"`
		o=`echo $j | grep $"\-[B]/"`
		#if  [[ "$m" == "$j" || "$o" == "$j" ]]; then
		#Directories ending in SJOB-A
		if  [[ "$m" == "$j" ]]; then 			
			img=`echo $j | awk -F "/|-" '{print $(NF-3)}'`

			grep -i ".jpg" $j/order_pages.xml | awk -F "<|>" '{ print $3 }'>$j/images.txt
			mkdir $j/images
			mkdir $j/optimized
			INDEX=3
			exec<$j/images.txt
			while read line
				do
				if [ $INDEX -le $OFFSET ]; then
					echo $INDEX-le
					pandum=$img`printf "%04d" $INDEX`
					#cp $j/$line $j/images/$pandum.jpg
					cp `echo $j/$line | sed 's/.JPG/_pr.JPG/g'` $j/optimized/$pandum.jpg
					let INDEX+=1
				else
					pandum=$img`printf "%04d" $INDEX`
					#cp $j/$line $j/images/$pandum.jpg
					cp `echo $j/$line | sed 's/.JPG/_pr.JPG/g'` $j/optimized/$pandum.jpg
					let INDEX+=2
				fi
				done
			rm $j/images.txt		
			mv $j/optimized/$img* $j/..
			mkdir  $j/../../../archive
			mkdir $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
			mv $j $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
			cp `echo $j | awk -F "/" '{print $(NF-4) "/" $(NF-3)"/"$(NF-2)}'`/*.tif `echo $j | awk -F "/" '{print $(NF-4) "/archive/" $(NF-2)}'`
			#cp $j/../../images $j/../../archive
		#Directories ending in SJOB-B
	 	elif  [[ "$o" == "$j" ]]; then
 			img=`echo $j | awk -F "/|-" '{print $(NF-3)}'`
			DUDEX=$(($OFFSET+4))
			grep -i ".jpg" $j/order_pages.xml | awk -F "<|>" '{ print $3 }'>$j/images.txt
			mkdir $j/images
			mkdir $j/optimized
			exec<$j/images.txt
			while read line
			do 
				echo "$DUDEX"
				pandum=$img`printf "%04d" $DUDEX`
				#cp $j/$line $j/images/$pandum.jpg
				cp `echo $j/$line | sed 's/.JPG/_pr.JPG/g'` $j/optimized/$pandum.jpg
				let DUDEX+=2
			done
			rm $j/images.txt	
			mv $j/optimized/$img* $j/..
			mkdir  $j/../../../archive
			mkdir $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
			mv $j $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
			cp `echo $j | awk -F "/" '{print $(NF-4) "/" $(NF-3)"/"$(NF-2)}'`/*.tif `echo $j | awk -F "/" '{print $(NF-4) "/archive/" $(NF-2)}'`
			#cp $j/../../images $j/../../archive
	#Directories with only a single SJOB
	else
		img=`echo $j | awk -F "/|-" '{print $(NF-2)}'`
		grep -i ".jpg" $j/order_pages.xml | awk -F "<|>" '{ print $3 }'>$j/images.txt
		mkdir $j/images
		mkdir $j/optimized
		TRIDEX=3
		exec<$j/images.txt
		while read line
		do 
			pandum=$img`printf "%04d" $TRIDEX`
			#cp $j/$line $j/images/$pandum.jpg
			cp `echo $j/$line | sed 's/.JPG/_pr.JPG/g'` $j/optimized/$pandum.jpg
			let TRIDEX+=1
		done
		rm $j/images.txt	
		mv $j/optimized/$img* $j/..
		mkdir  $j/../../../archive
		mkdir $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
		mv $j $j/../../../archive/`echo $j | awk -F "/" '{print $(NF-2)}'`
		cp `echo $j | awk -F "/" '{print $(NF-4) "/" $(NF-3)"/"$(NF-2)}'`/*.tif `echo $j | awk -F "/" '{print $(NF-4) "/archive/" $(NF-2)}'`
		#cp $j/../../images $j/../../archive
fi

done
exec 0<&3
done

for m in $WORKDIR/*/images/*
do
mv $m/offset.txt `echo $m | sed 's/images/archive/g'`
done

for q in $WORKDIR/*/images/*
do
mogrify -format jpg -resize 50% -quality 44% $q/*.tif
done
rm $WORKDIR/*/images/*/*.tif

