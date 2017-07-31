#!/bin/bash
echo "~~ nan0s7's fan-speed curve script updater script ~~"

echo "Checking for installed git version..."
verG=`git --version`

# Here I'm assuming that the version string format does not change much
if [ "${#verG}" -lt "22" ]; then
	echo "Git found!"
	echo $verG
else
	echo "Git not found... you should install that and try again"
	exit
fi

# Currently installed version
verL=`cat VERSION.txt`
# Repository's version
verR=`git ls-remote -t https://github.com/nan0s7/nfancurve.git`
verR=${verR:(-3)}

echo "Installed version of script: "$verL
echo "Latest version of script: "$verR

if [ $verL -eq $verR ]; then
	echo "You are using the most up-to-date version"
elif [ $verL -lt $verR ]; then
	echo "You are using an outdated version"
	echo "If you don't want to automatically download the latest version, press CTRL+C to quit this script"
	sleep 4
	# Downloads the whole repository to make sure nothing is old
	`git clone https://github.com/nan0s7/nfancurve`
	cd nfancurve
	echo "Replacing old files"
	# Removes every file
	mv -f -t ../ LICENCE README.md temp.sh update.sh USAGE.md VERSION.txt
	cd ../
	echo "Removing temporary directory"
	# Deletes leftover folder
	rm -rf nfancurve
	echo "Done"
	echo "Newly installed version: "`cat VERSION.txt`
else
	echo "You're using a developer version! =O"
fi

# Get's the running PID for my script (if it's running)
tempPID=`pgrep temp.sh`

# If the outdated script is running, kill it
if ! [ -z "$tempPID" ]; then
	kill $tempPID
fi

# Run the new version of the script
nohup ./temp.sh >/dev/null 2>&1 &

exit
