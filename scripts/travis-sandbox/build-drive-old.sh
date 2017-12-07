#! /bin/sh

if [ $# -lt 1 ] ; then
	echo "This script requires a collection name as an argument."
	exit 1
fi

collection=$1

src="/volume2/Archive/eBooks-all"
dest="/volumeUSB1/usbshare"

errorLog="/volume2/Admin/logs/build-drive-errors.txt"

if [ ! -d "${dest}" ]; then
    echo "${dest} does not exist."
    exit 1
fi

mkdir "${dest}/${collection}-ebooks"

while IFS= read -r w <&3; do
	if [ ! -d "$src/eBook-$w" ]; then
		echo "eBook-$w does not exist."
	else
	    echo "Copying eBook-$w ..."
        rsync -av --exclude="@eaDir" --exclude="#*" $src/eBook-$w/ $dest/${collection}-ebooks/eBook-$w 2>$errorLog
	fi
done 3< "/volume2/Admin/$collection-works.txt"