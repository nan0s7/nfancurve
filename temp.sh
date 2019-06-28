#!/bin/sh

prf() { printf %s\\n "$*" ; }

z=$0; display=""; CDPATH=""; fname=""; num_gpus="0"; num_fans="0"; debug="0"
max_t="0"; max_t2="0"; mnt="0"; mxt="0"; ot="0"; tdiff="0"; cur_t="0"
new_spd="0"; cur_spd="0"; old_t="200"; check_diff1="0"; check_diff2="0"
fcurve_len="0"; fcurve_len2="0"; num_gpus_loop="0"; num_fans_loop="0"
otl="-1"; sleep_override=""; gpu_cmd="nvidia-settings"

usage="Usage: $(basename "$0") [OPTION]...

where:
-c  [ARG] configuration file (default: $PWD/config)
-d  [ARG] display device string (e.g. \":0\", \"CRT-0\"), defaults to auto
-D  run in daemon mode (background process), using sh
-h  show this help text
-l  enable logging to stdout
-s  [ARG] set the sleep time (in seconds)
-v  show the current version of this script"

{ \unalias command; \unset -f command; } >/dev/null 2>&1
[ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on
while true; do
	[ -L "$z" ] || [ -e "$z" ] || { prf "'$z' is invalid" >&2; exit 1; }
	command cd "$(command dirname -- "$z")"
	fname=$(command basename -- "$z"); [ "$fname" = '/' ] && fname=''
	if [ -L "$fname" ]; then
		z=$(command ls -l "$fname"); z=${z#* -> }; continue
	fi; break
done; conf_file=$(command pwd -P)
if [ "$fname" = '.' ]; then
	conf_file=${conf_file%/}
elif [ "$fname" = '..' ]; then
	conf_file=$(command dirname -- "${conf_file}")
else
	conf_file=${conf_file%/}/$fname
fi
conf_file=$(dirname -- "$conf_file")"/config"

while getopts ":c: :d: :D :h :l :s: :v :x" opt; do
	if [ "$opt" = "c" ]; then conf_file="$OPTARG"
	elif [ "$opt" = "d" ]; then display="-c $OPTARG"
	elif [ "$opt" = "D" ]; then
		nohup sh temp.sh >/dev/null 2>&1 &
		exit 1
	elif [ "$opt" = "h" ]; then prf "$usage"; exit 0
	elif [ "$opt" = "l" ]; then debug="1"
	elif [ "$opt" = "s" ]; then sleep_override="$OPTARG"
	elif [ "$opt" = "v" ]; then prf "Version 18"; exit 0
	elif [ "$opt" = "x" ]; then
		gpu_cmd="../nssim/nssim nvidia-settings"
	elif [ "$opt" = ":" ]; then
		prf "Option -$OPTARG requires an argument"
	else
		prf "Invalid option: -$OPTARG"; exit 1
	fi
done

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
	if [ "$tmp" -gt "1" ]; then
		process_pid="$(pgrep -o temp.sh)"
		kill "$process_pid"; prf "Killed $process_pid"
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
	i=0
	while [ "$i" -le "$1" ]; do
		$gpu_cmd -a [gpu:"$i"]/GPUFanControlState="$2" $display
		i=$((i+1))
	done
}

set_speed() {
	$gpu_cmd -a [fan:"$fan"]/GPUTargetFanSpeed="$cur_spd" $display
}

finish() {
	set_fan_control "$num_gpus_loop" "0"
	prf "Fan control set back to auto mode"; exit 0
}; trap " finish" INT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo_info() {
	e=" t=$cur_t ot=$ot td=$tdiff s=$sleep_time gpu=$gpu fan=$fan cd=$chd"
	e="$e nsp=$new_spd osp=$cur_spd maxt=$mxt mint=$mnt otl=$otl"
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
		if [ "$i" -ne "$n" ]; then
			i=$((i+1))
		else
			break
		fi
	done
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
				new_spd="0"; otl="-1"
			elif [ "$cur_t" -lt "$mxt" ]; then
				tl=0
				for arr_t in $tc; do
					if [ "$cur_t" -le "$arr_t" ]; then
						break
					else
						tl=$((tl+1))
					fi
				done
				if [ "$tl" -ne "$otl" ]; then
					arr="$fc"; n="$tl"; re_elem
					new_spd="$elem"; otl="$tl"
				fi
			else
				new_spd="100"
			fi
			if [ "$new_spd" -ne "$cur_spd" ]; then
				cur_spd="$new_spd"; set_speed
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
. "$conf_file"; prf "Configuration file: $conf_file"

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

i=0
while [ "$i" -le "$num_fans_loop" ]; do
	old_t="$old_t 0"
	i=$((i+1))
done

if [ "$force_check" -eq "0" ]; then
	j=0
	while [ "$j" -le "$((fcurve_len-1))" ]; do
		arr="$tcurve"; n="$((j+1))"; re_elem; tmp1="$elem"
		arr="$tcurve"; n="$j"; re_elem; tmp2="$elem"
		check_diff1="$((check_diff1+tmp1-tmp2))"
		j=$((j+1))
	done
	check_diff1="$(((check_diff1/(fcurve_len-1))-sleep_time))"
	j=0
	while [ "$j" -le "$((fcurve_len2-1))" ]; do
		arr="$tcurve2"; n="$((j+1))"; re_elem; tmp1="$elem"
		arr="$tcurve2"; n="$j"; re_elem; tmp2="$elem"
		check_diff2="$((check_diff2+tmp1-tmp2))"
		j=$((j+1))
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
		fan=0
		while [ "$fan" -le "$num_fans_loop" ]; do
			set_stuff
			arr="$old_t"; n="$fan"; re_elem; ot="$elem"
			loop_cmds
			fan=$((fan+1))
		done
		sleep "$sleep_time"
	done
fi
