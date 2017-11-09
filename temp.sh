#!/bin/bash
echo "###################################"
echo "# nan0s7's fan speed curve script #"
echo "###################################"
echo

# ------> Editable variables <------
# Moved to config.txt, read this first for an explanation:
# ------> min_temp & max_temp
# ie - if you want something that's not celsius, change the above two
# ------> tdiff_avg_or_max
# ie - 0 to use the average of all temp diffs or 1 to limit the max size
# that a tdiff value can be (0 = easier to compute, 1 = more flexible)
# ------> slp_times
# ie - (needs 2 values) when script's not doing anything
# ------> fcurve & tcurve
# ie - when temp<=35 degrees celsius the fan speed=25%

usage="$(basename "$0") [-h] [-c -d] -- A small and lightweight Bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

where:
-h  show this help text
-c  configuration file (default config.txt)
-d  display device string (e.g. \":0\", \"CRT-0\"), defaults to auto detection"

DISPLAY_CMD=""
CONFIG_FILE="config.txt"

while getopts ":h :c: :d:" opt; do
  case $opt in
	c)
	  CONFIG_FILE="$OPTARG"
	  ;;
	d)
	  DISPLAY_CMD="-c $OPTARG"
	  ;;
	h)
	  echo "$usage" >&2
	  exit
	  ;;
	\?)
	  echo "Invalid option: -$OPTARG" >&2
	  ;;
	:)
	  echo "Option -$OPTARG requires an argument." >&2
	  exit
	  ;;
  esac
done

# Make sure the variables are back to normal
finish() {
	set_fan_control "$num_gpus_loop" "0"
	echo "Fan control set back to auto mode."
	
	unset i
	unset slp
	unset tmp
	unset temp
	unset line
	unset clen
	unset tdiff
	unset exp_sp
	unset tcurve
	unset fcurve
	unset diff_c2
	unset old_temp
	unset var_line
	unset num_gpus
	unset num_fans
	unset min_temp
	unset max_temp
	unset form_line
	unset slp_times
	unset tdiff_hys
	unset tdiff_avg
	unset tdiff_hys2
	unset diff_curve
	unset process_pid
	unset exp_sp_temp
	unset num_gpus_loop
	unset tdiff_avg_or_max

	echo "Successfully caught exit & cleared variables!"
}
trap finish EXIT

# Variable initialisation (so don't change these)
slp="0"
tdiff="0"
min_temp=""
max_temp=""
num_gpus="0"
num_fans="0"
tdiff_avg="0"
num_gpus_loop="0"
tdiff_avg_or_max=""

declare -a temp=()
declare -a exp_sp=()
declare -a fcurve=()
declare -a tcurve=()
declare -a diff_c2=()
declare -a old_temp=()
declare -a tdiff_hys=()
declare -a slp_times=()
declare -a tdiff_hys2=()
declare -a diff_curve=()

# Read my config file in a really uninteresting way
read_config() {
	while IFS='' read -r line || [[ -n "$line" ]]; do
		var_line="${line%*:*}"
		line="${line#*:*}"
		if [ "$var_line" == "min_temp" ]; then
			min_temp="$line"
		elif [ "$var_line" == "max_temp" ]; then
			max_temp="$line"
		elif [ "$var_line" == "tdiff_avg_or_max" ]; then
			tdiff_avg_or_max="$line"
		elif [ "$var_line" == "slp_times" ] ||
				[ "$var_line" == "fcurve" ] ||
				[ "$var_line" == "tcurve" ]; then
			form_line="$line"
			while true; do
				if [ "$var_line" == "slp_times" ]; then
					slp_times+=( ${form_line%%,*} )
				elif [ "$var_line" == "fcurve" ]; then
					fcurve+=( ${form_line%%,*} )
				elif [ "$var_line" == "tcurve" ]; then
					tcurve+=( ${form_line%%,*} )
				else
					echo "Reading array error thingo!"
				fi
				if [ "${form_line%%,*}" == "$form_line" ]; then
					break
				fi
				form_line="${form_line#*,*}"
			done
		else
			echo "Error reading config"
		fi
	done < "${CONFIG_FILE}"
}

# FUNCTIONS THAT DEPEND ON STUFF
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# More than one process can be problematic
check_already_running() {
	tmp=`pgrep -c temp`
	if [ "$tmp" -eq "2" ]; then
		echo -e "This code was taken from my other script, called; nron.sh"
		echo -e "Check out https://github.com/nan0s7/nrunornot for more info!\n"
		for i in `seq 1 $[ $tmp - 1 ]`; do
			process_pid=`pgrep -o temp.sh`
			echo -e "Killing process... "$process_pid"\n"
			kill $process_pid
		done
	else
		echo -e "No other versions of temp.sh running in background\n"
	fi
	unset process_pid
	unset tmp
}

# Check driver version; I don't really know the right version number
check_driver() {
	tmp=`nvidia-settings -v ${DISPLAY_CMD}`
	if [ "${tmp:27:3}" -lt "304" ]; then
		echo "You're using an old and unsupported driver, please upgrade it."
		exit
	else
		echo "A likely supported driver version was detected."
	fi
	unset tmp
}

# This looked ugly when it was a lone command in the while loop
get_temp() {
	temp["$1"]=`nvidia-settings -q=[gpu:"$1"]/GPUCoreTemp -t ${DISPLAY_CMD}`
}

# Made this seperate for more code flexibility
get_tdiff_avg() {
	tmp="0"
	for i in `seq 0 $[ $clen - 1 ]`; do
		tmp="$[ $tmp + $[ ${tcurve[$[ $i + 1 ]]} - ${tcurve[$i]} ] ]"
	done
	tdiff_avg="$[ $tmp / $clen ]"
	echo "tdiff average: ""$tdiff_avg"
	unset tmp
}

# Seperated for compatability and debugging flexibility
get_fans_cmd() {
	num_fans=`nvidia-settings -q fans ${DISPLAY_CMD}`
	if [ "$1" -eq "0" ]; then
		echo "$num_fans"
	fi
}

# Same reasoning for get_fans_cmd
get_gpus_cmd() {
	num_gpus=`nvidia-settings -q gpus ${DISPLAY_CMD}`
	if [ "$1" -eq "0" ]; then
		echo "$num_gpus"
	fi
}

# Finds the total number of fans by cutting the output string
get_num_fans() {
	get_fans_cmd "1"
	tmp="${num_fans%* Fan on*}"
	if [ "${#tmp}" -gt "2" ]; then
		num_fans="${num_fans%* Fans on*}"
	else
		num_fans="$tmp"
	fi
	unset tmp
	echo "Number of Fans detected: ""$num_fans"
}

# Finds the total number of gpus by cutting the output string
get_num_gpus() {
	get_gpus_cmd "1"
	tmp="${num_gpus%* GPU on*}"
	if [ "${#tmp}" -gt "2" ]; then
		num_gpus="${num_gpus%* GPUs on*}"
	else
		num_gpus="$tmp"
	fi
	unset tmp
	num_gpus_loop="$[ $num_gpus - 1 ]"
	echo "Number of GPUs detected: ""$num_gpus"
}

# Enable/disable fan control (if CoolBits is enabled) - see USAGE.md
set_fan_control() {
	for i in `seq 0 $1`; do
		nvidia-settings -a "[gpu:""$i""]/GPUFanControlState=""$2" ${DISPLAY_CMD}
	done
}

# to contain the nvidia-settings command for changing speed
set_speed() {
	nvidia-settings -a "[fan:""$1""]/GPUTargetFanSpeed=""$2" ${DISPLAY_CMD}
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Check that the curves are the same length
check_arrays() {
	if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
		echo "Your two fan curves don't match up - you should fix that."
		exit
	else
		echo -e "The fan curves match up! \nGood job! :D"
	fi
}

# Cleaner than worrying about if x or y statements in main imo
get_abs_tdiff() {
	if [ "$1" -le "$2" ]; then
		tdiff="$[ $2 - $1 ]"
	else
		tdiff="$[ $1 - $2 ]"
	fi
}

# Set every existing array to be zero
set_all_arr_zero() {
	for i in `seq 0 $1`; do
		temp["$i"]="0"
		old_temp["$i"]="0"
	done
}

# Expand speed curve into an arr that reduces comp. time (hopefully)
set_exp_arr() {
	exp_sp["$min_temp"]="0"
	for i in `seq $[ $min_temp + 1 ] $max_temp`; do
		if [ "$i" -gt "${tcurve[-1]}" ]; then
			exp_sp["$i"]="100"
		else
			for j in `seq 0 $clen`; do
				if [ "$i" -le "${tcurve[$j]}" ]; then
					exp_sp["$i"]="${fcurve[$j]}"
					break
				fi
			done
		fi
	done
}

# diff curves are the difference in fan-curve temps for better slp changes
set_temporary_diffs() {
	for i in `seq 0 $[ $clen - 1 ]`; do
		if [ "$tdiff_avg_or_max" -eq "0" ]; then
			tmp="$tdiff_avg"
		elif [ "$tdiff_avg_or_max" -eq "1" ]; then
			tmp="$[ ${tcurve[$[ $i + 1 ]]} - ${tcurve[$i]} ]"
			if [ "$tmp" -gt "$tdiff_avg" ]; then
				tmp="$tdiff_avg"
			fi
		else
			echo "You've messed up the tdiff_avg_or_max value!"
			echo "It is: ""$tdiff_avg_or_max"
		fi
		diff_curve+=( "$tmp" )
		diff_c2+=( "$[ $tmp / 2 ]" )
	done
	diff_curve+=( "$tmp" )
	diff_c2+=( "$[ $tmp / 2 ]" )
	unset tmp
}

# exp curves are expanded versions which reduce computation overall
set_diffs() {
	set_temporary_diffs

	for i in `seq $min_temp $max_temp`; do
		if [ "$i" -gt "${tcurve[-1]}" ]; then
			tdiff_hys["$i"]="${diff_curve[-1]}"
			tdiff_hys2["$i"]="${diff_c2[-1]}"
		else
			for j in `seq 0 $clen`; do
				if [ "$i" -le "${tcurve[$j]}" ]; then
					tdiff_hys["$i"]="${diff_curve[$j]}"
					tdiff_hys2["$i"]="${diff_c2[$j]}"
					break
				fi
			done
		fi
	done
}

set_sleep() {
	if [ "$1" -lt "$slp" ]; then
		slp="$1"
	fi
}

# Prints important variables for debugging purposes
echo_info() {
	tmp="t=""${temp[$1]}"" ot=""${old_temp[$1]}"" tdif=""$tdiff"
	tmp="$tmp"" slp=""$slp"" gpu=""$1"
	echo "$tmp"
	unset tmp
}

echo_tdiff_hys_selection() {
	if [ "$tdiff_avg_or_max" -eq "0" ]; then
		echo "Using average value for temperature difference"
	elif [ "$tdiff_avg_or_max" -eq "1" ]; then
		echo "Using maximum limit for the temperature difference"
	else
		echo "Wrong value for tdiff_avg_or_max!"
	fi
}

# After initial computations some variables are no longer needed
unset_unused_vars() {
	unset diff_curve
	unset diff_c2
	unset tcurve
	unset fcurve
	unset min_temp
	unset max_temp
	unset tdiff_avg_or_max
}

# Main loop stuff
loop_commands() {
	# Current temperature query
	get_temp "$1"

	if [ "${temp[$1]}" -ne "${old_temp[$1]}" ]; then
		# Calculate tdiff and make sure it's positive
		get_abs_tdiff "${temp[$1]}" "${old_temp[$1]}" "$1"

		if [ "$tdiff" -le "${tdiff_hys2[${temp[$1]}]}" ]; then
			set_sleep "${slp_times[0]}"
		elif [ "$tdiff" -lt "${tdiff_hys[${temp[$1]}]}" ]; then
			set_sleep "${slp_times[1]}"
		else
			# Avoid dumb nvidia-settings calls
			exp_sp_temp="${exp_sp[${temp[$1]}]}"
			if [ "$exp_sp_temp" -ne "${exp_sp[${old_temp[$1]}]}" ]; then
				set_speed "$1" "$exp_sp_temp"
			fi
			old_temp["$1"]="${temp[$1]}"
			set_sleep "${slp_times[0]}"
		fi
	else
		set_sleep "${slp_times[0]}"
	fi

	# Uncomment the following line if you want to log stuff
	#echo_info "$1"
}

# Split while-loops to avoid redundant computation
start_process() {
	if [ "$num_gpus" -eq "1" ]; then
		echo "Started process for 1 GPU and 1 Fan"
		exp_sp_temp="${exp_sp[${temp[0]}]}"
		set_speed "0" "$exp_sp_temp"

		while true; do
			slp="${slp_times[0]}"
			loop_commands "0"
			sleep "$slp"
		done
	else
		echo "Started process for n-GPUs and n-Fans"

		while true; do
			slp="${slp_times[0]}"
			for i in `seq 0 $num_gpus_loop`; do
				loop_commands "$i"
			done
			sleep "$slp"
		done
	fi
}

main() {
	check_already_running

	read_config
	clen="$[ ${#fcurve[@]} - 1 ]"

	check_driver
	check_arrays
	get_num_fans
	get_num_gpus
	get_tdiff_avg

	set_diffs
	set_exp_arr

	set_all_arr_zero "$num_gpus_loop"
	set_fan_control "$num_gpus_loop" "1"

	echo_tdiff_hys_selection
	unset_unused_vars

	# Haven't added individual fan control yet
	if [ "$num_fans" -eq "$num_gpus" ]; then
		start_process
	else
		echo "Submit an issue on my GitHub page... happy to fix this :D"
		get_fans_cmd "0"
		get_gpus_cmd "0"
	fi
}

main

