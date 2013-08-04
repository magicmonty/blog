#!/bin/sh
compass compile && ./node_modules/wintersmith/bin/wintersmith build

MD5=md5sum

if [ -x /sbin/md5 ]; then
	MD5="md5 -r"
fi 

find build -type f -print0 | xargs -0 $MD5 > md5sums.txt
