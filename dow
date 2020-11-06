#!/bin/sh

sudo X :3 -ac &

cd "/usr/local/games/Warhammer.40.000.Dark.Crusade"
#cd "/mnt/disk/Kerbal Space Program 1.6/game/"

sleep 2

DISPLAY=:3 /bin/nice -20 /usr/bin/wine  # DarkCrusade.exe
#DISPLAY=:5 ./"KSP.x86_64"

sudo /usr/bin/kill $(ps ax|awk 'NR==1; /X :3/ {print $1}'|sed 1d)
