#!/bin/bash

get_img_resolution() {
	file "${*}" | grep -o -E ', [0-9]* *x *[0-9]*,' | sed 's/,//g' | sed 's/\ //g'
}

mw=$(( $(xrandr | grep "\*+" | cut -dx -f1 | sed 's/ //g') - 300 ))
mh=$(( $(xrandr | grep "\*+" | cut -dx -f2 | cut -d' ' -f 1) - 300 ))

path=${*}
[[ -d "${path}" ]] || exit 1
list=/tmp/resolution_scan
>${list}
declare -a imgs

find "${path}" \( ! -regex '.*/\..*' \) -type f | while read line; do
	w=$(get_img_resolution "${line}" | cut -d 'x' -f 1)
	h=$(get_img_resolution "${line}" | cut -d 'x' -f 2)
	if (( ${w} > ${h} )) && (( ${w} >= ${mw} )) && (( ${h} >= ${mh} )); then
		# imgs+=("${line}")
		echo "${line}" >> $list
	fi
done

sxiv $(< ${list}) &
# echo ${imgs[@]}
