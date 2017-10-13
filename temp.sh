#!/bin/bash
echo "###################################"
echo "# nan0s7's fan speed curve script #"
echo "###################################"
echo

# Editable variables
min_temp="0"
max_temp="110"
# ie - if you want something that's not celsius, change the above two
declare -a slp_times=( "7" "5" "3" ) # Sleep time in descending order
# ie - (needs 3 values) when script's not doing anything
declare -a fcurve=( "25" "40" "55" "70" "85" ) # Fan speeds
declare -a tcurve=( "35" "45" "50" "55" "60" ) # Temperatures
# ie - when temp<=35 degrees celsius the fan speed=25%

# Variable initialisation (so don't change these)
slp="0"
num_gpus="0"
num_gpus_loop="0"
num_fans="0"
clen="$[ ${#fcurve[@]} - 1 ]"
declare -a temp=()
declare -a old_temp=()
declare -a tdiff=()
declare -a diff_curve=()
declare -a diff_c2=()
declare -a exp_sp=()
declare -a exp_diff=()

# Make sure the variables are back to normal
function finish {
	set_fan_control "$num_gpus_loop" "0"
	echo "Fan control set back to auto mode."
	unset temp
	unset old_temp
	unset slp
	unset slp_times
	unset i
	unset tdiff
	unset clen
	unset diff_c2
	unset diff_curve
	unset tcurve
	unset fcurve
    unset num_gpus
    unset num_fans
    unset num_gpus_loop
    unset tmp
    unset exp_sp
    unset exp_diff
    unset exp_diff2
    unset exp_sp_temp
    unset min_temp
    unset max_temp
    unset firstPID
    echo "Successfully caught exit & cleared variables!"
}
trap finish EXIT

# More than one process can be problematic
function check_already_running {
	tmp=`pgrep -c temp`
	if [ "$tmp" -eq "2" ]; then
		echo -e "This code was taken from my other script, called; nron.sh"
		echo -e "Check out https://github.com/nan0s7/nrunornot for more info!\n"
		for i in `seq 1 $[ $tmp - 1 ]`; do
			firstPID=`pgrep -o temp.sh`
			echo -e "Killing process... "$firstPID"\n"
			kill $firstPID
		done
	else
		echo -e "No other versions of temp.sh running in background\n"
	fi
	unset firstPID
	unset tmp
}

# Check driver version; I don't really know the right version number
function check_driver {
	tmp=`nvidia-settings -v`
	if [ "${tmp:27:3}" -lt "304" ]; then
		echo "You're using an old and unsupported driver, please upgrade it."
		exit
	else
		echo "A likely supported driver version was detected."
	fi
	unset tmp
}

# Check that the curves are the same length
function check_arrays {
	if ! [ "${#fcurve[@]}" -eq "${#tcurve[@]}" ]; then
		echo "Your two fan curves don't match up - you should fix that."
		exit
	else
		echo -e "The fan curves match up! \nGood job! :D"
	fi
}

# Cleaner than worrying about if x or y statements in main imo
function get_abs_tdiff {
	if [ "$1" -le "$2" ]; then
		tdiff["$3"]="$[ $2 - $1 ]"
	else
		tdiff["$3"]="$[ $1 - $2 ]"
	fi
}

# This looked ugly when it was a lone command in the while loop
function get_temp {
	temp["$1"]=`nvidia-settings -q=[gpu:"$1"]/GPUCoreTemp -t`
}

# Finds the total number of fans by cutting the output string
function get_num_fans {
    num_fans=`nvidia-settings -q fans`
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
function get_num_gpus {
    num_gpus=`nvidia-settings -q gpus`
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

# Make sure sleep time is as small as needed (reduce computation time)
function set_init_slp {
	if [ "$1" -eq "0" ]; then
		slp="0"
		function set_sleep {
			slp="$1"
		}
	else
		slp="${slp_times[0]}"
		function set_sleep {
			if [ "$1" -lt "$slp" ]; then
				slp="$1"
			fi
		}
	fi
}

# Enable/disable fan control (if CoolBits is enabled) - see USAGE.md
function set_fan_control {
	for i in `seq 0 $1`; do
		nvidia-settings -a "[gpu:""$i""]/GPUFanControlState=""$2"
	done
}

# Function to contain the nvidia-settings command for changing speed
function set_speed {
	nvidia-settings -a "[fan:""$1""]/GPUTargetFanSpeed=""$2"
}

# Set every existing array to be zero
function set_all_arr_zero {
	for i in `seq 0 $1`; do
		temp["$i"]="0"
		old_temp["$i"]="0"
		tdiff["$i"]="0"
	done
}

# Expand speed curve into an arr that reduces comp. time (hopefully)
function set_exp_arr {
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
function set_temporary_diffs {
	for i in `seq 0 $[ $clen - 1 ]`; do
		tmp="$[ ${tcurve[$[ $i + 1 ]]} - ${tcurve[$i]} ]"
		diff_curve+=( "$tmp" )
		diff_c2+=( "$[ $tmp / 2 ]" )
	done
	diff_curve+=( "$tmp" )
	diff_c2+=( "$[ $tmp / 2 ]" )
	unset tmp
}

# exp curves are expanded versions which reduce computation overall
function set_diffs {
	set_temporary_diffs

	for i in `seq $min_temp $max_temp`; do
		if [ "$i" -gt "${tcurve[-1]}" ]; then
        	exp_diff["$i"]="${diff_curve[-1]}"
        	exp_diff2["$i"]="${diff_c2[-1]}"
        else
			for j in `seq 0 $clen`; do
		        if [ "$i" -le "${tcurve[$j]}" ]; then
		            exp_diff["$i"]="${diff_curve[$j]}"
		            exp_diff2["$i"]="${diff_c2[$j]}"
		            break
		        fi
		    done
		fi
	done
}

# Prints important variables for debugging purposes
function echo_info {
	tmp="t=""${temp[$1]}"" ot=""${old_temp[$1]}"" tdif=""${tdiff[$1]}"
	tmp="$tmp"" slp=""${slp[@]}"" gpu=""$1"
	echo "$tmp"
	unset tmp
}

# After initial computations some variables are no longer needed
function unset_unused_vars {
	unset diff_curve
	unset diff_c2
	unset tcurve
	unset fcurve
	unset min_temp
	unset max_temp
}

function loop_commands {
	# Current temperature query
	get_temp "$1"

	# Calculate tdiff and make sure it's positive
	get_abs_tdiff "${temp[$1]}" "${old_temp[$1]}" "$1"

	if [ "${tdiff[$1]}" -ge "${exp_diff[${temp[$1]}]}" ]; then
		# Avoid dumb nvidia-settings calls
		exp_sp_temp="${exp_sp[${temp[$1]}]}"
        if [ "$exp_sp_temp" -ne "${exp_sp[${old_temp[$1]}]}" ]; then
		    set_speed "$1" "$exp_sp_temp"
		fi
		old_temp["$1"]="${temp[$1]}"
		set_sleep "${slp_times[2]}"
	elif [ "${tdiff[$1]}" -ge "${exp_diff2[${temp[$1]}]}" ]; then
		set_sleep "${slp_times[1]}"
	else
		set_sleep "${slp_times[0]}"
	fi

	# Uncomment the following line if you want to log stuff
	#echo_info "$1"
}

# Split while-loops to avoid redundant computation
function start_process {
	if [ "$num_gpus" -eq "1" ]; then
		echo "Started process for 1 GPU and 1 Fan"

		set_init_slp "0"

		while true; do
			loop_commands "0"
			sleep "$slp"
		done
	else
		echo "Started process for n-GPUs and n-Fans"

		set_init_slp "1"

		while true; do
			slp="${slp_times[0]}"
			for i in `seq 0 $num_gpus_loop`; do
				loop_commands "$i"
			done
			sleep "$slp"
		done
	fi
}

function main {
	check_already_running

	check_driver
	check_arrays
    get_num_fans
    get_num_gpus
    set_diffs
    set_exp_arr

	set_all_arr_zero "$num_gpus_loop"
	set_fan_control "$num_gpus_loop" "1"

	unset_unused_vars

	# Haven't added individual fan control yet
	if [ "$num_fans" -eq "$num_gpus" ]; then
		start_process
	else
		echo "Submit an issue on my GitHub page... happy to fix this :D"
		echo `nvidia-settings -q fans`
		echo `nvidia-settings -q gpus`
	fi
}

main
