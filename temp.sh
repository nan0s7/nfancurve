#!/bin/bash
echo "###################################"
echo "# nan0s7's fan speed curve script #"
echo "###################################"
echo

# Editable variables
declare -a fcurve=( "25" "40" "55" "70" "85" ) # Fan speeds
declare -a tcurve=( "35" "45" "50" "55" "60" ) # Temperatures
# ie - when temp<=35 degrees celsius the fan speed=25%

# Variable initialisation (so don't change these)
gpu=0
temp=0
old_temp=0
tdiff=0
slp=0
eles=0
old_speed=0
speed=${fcurve[0]}
clen=$[ ${#fcurve[@]} - 1 ]
declare -a diff_curve=()
declare -a diff_c2=()

# Make sure the variables are back to normal
function finish {
	unset gpu
	unset temp
	unset old_temp
	unset slp
	unset speed
	unset old_speed
	unset i
	unset tdiff
	unset clen
	unset diff_c2
	unset diff_curve
	unset tcurve
	unset fcurve
	unset eles
	unset ver
	unset diffr
	unset hashes
	echo -e "\nSuccessfully caught exit & cleared variables!"
	set_fan_control 0
	echo -e "\nFan control set back to auto mode."
}
trap finish EXIT

# Check driver version
function check_driver {
	ver=`nvidia-settings -v`
	# Just a guess... I don't really know the right version
	if [ "${ver:27:3}" -lt "304" ]; then
		echo "You're using an old and unsupported driver, please upgrade it."
		exit
	else
		echo "A likely supported driver version was detected."
	fi
	unset ver
}

# Check that the curves are the same length
function check_arrays {
	if ! [ ${#fcurve[@]} -eq ${#tcurve[@]} ]; then
		echo "Your two fan curves don't match up - you should fix that."
		exit
	else
		echo -e "The fan curves match up! \nGood job! :D"
	fi
}

# Cleaner than worrying about if x or y statements in main imo
function get_abs_tdiff {
	if [ "$1" -le "$2" ]; then
		tdiff=$[ $2 - $1 ]
	else
		tdiff=$[ $1 - $2 ]
	fi
}

# This looked ugly when it was a lone command in the while loop
function get_temp {
	temp=`nvidia-settings -q=[gpu:"$gpu"]/GPUCoreTemp -t`
}

# This function is the biggest calculation in this script (use it sparingly)
function get_speed {
        # Execution of fan curve
	if [ "$temp" -gt "$[ ${tcurve[-1]} + 10 ]" ]; then
                speed="100"
        else
                # Get a new speed from curve
                for i in `seq 0 $clen`; do
                        if [ "$temp" -le "${tcurve[$i]}" ]; then
                                speed="${fcurve[$i]}"
                                eles=$i
                                break
                        fi
                done
	fi
}

# Enable/disable fan control (if CoolBits is enabled) - see USAGE.md
function set_fan_control {
	nvidia-settings -a "[gpu:""$gpu""]/GPUFanControlState="$1
}

# diff curves are the difference in fan-curve temps for better slp changes
function set_diffs {
	for i in `seq 0 $[ $clen - 1 ]`; do
		diffr=$[ ${tcurve[$[ $i + 1 ]]} - ${tcurve[$i]} ]
		diff_curve+=("$diffr")
		diff_c2+=("$[ $diffr / 2 ]")
	done
	unset diffr
}

# Function to contain the nvidia-settings command for changing speed
function set_speed {
	if ! [ "$1" -eq "$2" ]; then
		nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$1"
	fi
}

function main {
	check_driver
	check_arrays
	set_fan_control 1
	set_diffs
	set_speed $speed $old_speed

	# Anything in this loop will be running in the persistant process
	while true; do
		# Current temperature query
		get_temp

		# Calculate tdiff and make sure it's positive
		get_abs_tdiff $temp $old_temp

		# Better adjustments based on tcurve values
		if [ "$tdiff" -ge "${diff_curve[$eles]}" ]; then
			old_speed=$speed
			get_speed
			set_speed $speed $old_speed
			old_temp=$temp
			slp=3
		elif [ "$tdiff" -ge "${diff_c2[$eles]}" ]; then
			slp=5
		else
			slp=7
		fi

		# Execute `./temp.sh 1>log.txt 2>&1` to log all output
		# Uncomment the following line if you want to log stuff
		echo "t="$temp" ot="$old_temp" sp="$speed" tdif="$tdiff" slp="$slp

		# This will automatically adjust
		sleep "$slp"
	done
}

main
