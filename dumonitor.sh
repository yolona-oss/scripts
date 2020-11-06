#!/bin/bash 
threshold="90"
i=2
result=`df -kh |grep -v "Filesystem" | awk '{ print $5 }' | sed 's/%//g'`

for percent in $result; do
	if ((percent > threshold))
	then
		partition=`df -kh | head -$i | tail -1| awk '{print $1}'`
		echo "$partition is ${percent}% full"

	fi
	let i++
done
