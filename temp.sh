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
GPU=0
SPEED="25"
TEMP=0
OLD_TEMP=0
TDIFF=0
ERR=3
ER2=$[ $ERR - 2 ]
SLP=3

# The actual fan curve array; [TEMP_CELSIUS]=FAN_SPEED_PERCENTAGE
declare -a CURVE=( ["35"]="25" ["45"]="40" ["50"]="55" ["55"]="70" ["60"]="85" )

# Enable fan control (only works if Coolbits is enabled)
nvidia-settings -a "[gpu:""$GPU""]/GPUFanControlState=1"

# This function is the biggest calculation in this script (use it sparingly)
function set_speed {
        # Execution of fan curve
        if [ "$TEMP" -gt 70 ]; then
                # Only go max speed if temp > (last val in curve + 10 degrees)
                SPEED="100"
        else
                # Get a new speed from curve
                for VAL in "${!CURVE[@]}"; do
                        if [ "$TEMP" -le "$VAL" ]; then
                                SPEED="${CURVE[$VAL]}"
                                break
                        fi
                done
        fi
        # Change the fan speed to the newly calculated one
        nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=""$SPEED"
}

# Anything in this loop will be running in the actual persistant process
while true; do
	# Current temperature query
	TEMP=`nvidia-settings -q=[gpu:"$GPU"]/GPUCoreTemp -t`

        # Calculate temperature difference
        TDIFF=$[ $TEMP - $OLD_TEMP ]

        # Adjust the time between the next reading
        if [ "$TDIFF" -le "$ER2" ] && [ "$TDIFF" -ge -"$ER2" ]; then
                SLP=6
        elif [ "$TDIFF" -le "$ERR" ] && [ "$TDIFF" -ge -"$ERR" ]; then
                SLP=4
        else
                SLP=3
                # Call set_speed when you want to calc a new speed
                set_speed
                # Only need to set old temp when you re-calc speed
                OLD_TEMP="$TEMP"
        fi

	# This will automatically adjust
	sleep "$SLP"
done

# Make sure the variables are back to normal
unset CURVE
unset GPU
unset TEMP
unset OLD_TEMP
unset SLP
unset SPEED
unset VAL
unset TDIFF
unset ERR
unset ER2
