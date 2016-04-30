#!/bin/sh

rsync -avr --rsh="ssh" --delete-after --delete-excluded _site/* ssh-1855-mg@blog.pagansoft.de:~/blog
