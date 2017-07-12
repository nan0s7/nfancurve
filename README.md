# nfancurve
A small and lightweight bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

**Prerequisites:**
- Bash version 4 and above, or a bash-like shell with the same commands
- Latest (or close to) Nvidia GLX Driver

You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible. I do take the assumption that your Linux installation has some version of Bash installed. I also assume that you have the Nvidia drivers installed on your machine.
This is also supposed to be quite lightweight. The last thing I want on my computer are more bulky applications that hog resources and end up being a jack of all trades, but a master of none.

The current version of the script is **version 8.**

This script works for tempurature values in the range 0:999, and is currently set up for Celsius. However, it can easily be modified for other scales.

If you need any help configuring my script or don't know how to make it start automatically check the **USAGE.md** file.

## Features
- by default it has an aggressive fan curve profile (lower temps, louder noise)
- only checks the GPU temp every 3 seconds (by default)
- automatically enables GPU fan control
- uses "nvidia-settings" commands
- easy to read code
- very lightweight; check stats section for more info
- now works for any PC hostname
- v6 now supports easy to change fan speeds and other cool stuff

## Stats
- **v4** over 4.5h up-time: 0:03.88 CPU time & 672KiB memory used
- **v7** around 5h: 0:03.22 CPU time, 118MiB virtual memory, 780KiB memory used

I ended up catching the command I use to get the current temperature in action and these are the stats: 0:00.06 CPU time, 271.8MiB virtual memory, 5.2MiB memory used. I will say this is again quite inaccurate at this scale, and on other times I've caught the process I've seen the statistics vary by a small bit.

These statistics should be taken with a grain of salt of course. My daily usage is usually with a bazillion tabs open in Firefox and many, many windows from various programs. I do game as well, but not usually intensive games (in Linux). These are taken from either the GNOME System Monitor or htop, and only take into account the script itself - measuring the Nvidia commands the script calls is mostly impractical and not needed. Also, I'm advertising this particular scripts' performance, not the performance of proprietary software. Additionally, my current CPU for measuring these stats is an i7 6700K @ 4.5GHz.


**TODO:**
- ~~add more error checking when getting the current GPU temperature~~
- ~~weird unary error on some computers~~
- re-write if statements as for loops
- add in a more detailed guide of how the script works
- (this may need to be a separate script) make sure that "CoolBits" is enabled
- possibly check the currently installed driver version (earlier versions used a different GPUTargetFanSpeed command)
