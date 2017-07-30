#!/bin/bash
echo "~~ nan0s7's fan-speed curve script ~~"

# Check driver version
VER=`nvidia-settings -v`
if [ "${VER:27:3}" -le "304" ]; then
        echo "You're using an old and unsupported driver, please upgrade it."
        exit
fi
unset VER

# Variables
GPU="0"
SPEED="30"
TEMP="0"
OLD_TEMP="0"
SLP=3

# The actual fan curve array; [TEMP_CELSIUS]=FAN_SPEED_PERCENTAGE
declare -a CURVE=( ["40"]="30" ["45"]="45" ["50"]="60" ["55"]="70" ["60"]="85" )

# Enable fan control
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

while true; do
	# Current temperature query
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp -t`

        # Calculate temperature difference
        OLD_TEMP=$[ $TEMP - $OLD_TEMP ]

        # Adjust the time between the next reading
        if [ $OLD_TEMP -ge 5 ]; then
                SLP=2
        elif [ $OLD_TEMP -gt 2 ]; then
                SLP=3
        elif [ $OLD_TEMP -eq 0 ]; then
                SLP=4
        elif [ $OLD_TEMP -lt 0 ]; then
                SLP=5
        fi

        if ! [ $OLD_TEMP -gt -5 ]; then
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
                # Change the fan speed to the newly calculated one
                nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
        fi

        # Set this to the old temperature reading
        OLD_TEMP=$TEMP

	# This will automatically adjust
	sleep $SLP
done

# Make sure the variables are back to normal
unset CURVE
unset GPU
unset TEMP
unset OLD_TEMP
unset SLP
unset SPEED
unset VAL