#!/bin/bash

list=$HOME/documents/.sys-todo
id=$(( 1 + $(wc -l $list | awk '{print $1}') ))
root_parent=0

column -i 1 -p 2 -r 3 $list

while getopts "a:er:" ACT; do
	case $ACT in
		a)
			if [[ -n $(awk '/,/' <<< $OPTARG) ]]; then
			       	content="$(cut -d "," -f 1 <<< "$OPTARG")" 
				root="$(cut -d "," -f 2 <<< "$OPTARG")"
				parent=0
				while read line; do
					let parent++	
					[[ "$(sed 's/[0-9]* [0-9]* //' <<< "$line")" == "$root" ]] && break
				done < $list
				echo "$id $parent $content" >> $list
			elif [[ -n $(awk '!/,/' <<< $OPTARG) ]]; then
				root_name="$OPTARG"
				echo "$id $root_parent $root_name" >> $list
			fi	
			;;
		e)
			${EDITOR:-vi} $list
			;;
		r)
			if [[ $OPTARG =~ *,* ]]; then 
				while read entry; do
					[[ $(cut -d " " -f 3- <<< "$entry") =~ $(cut -d "," -f 1 <<< "$OPTARG") ]]
				done < $list	
			fi	
			;;
	esac
done
