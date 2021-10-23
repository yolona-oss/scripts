#!/bin/bash

from=$1
to=$2

for (( i = $from; i < $to; i++))
do
	(sl_run_acc_bot.sh $i) &
done
