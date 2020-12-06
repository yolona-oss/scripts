#!/bin/bash
interval="0.5"
mem[0]=$(free --kibi|sed -n 2p|awk '{print $2}')
bar_size=10
mem_divider=$(( ${mem[0]} / $bar_size ))
cpu_divider=$(( 100 / $bar_size )) #$(bc <<< "scale=5; 100/$bar_size")

memory_usage_bar() {
    draw_bar() {
	multipler=$(( $1 / $mem_divider ))
	for (( i = 0; i < $multipler; i++ )); do
	    membar+=$2
	    let drawn_bar_size++
	done
    }

    drawn_bar_size=0
    mem[1]=$(free --kibi | sed -n 2p | awk '{print $3}')
    mem[2]=$(free --kibi | sed -n 2p | awk '{print $5}')
    mem[3]=$(free --kibi | sed -n 2p | awk '{print $6}')
    local offset=$(( ${#mem[@]} -1 ))
    mem[$(( $offset + 1 ))]="#"
    mem[$(( $offset + 2 ))]="%"
    mem[$(( $offset + 3 ))]="&"
    mem[$(( $offset + 4 ))]="!"

    for (( type = 1; type <= $offset; type++ )); do
	local cell=$(( $offset + $type ))
	draw_bar ${mem[${type}]} ${mem[$cell]}
    done
    for (( i = $drawn_bar_size; i < $bar_size; i++ )); do
    	membar+=":"
    done

    echo -e "$membar"
}

cpu_temp() {
    echo "$(( $(< /sys/class/hwmon/hwmon1/temp1_input) / 1000 ))°C"
}

cpu_load_bar() {
    local cpuload=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    local todraw_units=$(bc <<< "scale=0; $cpuload / $cpu_divider")

    for (( i = 0; i < $todraw_units; i++ ));do
	cpubar+='#'
    done

    for (( ; i < $bar_size; i++ )); do
	cpubar+=':'
    done

    echo $cpubar
}

sys_update_status() {
    local default=60
    if (( ${cicle:-$default} < $default )); then
	let cicle++
	echo $updates
	return 0
    fi
    cicle=0
    local chk=$(checkupdates | wc -l)
    local chk_aur=$(pacaur --aur-check | wc -l)
    updates="$chk arch | $chk_aur aur"
    echo $updates
}

term()
{
	done=1
}

done=""
trap term INT
trap term TERM

while [[ -z ${done} ]]; do
	xsetroot -name " $(memory_usage_bar) $(cpu_load_bar) | $(date +"%H:%M")" #$(sys_update_status) | 
	sleep ${interval}s
done

xsetroot -name "$(dwm -v)"
trap SIGINT
trap SIGTERM
