#!/bin/bash

echo "Checking for installed git version..."

verG=`git --version`

if ! [ -z "$verG" ]; then
	echo "Git found!"
	echo $verG
else
	echo "Git not found... you should install that and try again"
	sleep 3
	exit
fi

verL=`cat VERSION.txt`
verR=`git ls-remote -t https://github.com/nan0s7/nfancurve.git`
verR=${verR:(-3)}

echo "Installed version of script: "$verL
echo "Latest version of script: "$verR

if [ "$verL" == "$verR" ]; then
	echo "You are using the most up-to-date version"
	sleep 4
else
	echo "You are using an outdated version"
	echo "If you don't want to automatically download the latest version, press CTRL+C to quit this script"
	sleep 3
	`git clone https://github.com/nan0s7/nfancurve`
	cd nfancurve
	mv -f -t ../ LICENCE README.md temp.desktop temp.sh update.sh USAGE.md VERSION.txt
	cd ../
	rm -rf nfancurve
fi

exit
