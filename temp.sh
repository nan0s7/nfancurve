#!/bin/bash

prf() { printf %s\\n "$*" ; }

prf "
###################################
# nan0s7's fan speed curve script #
###################################
"

s="0"
tdiff="0"
display=""
num_gpus="0"
num_fans="0"
max_t="0"
tdiff_avg="0"
fcurve_len="0"
num_gpus_loop="0"
declare -a t=()
declare -a exp_sp=()
declare -a diff_c2=()
declare -a old_t=()
declare -a diff_c=()
gpu_cmd="nvidia-settings"
#gpu_cmd="/home/scott/Projects/nssim/nssim nvidia-settings"

usage="Usage: $(basename "$0") [OPTION]...

where:
-h  show this help text
-c  configuration file (default: $PWD/config)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection"

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
	DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	# if $SOURCE was a relative symlink, we need to resolve it relative to
	# the path where the symlink file was located
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
config_file="$DIR/config"

while getopts ":h :c: :d:" opt; do
	case $opt in
		c) config_file="$OPTARG";;
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
}
trap finish EXIT

# FUNCTIONS THAT REQUIRE CERTAIN DEPENDENCIES TO BE MET
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPENDS: PROCPS
check_already_running() {
	tmp="$(pgrep -c temp.sh)"
	if [ "$tmp" -eq "2" ]; then
		for i in $(seq 1 "$((tmp-1))"); do
			process_pid="$(pgrep -o temp.sh)"
			kill "$process_pid"
			prf "Killed $process_pid"
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

get_t() {
	t["$1"]="$($gpu_cmd -q=[gpu:"$1"]/GPUCoreTemp -t $display)"
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

set_spd() {
	$gpu_cmd -a [fan:"$1"]/GPUTargetFanSpeed="$2" $display
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

get_tdiff_avg() {
	tmp="$((tcurve[0]-min_t))"
	for i in $(seq 0 "$((fcurve_len-1))"); do
		tmp="$((tmp+$((tcurve[$((i+1))]-tcurve[$i]))))"
	done
	tdiff_avg="$((tmp/fcurve_len))"; prf "tdiff average: $tdiff_avg"
}

get_absolute_tdiff() {
	if [ "$1" -le "$2" ]; then
		tdiff="$(($2-$1))"
	else
		tdiff="$(($1-$2))"
	fi
}

# Finds the total number of fans & gpus by cutting the output string
get_gpu_info() {
	num_fans=$(get_query "fans")
	num_fans="${num_fans%* Fan on*}"
	if [ "${#num_fans}" -gt "2" ]; then
		num_fans="${num_fans%* Fans on*}"
	fi
	prf "Number of Fans detected: $num_fans"
	num_gpus=$(get_query "gpus")
	num_gpus="${num_gpus%* GPU on*}"
	if [ "${#num_gpus}" -gt "2" ]; then
		num_gpus="${num_gpus%* GPUs on*}"
	fi
	num_gpus_loop="$((num_gpus-1))"
	prf "Number of GPUs detected: $num_gpus"
}

# Expand speed curve into an arr that reduces comp. time (hopefully)
set_exp_sp() {
	for i in $(seq 0 "$((max_t-min_t))"); do
		for j in $(seq 0 "$fcurve_len"); do
			if [ "$i" -le "$((tcurve[$j]-min_t))" ]; then
				exp_sp["$i"]="${fcurve[$j]}"; break
			fi
		done
	done
}

# exp curves are expanded versions which reduce computation overall
set_diffs() {
	if [ "$tdiff_avg_or_max" -eq "0" ]; then
		tmp="$tdiff_avg"
	elif [ "$tdiff_avg_or_max" -eq "1" ]; then
		for i in $(seq 0 "$((fcurve_len-1))"); do
			tmp="$((tcurve[$((i+1))]-tcurve[$i]))"
			if [ "$tmp" -gt "$tdiff_avg" ]; then
				tmp="$tdiff_avg"
			fi
			diff_c+=("$tmp")
		done
	else
		prf "Wrong tdiff_avg_or_max: $tdiff_avg_or_max"; exit 1
	fi

	# can put this into loop above maybe
	diff_c+=("$tmp")
	old="${diff_c[0]}"
	unset diff_c
	diff_c="$old"
	diff_c2="$((old/2))"
}

set_s() {
	if [ "$1" -lt "$s" ]; then
		s="$1"
	fi
}

echo_info() {
	prf "
	temp=${t[$1]} oldt=${old_t[$1]} td=$tdiff slp=$s gpu=$1
	esp=${exp_sp[@]} espln=${#exp_sp[@]}
	dc=${diff_c[@]} dc2=${diff_c2[@]} mint=$min_t
	espct=${exp_sp[$((current_t-min_t))]}"
}

loop_cmds() {
	get_t "$1"

	if [ "${t[$1]}" -ne "${old_t[$1]}" ]; then
		# This whole section can now be done better btw
		current_t="${t[$1]}"

		# Calculate tdiff and make sure it's positive
		get_absolute_tdiff "$current_t" "${old_t[$1]}"

		if [ "$tdiff" -le "$diff_c2" ]; then
			set_s "${s_times[0]}"
		elif [ "$tdiff" -lt "$diff_c" ]; then
			set_s "${s_times[1]}"
		else
			if [ "$current_t" -lt "$min_t" ]; then
				new_spd="0"
			elif [ "$current_t" -lt "$max_t" ]; then
				new_spd="${exp_sp[$((current_t-min_t))]}"
			else
				new_spd="100"
			fi
			if [ "$new_spd" -ne "${exp_sp[${old_t[$1]}]}" ]; then
				set_spd "$1" "$new_spd"
			fi
			old_t["$1"]="$current_t"
			set_s "${s_times[0]}"
		fi
	else
		set_s "${s_times[0]}"
	fi

	# Uncomment the following line if you want to log stuff
	echo_info "$1"
}

main() {
	check_already_running
	check_driver

	if ! [ -f "$config_file" ]; then
        	prf "Config file not found." >&2; exit 1
	fi
	if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
		prf "Your two fan curves don't match up!"; exit 1
	fi

	source "$config_file"; prf "Configuration loaded"
	max_t="${tcurve[-1]}"
	fcurve_len="$((${#fcurve[@]}-1))"
	get_gpu_info

	if ! [ "$num_fans" -eq "$num_gpus" ]; then
		prf "Submit an issue on my GitHub page... happy to fix this :D"
		get_query "fans"; get_query "gpus"; exit 1
	fi
	for i in $(seq 0 "$num_gpus_loop"); do
		t["$num_gpus_loop"]="0"
		old_t["$num_gpus_loop"]="0"
	done

	get_tdiff_avg
	set_diffs
	set_exp_sp
	set_fan_control "$num_gpus_loop" "1"

	if [ "$num_gpus" -eq "1" ]; then
		prf "Started process for 1 GPU and 1 Fan"
		while true; do
			s="${s_times[0]}"
			loop_cmds "0"
			sleep "$s"
		done
	else
		prf "Started process for n-GPUs and n-Fans"
		while true; do
			s="${s_times[0]}"
			for i in $(seq 0 "$num_gpus_loop"); do
				loop_cmds "$i"
			done
			sleep "$s"
		done
	fi
}

main
