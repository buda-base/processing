#!/bin/sh

file1="W3CN4756/images/W3CN4756-I3CN4758/I3CN47580003.jpg"
file2="W3CN4774/images/W3CN4774-I3CN4776/I3CN47760003.jpg"
file3="W3CN4786/images/W3CN4786-I3CN4788/I3CN47880003.jpg"
file4="W3CN4792/images/W3CN4792-I3CN4794/I3CN47940003.jpg"

work1="W3CN4756"
work2="W3CN4774"
work3="W3CN4786"
work4="W3CN4792"

hashDir1=`printf "$work1" | md5 | cut -c1-2`
hashDir2=`printf "$work2" | md5 | cut -c1-2`
hashDir3=`printf "$work3" | md5 | cut -c1-2`
hashDir4=`printf "$work4" | md5 | cut -c1-2`

cp $file1 /Volumes/Archive/$file1
cp $file2 /Volumes/Archive/$file2
cp $file3 /Volumes/Archive/$file3
cp $file4 /Volumes/Archive/$file4

aws s3 cp $file1 s3://archive.tbrc.org/Works/$hashDir1/$file1
aws s3 cp $file2 s3://archive.tbrc.org/Works/$hashDir2/$file2
aws s3 cp $file3 s3://archive.tbrc.org/Works/$hashDir3/$file3
aws s3 cp $file4 s3://archive.tbrc.org/Works/$hashDir4/$file4
