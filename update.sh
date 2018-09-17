#!/bin/bash
echo "~~ nan0s7's fan-speed curve script updater script ~~"

prf() { printf %s\\n "$*" ; }
declare -a config_changed=( 15 16 )

finish() {
	unset git_version
	unset local_version
	unset repo_version
	unset temp_pid
	unset temp_count
	unset no_overwrite
	unset config_changed
}
trap finish EXIT

check_for_git() {
	prf "Checking if git is installed..."
	git_version=$(git --version)

	# Here I'm assuming that the version string format does not change much
	if [ "${#git_version}" -lt "22" ]; then
		prf "Git found!"
		prf "$git_version"
	else
		prf  "Git not found... you should install that and try again"
		exit
	fi
}

get_nfancurve_version() {
    # Currently installed version
    local_version=$(cat VERSION.txt)
    # Repository's version
    repo_version=$(git ls-remote -t https://github.com/nan0s7/nfancurve.git)
    repo_version=${repo_version:(-3)}

    prf "Installed version of script: $local_version"
    prf "Latest version of script: $repo_version"
}

update_everything() {
    if [ "$local_version" -eq "$repo_version" ]; then
	    prf "You are using the most up-to-date version"
    elif [ "$local_version" -lt "$repo_version" ]; then
	    prf "You are using an outdated version"
	    prf "If you don't want to automatically download the latest version, press CTRL+C to quit this script"
	    sleep 4

	    # Downloads the whole repository to make sure nothing is old
	    git clone https://github.com/nan0s7/nfancurve
        if [ -f "config.txt" ]; then
            for i in `seq 0 $(( ${#config_changed[@]} - 1 ))`; do
                if [ "$local_version" -le "${config_changed[$i]}" ]; then
                    no_overwrite="1"
                fi
            done
            if [ "$no_overwrite" -eq "0" ]; then
                mv config.txt nfancurve/config.txt
            else
                mv config.txt nfancurve/config_old.txt
                prf "CONFIG FILE NOT OVERWRITTEN DUE TO STRUCTURE CHANGE"
            fi
        fi
	    cd nfancurve
	    prf "Replacing old files"
	    # Moves every file into main directory
	    mv -f -t ../ "$(ls)"
	    cd ../
	    prf "Removing temporary directory"
	    # Deletes leftover folder
	    rm -rf nfancurve
	    prf "Done"
	    prf "Newly installed version: $(cat VERSION.txt)"
    else
	    prf "You're using a developer version! =O"
    fi
}

kill_already_running() {
    # Gets the running PID for my script (if it's running)
    temp_count=$(pgrep -c temp.sh)

    if [ "$temp_count" -gt "0" ]; then
	    prf "Number of currently running temp.sh processes: $temp_count"
	    for i in `seq 1 $temp_count`; do
		    temp_pid=$(pgrep -o temp.sh)
		    prf "Killing process... $temp_pid"
		    kill "$temp_pid"
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
    prf "A new background process was started."

    exit
}

main
