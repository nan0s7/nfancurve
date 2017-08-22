#!/bin/bash
echo "~~ nan0s7's fan speed curve script ~~"

# Just in-case
function finish {
	# Make sure the variables are back to normal
	unset gpu
	unset temp
	unset old_temp
	unset slp
	unset speed
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
	echo "Successfully caught exit & cleared variables!"
}
trap finish EXIT

# Check driver version
ver=`nvidia-settings -v`
# Just a guess... I don't really know the right version
if [ "${ver:27:3}" -lt "304" ]; then
        echo "You're using an old and unsupported driver, please upgrade it."
        exit
fi
unset ver

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
speed=${fcurve[0]}
clen=$[ ${#fcurve[@]} - 1 ]
declare -a diff_curve=()
declare -a diff_c2=()

# Enable fan control (only works if Coolbits is enabled), see USAGE.md
nvidia-settings -a "[gpu:""$gpu""]/GPUFanControlState=1"

# diff curves are the difference in fan-curve temps for better slp changes
for i in `seq 0 $[ $clen - 1 ]`; do
	diffr=$[ ${tcurve[$[ $i + 1 ]]} - ${tcurve[$i]} ]
	diff_curve+=("$diffr")
	diff_c2+=("$[ $diffr / 2 ]")
done
unset diffr

# Check that the curves are the same length
if ! [ ${#fcurve[@]} -eq ${#tcurve[@]} ]; then
	echo "Your two fan curves don't match up - you should fix that."
	exit
else
	echo "The fan curves match up! Good job :D"
fi

# Cleaner than worrying about if x or y statements imo
function get_abs_tdiff {
	if [ "$tdiff" -lt 0 ]; then
		tdiff=$[ $tdiff - 2 * $tdiff ]
	fi
}

# This function is the biggest calculation in this script (use it sparingly)
function set_speed {
        # Execution of fan curve
        if [ "$temp" -gt "$[ ${tcurve[-1]} + 10 ]" ]; then
                speed="100"
        else
                # Get a new speed from curve
                for i in `seq 0 $clen`; do
                        if [ "$temp" -le "${tcurve[$i]}" ]; then
                                speed="${fcurve[$i]}"
				eles=$i
                                # Break to avoid redundant computation
                                break
                        fi
                done
        fi
        # Change the fan speed to the newly calculated one
        nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$speed"
}

# Anything in this loop will be running in the actual persistant process
while true; do
	# Current temperature query
	temp=`nvidia-settings -q=[gpu:"$gpu"]/GPUCoreTemp -t`

        # Calculate temperature difference & make sure it's positive
        tdiff=$[ $temp - $old_temp ]
	get_abs_tdiff

	# Better adjustments based on tcurve values
	if [ "$tdiff" -ge "${diff_curve[$eles]}" ]; then
		set_speed
		old_temp="$temp"
		slp=3
	elif [ "$tdiff" -ge "${diff_c2[$eles]}" ]; then
		slp=4
	else
		slp=6
	fi

	# Do `./temp.sh 1>log.txt 2>&1` to log all output
        # Uncomment the following line if you want to log stuff
	# echo "t="$TEMP" ot="$OLD_TEMP" sp="$SPEED" tdif="$TDIFF" slp="$SLP

	# This will automatically adjust
	sleep "$slp"
done
