#!/bin/bash

prf() { printf %s\\n "$*" ; }

prf "
###################################
# nan0s7's fan speed curve script #
###################################
"

usage="Usage: $(basename "$0") [OPTION]...

where:
-h  show this help text
-c  configuration file (default: $PWD/config)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection"

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"

display=""
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

gpu_cmd="nvidia-settings"
#gpu_cmd="/home/scott/Projects/nssim/nssim nvidia-settings"
slp="0"
tdiff="0"
num_gpus="0"
num_fans="0"
max_temp="0"
tdiff_avg="0"
fcurve_len="0"
num_gpus_loop="0"
declare -a temp=()
declare -a exp_sp=()
declare -a diff_c2=()
declare -a old_temp=()
declare -a diff_curve=()

# FUNCTIONS THAT REQUIRE CERTAIN DEPENDENCIES TO BE MET
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPENDS: PROCPS
check_already_running() {
	tmp="$(pgrep -c temp)"
	if [ "$tmp" -eq "2" ]; then
		for i in $(seq 1 "$(( tmp - 1 ))"); do
			process_pid="$(pgrep -o temp.sh)"
			prf "Killing process... $process_pid"
			kill "$process_pid"
		done
	else
		prf "No other versions of temp.sh running in background"
	fi
}

# DEPENDS: NVIDIA-SETTINGS
# Check driver version; I don't really know the right version number
check_driver() {
	# Make this more robust
	tmp="$(nvidia-settings -v)"
	if [ "${tmp:27:3}" -lt "304" ]; then
		prf "You're using an unsupported driver, please upgrade it"
		exit 1
	elif [ "${tmp:27:3}" -ge "304" ]; then
		prf "A likely supported driver version was detected"
	else
		prf "nvidia-settings doesn't seem to be running..."
		exit 1
	fi
}

get_temp() {
	temp["$1"]="$($gpu_cmd -q=[gpu:"$1"]/GPUCoreTemp -t $display)"
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
	$gpu_cmd -a [fan:"$1"]/GPUTargetFanSpeed="$2" $display
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

get_tdiff_avg() {
	tmp="$(( tcurve[0] - min_temp ))"
	for i in $(seq 0 "$(( fcurve_len - 1 ))"); do
		tmp="$(( tmp + $(( tcurve[$(( i + 1 ))] - tcurve[$i] )) ))"
	done
	tdiff_avg="$(( tmp / fcurve_len ))"
	prf "tdiff average: $tdiff_avg"
}

get_absolute_tdiff() {
	if [ "$1" -le "$2" ]; then
		tdiff="$(( $2 - $1 ))"
	else
		tdiff="$(( $1 - $2 ))"
	fi
}

# Finds the total number of fans & gpus by cutting the output string
get_gpu_info() {
	num_fans=$(get_query "fans")
	num_fans="${num_fans%* Fan on*}"
	if [ "${#num_fans}" -gt "2" ]; then
		num_fans="${num_fans%* Fans on*}"
	fi
	num_gpus=$(get_query "gpus")
	num_gpus="${num_gpus%* GPU on*}"
	if [ "${#num_gpus}" -gt "2" ]; then
		num_gpus="${num_gpus%* GPUs on*}"
	fi
	num_gpus_loop="$(( num_gpus - 1 ))"
	prf "Number of Fans detected: $num_fans"
	prf "Number of GPUs detected: $num_gpus"
}

set_all_arr_zero() {
	for i in $(seq 0 "$1"); do
		temp["$i"]="0"
		old_temp["$i"]="0"
	done
}

# Expand speed curve into an arr that reduces comp. time (hopefully)
set_exp_sp() {
	for i in $(seq 0 "$(( max_temp - min_temp ))"); do
		for j in $(seq 0 "$fcurve_len"); do
			if [ "$i" -le "$(( tcurve[$j] - min_temp ))" ]; then
				exp_sp["$i"]="${fcurve[$j]}"
				break
			fi
		done
	done
}

# exp curves are expanded versions which reduce computation overall
set_diffs() {
	for i in $(seq 0 "$(( fcurve_len - 1 ))"); do
		if [ "$tdiff_avg_or_max" -eq "0" ]; then
			tmp="$tdiff_avg"
		elif [ "$tdiff_avg_or_max" -eq "1" ]; then
			tmp="$(( tcurve[$(( i + 1 ))] - tcurve[$i] ))"
			if [ "$tmp" -gt "$tdiff_avg" ]; then
				tmp="$tdiff_avg"
			fi
		else
			prf "You've messed up the tdiff_avg_or_max value!"
			prf "It is: $tdiff_avg_or_max"
			exit 1
		fi
		diff_curve+=( "$tmp" )
		diff_c2+=( "$(( tmp / 2 ))" )
	done
	diff_curve+=( "$tmp" )
	diff_c2+=( "$(( tmp / 2 ))" )

	# can put this into loop above maybe
	old="${diff_curve[0]}"
	unset diff_curve
	unset diff_c2
	diff_curve="$old"
	diff_c2="$(( old / 2 ))"
}

set_sleep() {
	if [ "$1" -lt "$slp" ]; then
		slp="$1"
	fi
}

echo_info() {
	prf "
	t=${temp[$1]} ot=${old_temp[$1]} td=$tdiff slp=$slp gpu=$1
	esp=${exp_sp[@]} espln=${#exp_sp[@]}
	dc=${diff_curve[@]} dc2=${diff_c2[@]} mint=$min_temp
	espct=${exp_sp[$(( current_temp - min_temp ))]}"
}

# Main loop stuff
loop_commands() {
	get_temp "$1"

	if [ "${temp[$1]}" -ne "${old_temp[$1]}" ]; then
		# This whole section can now be done better btw
		current_temp="${temp[$1]}"

		# Calculate tdiff and make sure it's positive
		get_absolute_tdiff "$current_temp" "${old_temp[$1]}"

		if [ "$tdiff" -le "$diff_c2" ]; then
			set_sleep "${slp_times[0]}"
		elif [ "$tdiff" -lt "$diff_curve" ]; then
			set_sleep "${slp_times[1]}"
		else
			if [ "$current_temp" -lt "$min_temp" ]; then
				new_speed="0"
			elif [ "$current_temp" -lt "$max_temp" ]; then
				new_speed="${exp_sp[$(( current_temp - min_temp ))]}"
			else
				new_speed="100"
			fi
			if [ "$new_speed" -ne "${exp_sp[${old_temp[$1]}]}" ]; then
				set_speed "$1" "$new_speed"
			fi
			old_temp["$1"]="$current_temp"
			set_sleep "${slp_times[0]}"
		fi
	else
		set_sleep "${slp_times[0]}"
	fi

	# Uncomment the following line if you want to log stuff
	echo_info "$1"
}

# Split while-loops to avoid redundant computation
start_process() {
	if [ "$num_gpus" -eq "1" ]; then
		prf "Started process for 1 GPU and 1 Fan"
		while true; do
			slp="${slp_times[0]}"
			loop_commands "0"
			sleep "$slp"
		done
	else
		prf "Started process for n-GPUs and n-Fans"
		while true; do
			slp="${slp_times[0]}"
			for i in $(seq 0 "$num_gpus_loop"); do
				loop_commands "$i"
			done
			sleep "$slp"
		done
	fi
}

main() {
	check_already_running
	check_driver

	if ! [ -f "$config_file" ]; then
        	prf "Config file not found." >&2
	        exit 1
	fi
	
	source "$config_file"; prf "Configuration loaded"

	if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
		prf "Your two fan curves don't match up!"
		exit 1
	fi

	max_temp="${tcurve[-1]}"
	fcurve_len="$(( ${#fcurve[@]} - 1 ))"
	get_gpu_info
	get_tdiff_avg
	set_diffs
	set_exp_sp
	set_all_arr_zero "$num_gpus_loop"
	set_fan_control "$num_gpus_loop" "1"

	# Haven't added individual fan control yet
	if [ "$num_fans" -eq "$num_gpus" ]; then
		start_process
	else
		prf "Submit an issue on my GitHub page... happy to fix this :D"
		get_query "fans"
		get_query "gpus"
	fi
}

main
