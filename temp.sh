#!/bin/bash
# ver. 4

# Variables
LOOP=""
GPU="0"
NOW_SPEED=30

# Enable fan control
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

while [ -z "$LOOP" ]; do
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp`

	if [ "${TEMP:54:1}" == "." ]; then
		TEMP="${TEMP:53:1}"
	elif [ "${TEMP:55:1}" == "." ]; then
		TEMP="${TEMP:53:2}"
	else
		TEMP="${TEMP:53:3}"
	fi

	if [ "$TEMP" -le "40" ]; then
		SPEED=40
	elif [ "$TEMP" -le "45" ]; then
		SPEED=55
	elif [ "$TEMP" -le "50" ]; then
		SPEED=70
	elif [ "$TEMP" -le "55" ]; then
		SPEED=80
	elif [ "$TEMP" -le "60" ]; then
		SPEED=90
	else
		SPEED=100
	fi

	if [ "$SPEED" -ne "$NOW_SPEED" ]; then
	    nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
        NOW_SPEED="$SPEED"
	fi

	sleep 2
done
