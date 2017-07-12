#!/bin/bash
echo "~~ nan0s7's fan-speed curve script [version 8] ~~"

# Variables
GPU="0"
OLD_SPEED="0"
SPEED="30"
TEMP="0"

# The actual fan curve array; ["TEMP_CELSIUS"]="FAN_SPEED_PERCENTAGE"
declare -a CURVE=( ["40"]="30" ["45"]="45" ["50"]="60" ["55"]="70" ["60"]="85" )

# Enable fan control
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

while true; do
	# Current temperature query
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp -t`

	# Execution of fan curve
	if [ "$TEMP" -gt "${CURVE[-1]}" ]; then
		SPEED="100"
	else
		for VAL in "${!CURVE[@]}"; do
			if [ "$TEMP" -le "$VAL" ]; then
				SPEED="${CURVE[$VAL]}"
				break
			fi
		done
	fi

	# Changes the fan speed
	if [ "$SPEED" -ne "$OLD_SPEED" ]; then
		nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
		OLD_SPEED="$SPEED"
	fi

	# If you're worried about power usage increase this
	sleep 3
done
