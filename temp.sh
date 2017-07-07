#!/bin/bash
echo "~~ nan0s7's fan-speed curve script [version 7] ~~"

# -- notes --
# + speed is a percentage value; or { 0..100 }
# + you can extend/shorten the curve array as you like
# + may want to set curve array in ascendingly (low to high)
# + it works via less-than logic; ie. by default 40<temp<=45 is speed=50

# Variables
LOOP=""
GPU="0"
OLD_SPEED="0"
SPEED="30"

# The actual fan curve array; ["TEMP"]="FAN_SPEED_PERCENTAGE"
declare -a CURVE=( ["40"]="40" ["45"]="50" ["50"]="60" ["55"]="70" ["60"]="85" ["70"]="100" )

# Enable fan control
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

while [ -z "$LOOP" ]; do
	# Current temperature query
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp -t`

	# Execution of fan curve
	for VAL in "${!CURVE[@]}"; do
		if [ "$TEMP" -le "$VAL" ]; then
			SPEED="${CURVE[$VAL]}"
			break
		fi
	done

	# Changes the fan speed
	if [ "$SPEED" -ne "$OLD_SPEED" ]; then
	    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
		OLD_SPEED="$SPEED"
	fi
	TEMP=""

	# If you're worried about power usage increase this
	sleep 3
done
