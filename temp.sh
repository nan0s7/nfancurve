#!/bin/bash

prf() { printf %s\\n "$*" ; }

s="0"; max_t="0"; tdiff="0"; display=""; new_spd="0"; num_gpus="0"; CDPATH=""
num_fans="0"; current_t="0"; check_diff11=""; check_diff12=""; z=$0; fname=""
fcurve_len="0"; num_gpus_loop="0"; declare -a old_t=(); declare -a exp_sp=()
mnt=0; mxt=0; ot=0; declare -a es=(); fcurve_len2="0"; declare -a exp_sp2=()
max_t2="0"; check_diff21=""; check_diff22=""; num_fans_loop="0"
gpu_cmd="nvidia-settings"

usage="Usage: $(basename "$0") [OPTION]...

where:
-h  show this help text
-c  configuration file (default: $PWD/config)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection"

{ \unalias command; \unset -f command; } >/dev/null 2>&1
[ -n "$ZSH_VERSION" ] && options[POSIX_BUILTINS]=on
while :; do
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

while getopts ":h :c: :d:" opt; do
	case $opt in
		c) conf_file="$OPTARG";;
		d) display="-c $OPTARG";;
		h) prf "$usage" >&2; exit;;
		\?) prf "Invalid option: -$OPTARG" >&2;;
		:) prf "Option -$OPTARG requires an argument." >&2; exit;;
	esac
done

# Catches when something quits the script, and resets fan control
finish() {
	set_fan_control "$num_gpus_loop" "0"
	prf "Fan control set back to auto mode"
}; trap finish EXIT

prf "
################################################################################
#          nan0s7's script for automatically managing GPU fan speed            #
################################################################################
"

# FUNCTIONS THAT REQUIRE CERTAIN DEPENDENCIES TO BE MET
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPENDS: PROCPS
check_already_running() {
	tmp="$(pgrep -c temp.sh)"
	if [ "$tmp" -ge "2" ]; then
		for i in $(seq 1 "$((tmp-1))"); do
			process_pid="$(pgrep -o temp.sh)"
			kill "$process_pid"; prf "Killed $process_pid"
		done
	fi
}

# DEPENDS: NVIDIA-SETTINGS
check_driver() {
	tmp="$($gpu_cmd -v)"
	if [ "${tmp:27:3}" -lt "304" ]; then
		prf "Unsupported driver version detected ${tmp:27:3}"; exit 1
	fi
}

get_temp() {
	current_t="$($gpu_cmd -q=[gpu:"$gpu"]/GPUCoreTemp -t $display)"
}

get_query() {
	prf "$($gpu_cmd -q "$1" $display)"
}

# Enable/disable fan control (if CoolBits is enabled) - see USAGE.md
set_fan_control() {
	for i in $(seq 0 "$1"); do
		$gpu_cmd -a [gpu:"$i"]/GPUFanControlState="$2" $display
	done
}

set_speed() {
	$gpu_cmd -a [fan:"$fan"]/GPUTargetFanSpeed="$1" $display
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_absolute_tdiff() {
	if [ "$current_t" -le "$ot" ]; then
		tdiff="$((ot-current_t))"
	else
		tdiff="$((current_t-ot))"
	fi
}

set_sleep() {
	if [ "$1" -lt "$s" ]; then
		s="$1"
	fi
}

echo_info() {
	prf "	t=$current_t oldt=$ot tdiff=$tdiff slp=$s gpu=$gpu
	nspd?=${es[$((current_t-mnt))]} nspd=$new_spd cd=$chd
	cd2=$chd2 mint=$mnt oldspd=${es[$((ot-mnt))]} fan=$fan
	"
}

loop_cmds() {
	get_temp

	if [ "$current_t" -ne "$ot" ]; then
		# Calculate difference and make sure it's positive
		get_absolute_tdiff

		if [ "$tdiff" -le "$chd1" ]; then
			set_sleep "$long_s"
		elif [ "$tdiff" -lt "$chd2" ]; then
			set_sleep "$short_s"
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
			old_t["$gpu"]="$current_t"
			set_sleep "$long_s"
		fi
	else
		set_sleep "$long_s"
	fi

	# Uncomment the following line if you want to log stuff
	echo_info
}

check_already_running
check_driver

if ! [ -f "$conf_file" ]; then
	prf "Config file not found." >&2; exit 1
fi

if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
	prf "fcurve and tcurve don't match up!"; exit 1
fi
if ! [ "${#fcurve2[@]}" -eq "${#tcurve2[@]}" ]; then
	prf "fcurve2 and tcurve2 don't match up!"; exit 1
fi

source "$conf_file"; prf "Configuration file: $conf_file"
max_t="${tcurve[-1]}"; max_t2="${tcurve2[-1]}"
fcurve_len="$((${#fcurve[@]}-1))"; fcurve_len2="$((${#fcurve2[@]}-1))"

num_fans=$(get_query "fans"); num_fans="${num_fans%* Fan on*}"
if [ "${#num_fans}" -gt "2" ]; then
	num_fans="${num_fans%* Fans on*}"
fi
prf "Number of Fans detected:"$num_fans

num_gpus=$(get_query "gpus"); num_gpus="${num_gpus%* GPU on*}"
if [ "${#num_gpus}" -gt "2" ]; then
	num_gpus="${num_gpus%* GPUs on*}"
fi
num_gpus_loop="$((num_gpus-1))"; num_fans_loop="$((num_fans-1))"
prf "Number of GPUs detected:"$num_gpus

for i in $(seq 0 "$num_gpus_loop"); do
	old_t["$i"]="0"
done

for i in $(seq 0 "$((fcurve_len-1))"); do
	check_diff11="$((check_diff11+tcurve[$((i+1))]-tcurve[$i]))"
done
for i in $(seq 0 "$((fcurve_len2-1))"); do
	check_diff21="$((check_diff21+tcurve2[$((i+1))]-tcurve2[$i]))"
done
check_diff11="$((check_diff11/fcurve_len))"; prf "tdiff average: $check_diff11"
check_diff12="$((check_diff11-long_s+short_s-1))"
check_diff21="$((check_diff21/fcurve_len2))"; prf "tdiff average: $check_diff21"
check_diff22="$((check_diff21-long_s+short_s-1))"

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

prf "esp=${exp_sp[@]} espln=${#exp_sp[@]}"
prf "esp2=${exp_sp2[@]} espln2=${#exp_sp2[@]}"

if [ "$num_gpus" -eq "1" ]; then
	prf "Started process for 1 GPU and 1 Fan"
	fan="$default_fan"
	gpu="${fan2gpu[$fan]}"
	tmp="${which_curve[$fan]}"
	if [ "$tmp" -eq "1" ]; then
		i=0
		for element in ${exp_sp[@]}; do
			es["$i"]="$element"
			i=$((i+1))
		done
		chd1="$check_diff11"
		chd2="$check_diff12"
		mnt="$min_t"
		mxt="$max_t"
	else
		i=0
		for element in ${exp_sp2[@]}; do
			es["$i"]="$element"
			i=$((i+1))
		done
		chd1="$check_diff21"
		chd2="$check_diff22"
		mnt="$min_t2"
		mxt="$max_t2"
	fi
	while true; do
		s="$long_s"
		ot="${old_t[$gpu]}"
		loop_cmds
		sleep "$s"
	done
else
	prf "Started process for n-GPUs and n-Fans"
	while true; do
		s="$long_s"
		for fan in $(seq 0 "$num_fans_loop"); do
			gpu="${fan2gpu[$fan]}"
			tmp="${which_curve[$fan]}"
			if [ "$tmp" -eq "1" ]; then
				i=0
				for element in ${exp_sp[@]}; do
					es["$i"]="$element"
					i=$((i+1))
				done
				chd1="$check_diff11"
				chd2="$check_diff12"
				mnt="$min_t"
				mxt="$max_t"
			else
				i=0
				for element in ${exp_sp2[@]}; do
					es["$i"]="$element"
					i=$((i+1))
				done
				chd1="$check_diff21"
				chd2="$check_diff22"
				mnt="$min_t2"
				mxt="$max_t2"
			fi
			ot="${old_t[$gpu]}"
			loop_cmds
		done 
		sleep "$s"
	done
fi
