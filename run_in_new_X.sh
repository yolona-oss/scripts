#!/bin/sh

sudo X :3 -ac &

cd $1

sleep 2

DISPLAY=:3 /bin/nice -20 $2

sudo /usr/bin/kill $(ps ax|awk 'NR==1; /X :3/ {print $1}'|sed 1d)
