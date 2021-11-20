#!/bin/bash

#Video thumbnail batch creator

create()
{
	# vcsi --grid 1x1 $(realpath "${line}") #--num-samples 1 --format jpg --quality 70 -o "${thumb_dir}/${name}.jpg" 
	vcs --interval=1m --numcaps=1 --quiet --ffmpeg --autoaspect --anonymous --jpeg "${1}" 2>/dev/null
	if (( $? != 0 )); then 
		err=1
		# echo "$(tput setaf 1) :: $(tput bold)Cant create thumb$(tput sgr0)$(tput setaf 7)"
	else
		mv "${1}.jpg" "${thumb_dir}/"
		if (( $? == 0 )) ;then 
			echo "${line}" >> "${DB}"
			# echo "$(tput setaf 10)$(tput bold) ::$(tput setaf 7)$(tput sgr0) Success"
			let passed++
		else
			err=1
		fi
	fi
	clear
}

print_status_bar_testing()
{ # $0 - err, $1 - printed chars
	for null in $(seq $(( ${2} + 1 )) ); do
		printf "\b"
	done
	(( ${1} == 1 )) && printf "$(tput setaf 1)"
	for null in $(seq ${bar_step}); do
		printf  "#"
	done
	printf "$(tput setaf 7)"
	for null in $(seq $(( ${2} - 2 )) ); do
		printf "-"
	done
	printf "]\n"
}

print_statu_bar()
{
	printf "\r["
	for null in $(seq $(( cur*bar_step )) );do
		printf "#"
	done
	for null in $(seq $(( columns - cur*bar_step - 2 )) ); do
		printf "-"
	done
	printf "]"
}

work_dir=$(realpath "${1}")
thumb_dir="${work_dir}/.thumbnails"
DB="${thumb_dir}/.db"
[[ -d "${work_dir}" ]] || exit 1
[[ -d "${thumb_dir}" ]] || mkdir "${thumb_dir}"
[[ -f "${DB}" ]] || touch "${DB}"
passed=0
cur=0

list=/tmp/ct.tmp
>${list}
find "${work_dir}" \( ! -regex '.*/\..*' \) -type f >> ${list}

sum=$(wc -l <<< $(<${list}))
sum=$(( sum - $(wc -l <<< $(<${DB})) ))

columns=$(tput cols)
bar_step=$(( columns / sum ))

cat ${list} | while read line; do
	err=0
	if [[ ! $(grep "${line}" "${DB}") ]]; then
		name=$(basename "${line}")

		printf "$(tput setaf 10)$(tput bold) ::$(tput setaf 7)$(tput sgr0) Processing ${name}\n"
		print_statu_bar 
		echo "${cur}/${sum}"

		if ! [[ -r "${line}" ]]; then
			# echo "$(tput setaf 1) :: No such file: ${line}$(tput setaf 7)"
			# echo "$(tput setaf 1) :: $(tput setaf 7)Attempting to fix error..."
			line=$(find "${work_dir}" -name "$(basename "${line}")")
			if [[ -f "${line}" ]]; then
				# echo "$(tput setaf 10)$(tput bold) ::$(tput setaf 7)$(tput sgr0) Successful attempt!"
				create "${line}"
			else
				clear
				err=1
				# echo "$(tput setaf 1) :: Retring filed$(tput setaf 7)"
			fi
		else
			create "${line}"
		fi

		let cur++
		# print_status_bar_testing ${err} $(( columns - (cur * bar_step) ))
	fi
done

rm ${list}
echo -e "\n Total files: ${sum}\tPassed: ${passed}"
