#!/bin/bash
#########################################
#
#    *.desktop file game file creator
#
#########################################

patterns=(start.sh start run runit run.sh run-game rungame run-game.sh rungame.sh "$1" "${1}.sh" "${1}.x86_64" "$2" "${2}.sh" "${2}.x86_64" "$3" "${3}.sh" "${3}.x86_64")

findexec() {
	for file_pattern in ${patterns}
	do
		[[ $(file "$file_pattern") =~ exec ]] && exec="$file_pattern" && return
	done
	
	file=
	while [[ ! -f "$file" ]] && [[ ! "$file" == "s" ]]; do
		pwd
		ls
		read file
	done 
	exec="$file"

	return
}

dir=()
while IFS=$'\n' read -r -d $'\n'; do
	dir+=("$REPLY")
done <<< $(find "$(pwd)" -maxdepth 1 | sed 1d)
for (( i = 0; i < ${#dir[@]}; i++ ))
do

	cd "${dir[i]}"

	out="$HOME/Desktop/$(basename "$(pwd)").desktop"
	findexec "$(basename "$(pwd)")" "$(basename "$(pwd)"|sed 's/ //g')" "$(basename "$(pwd)"|sed 's/ /_/g')"

	printf "[Desktop Entry]
Type=Application
Name=$(basename "$(pwd)")
GenericName=Game
Encoding=UTF-8
Exec=./$exec
Path=$(realpath "`pwd`")
Categories=Game
Terminal=false" > "$out"

	cd - >/dev/null
done
