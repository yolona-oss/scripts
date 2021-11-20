#!/bin/bash
#Searching for image with passed
#resolution or monitor default resolution with some spread:)
#in $1 directory(dont pass single files)

#ARGUMENTS
#$1 - direcotry to scan
#$2 - resolution in WxH format, w-width, h-height

#All matches writes in /tmp/resolution_scan file
#After the end of scanning, a preview in opens with ${IMAGE_VIEWER} program(sxiv by default)

die() {
	echo $1
	exit 1
}

is_image() {
	finfo = $(file "$1")
	return [[ "$finfo" =~ .*"image".* ]]
}

get_img_resolution() {
	file "${*}" | grep -o -E ', [0-9]* *x *[0-9]*,' | sed 's/,//g' | sed 's/\ //g'
}

#matching resolution
mw=''
mh=''

if (($2)); then
	mw=${2%%x*}
	mh=${2##*x}
else
	mw=$(( $(xrandr | grep "\*+" | cut -dx -f1 | sed 's/ //g') - 300 ))
	mh=$(( $(xrandr | grep "\*+" | cut -dx -f2 | cut -d' ' -f 1) - 300 ))
fi

path=$(realpath "${1}")
[[ -d "${path}" ]] || die("There is no \"$path\" dir.")
list=/tmp/resolution_scan
>${list}
# declare -a imgs

# find "${path}" \( ! -regex '.*/\..*' \) -type f | 
find "${path}" \( ! -regex '.*/\..*' \) -type f -exec file {} \; | grep -o -P '^.+: \w+ image' 
  |while read line; do
	w=$(get_img_resolution "${line}" | cut -d 'x' -f 1)
	h=$(get_img_resolution "${line}" | cut -d 'x' -f 2)
	if (( ${w} > ${h} )) #TODO make it optional
		&& (( ${w} >= ${mw} ))
		&& (( ${h} >= ${mh} )); then
		# imgs+=("${line}")
		echo "${line}" >> $list
	fi
done

sxiv $(< ${list}) &
# echo ${imgs[@]}
