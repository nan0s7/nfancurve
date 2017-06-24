#!/bin/bash

LOOP=""
nvidia-settings -a "[gpu:0]/GPUFanControlState=1"
COMMAND="[fan:0]/GPUTargetFanSpeed="
NOW_SPEED=30

while [ -z $LOOP ]; do
	TEMP=`nvidia-settings -q=[gpu:0]/GPUCoreTemp`

	if [ ${TEMP:53:2} -le "40" ]; then
		SPEED=40
	elif [ ${TEMP:53:2} -le "45" ]; then
		SPEED=55
	elif [ ${TEMP:53:2} -le "50" ]; then
		SPEED=70
	elif [ ${TEMP:53:2} -le "55" ]; then
		SPEED=80
	elif [ ${TEMP:53:2} -le "60" ]; then
		SPEED=90
	else
		SPEED=100
	fi

	if [ $SPEED -ne $NOW_SPEED ]; then
	    nvidia-settings -a $COMMAND$SPEED
        NOW_SPEED=$SPEED
	fi

	sleep 2
done
