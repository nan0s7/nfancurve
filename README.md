# nfancurve
A small and lightweight bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

**Prerequisites:**
- Bash version 4 and above, or a bash-like shell with the same commands
- Nvidia GLX Driver version greater than 304
- Update script requires git (it'll check for it when it's run)

You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible.
This is also supposed to be quite lightweight. The last thing I want on my computer are more bulky applications that hog resources and end up being a jack of all trades, but a master of none.

The current version of the script is **version 9.**

This script works for tempurature values in the range 0:999, and is currently set up for Celsius. However, it can easily be modified for other scales.

If you need any help configuring my script or don't know how to make it start automatically check the **USAGE.md** file.

## Features
- by default it has an aggressive fan curve profile (lower temps, louder noise)
- only checks the GPU temp every 3 seconds (by default)
- automatically enables GPU fan control
- uses "nvidia-settings" commands
- easy to read code, with plentiful comments (beginner friendly)
- very lightweight; see stats section for more info
- works for any PC hostname
- easy-to-use update script


## Stats
- **v4** over 4.5h up-time: 0:03.88 CPU time
- **v7** around 5h: 0:03.22 CPU time

I ended up catching the command I use to get the current temperature in action and these are the stats: 0:00.06 CPU time. I will say this is again quite inaccurate at this scale, and on other times I've caught the process I've seen the statistics vary by a small bit. _Please note I've removed the recorded memory footprint because it is so small it's negligible._

These statistics should be taken with a grain of salt of course. My daily usage is usually with a bazillion tabs open in Firefox and many, many windows from various programs. I do game as well, but not usually intensive games (in Linux). These are taken from either the GNOME System Monitor or htop, and only take into account the script itself - measuring the Nvidia commands the script calls is mostly impractical and not needed. Also, I'm advertising this particular scripts' performance, not the performance of proprietary software. My current CPU for measuring these stats is an i7 6700K @ 4.5GHz.


**TODO:**
- ~~add more error checking when getting the current GPU temperature~~
- ~~weird unary error on some computers~~
- ~~re-write if statements as for loops~~
- ~~make sure that "CoolBits" is enabled~~ - not really the scope of this script
- add in a **really** detailed guide of how the script works
- possibly check the currently installed driver version (earlier versions used the  GPUCurrentFanSpeed command)
- add nouveau support (once they fix Pascal)
