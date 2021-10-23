#!/bin/bash

fetchHistory()
{
	echo "Fetching history"
	node battlesGetData.js
	node data/combine.js
	cp data/history.json data/newHistory.json
}

run()
{
	while (( 1 ))
	do
		fetchHistory
		echo "Starting bot"
		node index.js > /dev/null
	done
}

BOT_STORE="$HOME/projects/sl_bots"

ACCOUNT="$BOT_STORE/$1"

cd "$ACCOUNT"

if [[ $2 == "noecho" ]]
then 
	run
else
	echo "Accaunt number $1"
	echo "$(grep ACCOUNT $ACCOUNT/.env)"
	echo "$(grep PASSWORD $ACCOUNT/.env)"
	run
fi
