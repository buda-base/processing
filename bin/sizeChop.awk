#!/usr/bin/env awk -f
BEGIN {
    sum = 0 ;
    fileCount = 1
    chunkSize = 95 * 1024  # input is in M, scale to G
}


{
    sum += $1 ;
    
    if (sum >= chunkSize) {
	fileCount++
	print "redirect to " fileCoumt
	sum = 0
    }
    printf("%s\r",sum)
    print $0 >> "incoming.chunk."fileCount".size"

}

END {print sum/1024"G" }
