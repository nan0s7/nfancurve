#!/bin/bash
echo "~~ nan0s7's fan-speed curve script updater script ~~"

declare -a exempt_vers=( 15 )

finish() {
	unset git_version
	unset local_version
	unset repo_version
	unset temp_pid
	unset temp_count
	unset no_overwrite
	unset exempt_vers
}
trap finish EXIT

check_for_git() {
	echo -e "\nChecking if git is installed..."
	git_version=`git --version`

	# Here I'm assuming that the version string format does not change much
	if [ "${#git_version}" -lt "22" ]; then
		echo "Git found!"
		echo $git_version
	else
		echo "Git not found... you should install that and try again"
		exit
	fi
}

get_nfancurve_version() {
    # Currently installed version
    local_version=`cat VERSION.txt`
    # Repository's version
    repo_version=`git ls-remote -t https://github.com/nan0s7/nfancurve.git`
    repo_version=${repo_version:(-3)}

    echo ""
    echo "Installed version of script: "$local_version
    echo "Latest version of script: "$repo_version
}

update_everything() {
    if [ "$local_version" -eq "$repo_version" ]; then
	    echo "You are using the most up-to-date version"
    elif [ "$local_version" -lt "$repo_version" ]; then
	    echo "You are using an outdated version"
	    echo "If you don't want to automatically download the latest version, press CTRL+C to quit this script"
	    sleep 4

	    # Downloads the whole repository to make sure nothing is old
	    `git clone https://github.com/nan0s7/nfancurve`
        if [ -f "config.txt" ]; then
            for i in `seq 0 $[ ${exempt_vers[@]} - 1 ]`; do
                if [ "$local_version" -eq "${exempt_vers[$i]}" ]; then
                    no_overwrite="1"
                fi
            done
            if [ "$no_overwrite" -eq "0" ]; then
                mv config.txt nfancurve/config.txt
            else
                mv config.txt nfancurve/config_old.txt
                echo "CONFIG FILE NOT OVERWRITTEN DUE TO STRUCTURE CHANGE"
            fi
        fi
	    cd nfancurve
	    echo "Replacing old files"
	    # Moves every file into main directory
	    mv -f -t ../ `ls`
	    cd ../
	    echo "Removing temporary directory"
	    # Deletes leftover folder
	    rm -rf nfancurve
	    echo "Done"
	    echo "Newly installed version: "`cat VERSION.txt`
    else
	    echo "You're using a developer version! =O"
    fi
}

kill_already_running() {
    # Gets the running PID for my script (if it's running)
    temp_count=`pgrep -c temp.sh`
    echo -e "\nThis code was taken from my other script, called; nron.sh"
    echo "Check out https://github.com/nan0s7/nrunornot for more info!"

    if [ "$temp_count" -gt "0" ]; then
	    echo -e "\nNumber of currently running temp.sh processes: ""$temp_count"
	    for i in `seq 1 $temp_count`; do
		    temp_pid=`pgrep -o temp.sh`
		    echo -e "Killing process... "$temp_pid"\n"
		    kill $temp_pid
	    done
    fi
}

main() {
    check_for_git
    get_nfancurve_version

    update_everything
    kill_already_running

    # Run the new version of the script
    nohup ./temp.sh >/dev/null 2>&1 &
    echo "A new background process was started."

    exit
}

main
