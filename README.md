# nfancurve
A small and lightweight bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

**GOALS:**
You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible. I do take the assumption that your Linux installation has some version of Bash installed. I also assume that you have the Nvidia drivers installed on your machine.
This is also supposed to be quite lightweight. The last thing I want on my computer are more bulky applications that are a jack of all trades, but a master of none.

The current version of the script is **version 4.**

This script works for tempurature values in the range 0:999, and is currently set up for Celsius. However, it can easily be modified for other scales.

**TODO:**
- ~~add more error checking when getting the current GPU temperature~~
- re-write if statements as for loops
- (this may need to be a separate script) make sure that "CoolBits" is enabled
- possibly check the currently installed driver version (earlier versions used a different GPUTargetFanSpeed command)
