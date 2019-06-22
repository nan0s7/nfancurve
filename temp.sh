#!/bin/bash

prf() { printf %s\\n "$*" ; }

z=$0; display=""; CDPATH=""; fname=""; num_gpus="0"; num_fans="0"; debug="0"
max_t="0"; max_t2="0"; mnt=0; mxt=0; ot=0; tdiff="0"; cur_t="0"; e="0"
new_spd="0"; old_spd="0"; old_t="0"; check_diff1="0"; check_diff2="0"
fcurve_len="0"; fcurve_len2="0"; num_gpus_loop="0"; num_fans_loop="0"
ot_elem="-1"; sleep_override=""; gpu_cmd="nvidia-settings"

usage="Usage: $(basename "$0") [OPTION]...

where:
-c  configuration file (default: $PWD/config)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection
-D  run in daemon mode (background process)
-h  show this help text
-l  enable logging to stdout
-s  set the sleep time (in seconds)
-v  show the current version of this script"

{ \unalias command; \unset -f command; } >/dev/null 2>&1
[ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on
while true; do
	[ -L "$z" ] || [ -e "$z" ] || { prf "'$z' is invalid" >&2; exit 1; }
	command cd "$(command dirname -- "$z")"
	fname=$(command basename -- "$z"); [ "$fname" = '/' ] && fname=''
	if [ -L "$fname" ]; then
		z=$(command ls -l "$fname"); z=${z#* -> }; continue
	fi
	break
done; conf_file=$(command pwd -P)
if [ "$fname" = '.' ]; then
	conf_file=${conf_file%/}
elif [ "$fname" = '..' ]; then
	conf_file=$(command dirname -- "${conf_file}")
else
	conf_file=${conf_file%/}/$fname
fi
conf_file=$(dirname -- "$conf_file")"/config"

while getopts ":h :c: :d: :D :l :v :x :s:" opt; do
	case $opt in
		c) conf_file="$OPTARG";;
		d) display="-c $OPTARG";;
		h) e=1; prf "$usage" >&2;;
		D) e=1; nohup ./temp.sh >/dev/null 2>&1 &;;
		l) debug="1";;
		s) sleep_override="$OPTARG";;
		v) e=1; prf "Version 18";;
		x) gpu_cmd="../nssim/nssim nvidia-settings";;
		\?) e=1; prf "Invalid option: -$OPTARG" >&2;;
		:) e=1; prf "Option -$OPTARG requires an argument." >&2;;
	esac
done
if [ "$e" -eq "1" ]; then exit; fi

prf "
################################################################################
#          nan0s7's script for automatically managing GPU fan speed            #
################################################################################
"

# FUNCTIONS THAT REQUIRE CERTAIN DEPENDENCIES TO BE MET
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPENDS: PROCPS
kill_already_running() {
	tmp="$(pgrep -c temp.sh)"
	if [ "$tmp" -ge "2" ]; then
		for i in $(seq 1 "$((tmp-1))"); do
			process_pid="$(pgrep -o temp.sh)"
			kill "$process_pid"; prf "Killed $process_pid"
		done
	fi
}
# DEPENDS: NVIDIA-SETTINGS
get_temp() {
	cur_t="$($gpu_cmd -q=[gpu:"$gpu"]/GPUCoreTemp -t $display)"
}

get_query() {
	prf "$($gpu_cmd -q "$1" $display)"
}

set_fan_control() {
	for i in $(seq 0 "$1"); do
		$gpu_cmd -a [gpu:"$i"]/GPUFanControlState="$2" $display
	done
}

set_speed() {
	$gpu_cmd -a [fan:"$fan"]/GPUTargetFanSpeed="$spd" $display
}

finish() {
	set_fan_control "$num_gpus_loop" "0"
	prf "Fan control set back to auto mode"
}; trap finish EXIT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo_info() {
	e=" t=$cur_t oldt=$ot tdiff=$tdiff slp=$sleep_time gpu=$gpu"
	e="$e nspd=$new_spd ospd=$old_spd cd=$chd maxt=$mxt"
	e="$e otel=$ot_elem mint=$mnt fan=$fan"
	prf "$e"
}

arr_size() {
	arr_len=0
	for element in $arr; do
		arr_len=$((arr_len+1))
	done
}

re_elem() {
	i=0
	for elem in $arr; do
		if [ "$i" -eq "$n" ]; then
			break
		else
			i=$((i+1))
		fi
	done
}

compare_spd() {
	i=0
	for temp in $tc; do
		if [ "$cur_t" -le "$temp" ]; then
			break
		else
			i=$((i+1))
		fi
	done
	if [ "$i" -ne "$ot_elem" ]; then
		j=0
		for speed in $fc; do
			if [ "$j" -eq "$i" ]; then
				new_spd="$speed"
				break
			else
				j=$((j+1))
			fi
		done
		ot_elem="$i"
	fi
}

loop_cmds() {
	get_temp

	if [ "$cur_t" -ne "$ot" ]; then
		# Calculate difference and make sure it's positive
		if [ "$cur_t" -le "$ot" ]; then
			tdiff="$((ot-cur_t))"
		else
			tdiff="$((cur_t-ot))"
		fi

		if [ "$tdiff" -ge "$chd" ]; then
			if [ "$cur_t" -lt "$mnt" ]; then
				new_spd="0"; ot_elem="-1"
			elif [ "$cur_t" -lt "$mxt" ]; then
				compare_spd
			else
				new_spd="100"
			fi
			if [ "$new_spd" -ne "$old_spd" ]; then
				spd="$new_spd"; set_speed
				old_spd="$new_spd"
			fi
			i=0
			tmp="$old_t"; old_t=""
			for elem in $tmp; do
				if [ "$i" -ne "$fan" ]; then
					old_t="$old_t $elem"
				else
					old_t="$old_t $cur_t"
				fi
				i="$((i+1))"
			done
			tdiff="0"
		fi
	fi

	if [ "$debug" -eq "1" ]; then
		echo_info
	fi
}

kill_already_running

# Load the config file
if ! [ -f "$conf_file" ]; then
	prf "Config file not found." >&2; exit 1
fi
source "$conf_file"; prf "Configuration file: $conf_file"

if [ -n "$sleep_override" ]; then sleep_time="$sleep_override"; fi

# Check for any user errors in config file
arr="$fcurve"; arr_size; size1="$arr_len"
arr="$tcurve"; arr_size; size2="$arr_len"
if ! [ "$size1" -eq "$size2" ]; then
	prf "fcurve and tcurve don't match up!"; exit 1
fi
arr="$fcurve2"; arr_size; size1="$arr_len"
arr="$tcurve2"; arr_size; size2="$arr_len"
if ! [ "$size1" -eq "$size2" ]; then
	prf "fcurve2 and tcurve2 don't match up!"; exit 1
fi
arr="$tcurve"; n="0"; re_elem
if [ "$min_t" -ge "$elem" ]; then
	prf "min_t is greater than the first value in the tcurve!"; exit 1
fi
arr="$tcurve2"; n="0"; re_elem
if [ "$min_t2" -ge "$elem" ]; then
	prf "min_t2 is greater than the first value in the tcurve2!"; exit 1
fi

# Calculate some more values
arr="$tcurve"; arr_size; arr="$tcurve"; n="$arr_len"; re_elem; max_t="$elem"
arr="$tcurve2"; arr_size; arr="$tcurve2"; n="$arr_len"; re_elem; max_t2="$elem"
arr="$fcurve"; arr_size; fcurve_len="$((arr_len-1))"
arr="$fcurve2"; arr_size; fcurve_len2="$((arr_len-1))"

# Get the system's GPU configuration
num_fans=$(get_query "fans"); num_fans="${num_fans%* Fan on*}"
if [ -z "$num_fans" ]; then
	prf "No Fans detected"; exit 1
elif [ "${#num_fans}" -gt "2" ]; then #=======================================
	num_fans="${num_fans%* Fans on*}"
else
	prf "Number of Fans detected:"$num_fans
fi
num_gpus=$(get_query "gpus"); num_gpus="${num_gpus%* GPU on*}"
if [ -z "$num_gpus" ]; then
	prf "No GPUs detected"; exit 1
elif [ "${#num_gpus}" -gt "2" ]; then #=======================================
	num_gpus="${num_gpus%* GPUs on*}"
else
	num_gpus_loop="$((num_gpus-1))"; num_fans_loop="$((num_fans-1))"
	prf "Number of GPUs detected:"$num_gpus
fi

for i in $(seq 1 "$num_fans_loop"); do
	old_t="$old_t 0"
done

if [ "$force_check" -eq "0" ]; then
	for j in $(seq 0 "$((fcurve_len-1))"); do
		arr="$tcurve"; n="$((j+1))"; re_elem; tmp1="$elem"
		arr="$tcurve"; n="$j"; re_elem; tmp2="$elem"
		check_diff1="$((check_diff1+tmp1-tmp2))"
	done
	check_diff1="$(((check_diff1/(fcurve_len-1))-sleep_time))"
	for j in $(seq 0 "$((fcurve_len2-1))"); do
		arr="$tcurve2"; n="$((j+1))"; re_elem; tmp1="$elem"
		arr="$tcurve2"; n="$j"; re_elem; tmp2="$elem"
		check_diff2="$((check_diff2+tmp1-tmp2))"
	done
	check_diff2="$(((check_diff2/(fcurve_len2-1))-sleep_time))"
else
	check_diff1="$force_check"; check_diff2="$force_check"
fi

set_fan_control "$num_gpus_loop" "1"

set_stuff() {
	arr="$fan2gpu"; n="$fan"; re_elem; gpu="$elem"
	arr="$which_curve"; n="$fan"; re_elem; tmp="$elem"
	i=0

	if [ "$tmp" -eq "1" ]; then
		chd="$check_diff1"
		mnt="$min_t"; mxt="$max_t"
		tc="$tcurve"; fc="$fcurve"
	else
		chd="$check_diff2"
		mnt="$min_t2"; mxt="$max_t2"
		tc="$tcurve2"; fc="$fcurve2"
	fi
}

if [ "$num_gpus" -eq "1" ] && [ "$num_fans" -eq "1" ]; then
	prf "Started process for 1 GPU and 1 Fan"
	fan="$default_fan"
	set_stuff
	while true; do
		arr="$old_t"; n="$fan"; re_elem; ot="$elem"
		loop_cmds
		sleep "$sleep_time"
	done
else
	prf "Started process for n-GPUs and n-Fans"
	while true; do
		for fan in $(seq 0 "$num_fans_loop"); do
			set_stuff
			arr="$old_t"; n="$fan"; re_elem; ot="$elem"
			loop_cmds
		done
		sleep "$sleep_time"
	done
fi
