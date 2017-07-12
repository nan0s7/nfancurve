#!/bin/bash

echo "Checking for installed git version..."

verG=`git --version`

if ! [ -z "$verG" ]; then
	echo "Git found!"
	echo $verG
else
	echo "Git not found... you should install that and try again"
fi

verL=`cat VERSION.txt`
verR=`git ls-remote -t https://github.com/nan0s7/nfancurve.git`
verR=${verR:(-3)}

echo "Installed version of script: "$verL
echo "Latest version of script: "$verR

if [ "$verL" == "$verR" ]; then
	echo "You are using the most up-to-date version"
else
	echo "You are using an outdated version"
	echo "If you don't want to automatically download the latest version, press CTRL+C to quit this script"
	sleep 3
	`git clone https://github.com/nan0s7/nfancurve`
fi
