# nfancurve
A small and lightweight bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

**Prerequisites:**
- Bash version 4 and above, or a bash-like shell with the same commands
- Latest (or close to) Nvidia GLX Driver

You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible. I do take the assumption that your Linux installation has some version of Bash installed. I also assume that you have the Nvidia drivers installed on your machine.
This is also supposed to be quite lightweight. The last thing I want on my computer are more bulky applications that hog resources and end up being a jack of all trades, but a master of none.

The current version of the script is **version 7.**

This script works for tempurature values in the range 0:999, and is currently set up for Celsius. However, it can easily be modified for other scales.

If you need any help configuring my script or don't know how to make it start automatically check the **USAGE.md** file.

## Features
- by default it has an aggressive fan curve profile (lower temps, louder noise)
- only checks the GPU temp every 3 seconds (by default)
- automatically enables GPU fan control
- uses "nvidia-settings" commands
- easy to read code
- very lightweight; over 4.5h up-time: 0:03.88 CPU time & 672 KiB RAM used (tested with v4)
- now works for any PC hostname
- v6 now supports easy to change fan speeds and other cool stuff

## TODO
- ~~add more error checking when getting the current GPU temperature~~
- ~~weird unary error on some computers~~
- re-write if statements as for loops
- add in a more detailed guide of how the script works
- (this may need to be a separate script) make sure that "CoolBits" is enabled
- possibly check the currently installed driver version (earlier versions used a different GPUTargetFanSpeed command)
