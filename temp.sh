#!/bin/bash
echo "~~ nan0s7's fan control script [version 4.5] ~~"

# -- notes --
# speeds are in percentages

# Variables
LOOP=""
GPU="0"
NOW_SPEED="30"
SPEED="0"

# Enable fan control
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

while [ -z "$LOOP" ]; do
	# Current temperature query
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp`

	# Extracts temperature value from output of command
	if [ "${TEMP:54:1}" == "." ]; then
		TEMP="${TEMP:53:1}"
	elif [ "${TEMP:55:1}" == "." ]; then
		TEMP="${TEMP:53:2}"
	else
		TEMP="${TEMP:53:3}"
	fi

	# You can edit these values if you like
	if [ "$TEMP" -le "40" ]; then
		SPEED="40"
	elif [ "$TEMP" -le "45" ]; then
		SPEED="55"
	elif [ "$TEMP" -le "50" ]; then
		SPEED="70"
	elif [ "$TEMP" -le "55" ]; then
		SPEED="80"
	elif [ "$TEMP" -le "60" ]; then
		SPEED="90"
	elif [ "$TEMP" -gt "60" ]; then
		SPEED="100"
	else
		SPEED="40"
	fi

	# Changes the fan speed
	if [ "$SPEED" -ne "$NOW_SPEED" ]; then
	    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
        NOW_SPEED="$SPEED"
	fi

	# If you're worried about power usage increase this
	sleep 2
done
