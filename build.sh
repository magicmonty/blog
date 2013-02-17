#!/bin/sh
compass compile && wintersmith build

MD5=md5sums

if [ -x /sbin/md5 ]; then
	MD5="md5 -r"
fi 

find build -type f -print0 | xargs -0 $MD5 > md5sums.txt
