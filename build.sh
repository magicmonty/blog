#!/bin/sh
compass compile && wintersmith build
find build -type f -print0 | xargs -0 md5sum > md5sums.txt
