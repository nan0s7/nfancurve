#!/bin/bash

prf() { printf %s\\n "$*" ; }

s="0"; max_t="0"; tdiff="0"; display=""; new_spd="0"; num_gpus="0"; CDPATH=""
num_fans="0"; current_t="0"; z=$0; fname=""; check_diff1=""; check_diff2=""
fcurve_len="0"; num_gpus_loop="0"; declare -a old_t=(); declare -a exp_sp=()
mnt=0; mxt=0; ot=0; declare -a es=(); fcurve_len2="0"; declare -a exp_sp2=()
max_t2="0"; num_fans_loop="0"; debug="0"; e="0"; gpu_cmd="nvidia-settings"

usage="Usage: $(basename "$0") [OPTION]...

where:
-c  configuration file (default: $PWD/config)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection
-D  run in daemon mode (background process)
-h  show this help text
-l  enable logging to stdout
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

while getopts ":h :c: :d: :D :l :v" opt; do
	case $opt in
		c) conf_file="$OPTARG";;
		d) display="-c $OPTARG";;
		h) e=1; prf "$usage" >&2;;
		D) e=1; nohup ./temp.sh >/dev/null 2>&1 &;;
		l) debug="1";;
		v) e=1; prf "Version 17";;
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
	current_t="$($gpu_cmd -q=[gpu:"$gpu"]/GPUCoreTemp -t $display)"
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
	$gpu_cmd -a [fan:"$fan"]/GPUTargetFanSpeed="$1" $display
}

finish() {
	set_fan_control "$num_gpus_loop" "0"
	prf "Fan control set back to auto mode"
}; trap finish EXIT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo_info() {
	if [ "$new_spd" -ne "${es[$((ot-mnt))]}" ]; then z="y"; else z="n"; fi
	prf "	t=$current_t oldt=$ot tdiff=$tdiff slp=$s gpu=$gpu
	nspd?=${es[$((current_t-mnt))]} nspd=$new_spd cd=$chd maxt=$mxt
	mint=$mnt oldspd=${es[$((ot-mnt))]} fan=$fan z=$z
	"
}

loop_cmds() {
	get_temp

	if [ "$current_t" -ne "$ot" ]; then
		# Calculate difference and make sure it's positive
		if [ "$current_t" -le "$ot" ]; then
			tdiff="$((ot-current_t))"
		else
			tdiff="$((current_t-ot))"
		fi

		if [ "$tdiff" -lt "$chd" ]; then
			s="$short_s"
		else
			if [ "$current_t" -lt "$mnt" ]; then
				new_spd="0"
			elif [ "$current_t" -lt "$mxt" ]; then
				new_spd="${es[$((current_t-mnt))]}"
			else
				new_spd="100"
			fi
			if [ "$new_spd" -ne "${es[$((ot-mnt))]}" ]; then
				set_speed "$new_spd"
			fi
			old_t["$fan"]="$current_t"
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

# Check for any user errors in config file
if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
	prf "fcurve and tcurve don't match up!"; exit 1
fi
if ! [ "${#fcurve2[@]}" -eq "${#tcurve2[@]}" ]; then
	prf "fcurve2 and tcurve2 don't match up!"; exit 1
fi
if [ "$min_t" -ge "${tcurve[1]}" ]; then
	prf "min_t is greater than the first value in the tcurve!"; exit 1
fi
if [ "$min_t2" -ge "${tcurve2[1]}" ]; then
	prf "min_t2 is greater than the first value in the tcurve2!"; exit 1
fi

# Calculate some more values
max_t="${tcurve[-1]}"; max_t2="${tcurve2[-1]}"
fcurve_len="$((${#fcurve[@]}-1))"; fcurve_len2="$((${#fcurve2[@]}-1))"

# Get the system's GPU configuration
num_fans=$(get_query "fans"); num_fans="${num_fans%* Fan on*}"
if [ -z "$num_fans" ]; then
	prf "No Fans detected"; exit 1
elif [ "${#num_fans}" -gt "2" ]; then
	num_fans="${num_fans%* Fans on*}"
else
	prf "Number of Fans detected:"$num_fans
fi
num_gpus=$(get_query "gpus"); num_gpus="${num_gpus%* GPU on*}"
if [ -z "$num_gpus" ]; then
	prf "No GPUs detected"; exit 1
elif [ "${#num_gpus}" -gt "2" ]; then
	num_gpus="${num_gpus%* GPUs on*}"
else
	num_gpus_loop="$((num_gpus-1))"; num_fans_loop="$((num_fans-1))"
	prf "Number of GPUs detected:"$num_gpus
fi

for i in $(seq 0 "$num_fans_loop"); do
	old_t["$i"]="0"
done
for i in $(seq 0 "$((fcurve_len-1))"); do
	check_diff1="$((check_diff1+tcurve[$((i+1))]-tcurve[i]))"
done
for i in $(seq 0 "$((fcurve_len2-1))"); do
	check_diff2="$((check_diff2+tcurve2[$((i+1))]-tcurve2[i]))"
done
check_diff1="$(((check_diff1/fcurve_len)-long_s+short_s-1))"
check_diff2="$(((check_diff2/fcurve_len2)-long_s+short_s-1))"

set_fan_control "$num_gpus_loop" "1"

# Expand speed curve into an arr that reduces comp. time (hopefully)
for i in $(seq 0 "$((max_t-min_t))"); do
	for j in $(seq 0 "$fcurve_len"); do
		if [ "$i" -le "$((tcurve[j]-min_t))" ]; then
			exp_sp["$i"]="${fcurve[$j]}"; break
		fi
	done
done
for i in $(seq 0 "$((max_t2-min_t2))"); do
	for j in $(seq 0 "$fcurve_len2"); do
		if [ "$i" -le "$((tcurve2[j]-min_t2))" ]; then
			exp_sp2["$i"]="${fcurve2[$j]}"; break
		fi
	done
done

# Print some stuff for debugging
if [ "$debug" -eq "1" ]; then
	prf "esp=${exp_sp[@]} espln=${#exp_sp[@]}"
	prf "esp2=${exp_sp2[@]} espln2=${#exp_sp2[@]}"
	prf "tdiff average: $check_diff1"
	prf "tdiff2 average: $check_diff2"
fi

set_stuff() {
	gpu="${fan2gpu[$1]}"
	tmp="${which_curve[$1]}"

	if [ "$tmp" -eq "1" ]; then
		chd="$check_diff1"
		mnt="$min_t"; mxt="$max_t"
	else
		chd="$check_diff2"
		mnt="$min_t2"; mxt="$max_t2"
	fi

	i=0
	for element in ${exp_sp[@]}; do
		es["$i"]="$element"
		i=$((i+1))
	done
}

if [ "$num_gpus" -eq "1" ]; then
	prf "Started process for 1 GPU and 1 Fan"
	fan="$default_fan"
	set_stuff "$fan"
	while true; do
		s="$long_s"
		ot="${old_t[$fan]}"
		loop_cmds
		sleep "$s"
	done
else
	prf "Started process for n-GPUs and n-Fans"
	while true; do
		s="$long_s"
		for fan in $(seq 0 "$num_fans_loop"); do
			set_stuff "$fan"
			ot="${old_t[$fan]}"
			loop_cmds
		done
		sleep "$s"
	done
fi
