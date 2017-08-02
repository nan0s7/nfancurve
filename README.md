# nfancurve
A small and lightweight bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

**Prerequisites:**
- Bash version 4 and above, or a bash-like shell with the same commands
- Nvidia GLX Driver version greater than 304
- Update script requires git (it'll check for it when it's run)

You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible. To get this script up-and-running you _technically_ only need the **temp.sh** file.
The script itself is supposed to be quite lightweight. Although I'm more comfortable with something along the lines of Python, I felt that this was a perfect opportunity to improve on my Bash skills.

The current version of the script is **version 11.**

This script works for tempurature values in the range 0:999, and is currently set up for Celsius. However, it can easily be modified for other scales.

If you need any help configuring my script or don't know how to make it start automatically check the **USAGE.md** file.

## Features
- by default it has an aggressive fan curve profile (lower temps, louder noise)
- uses `nvidia-settings` commands
- automatically enables GPU fan control
- easy to read code, with plentiful comments (beginner friendly)
- intelligently adjusts the time between tempurature readings
- very lightweight; see stats section for more info
- works for any PC hostname
- easy-to-use update script


## Stats
- **v4** over 4.5h up-time: 0:03.88 CPU time
- **v7** around 5h: 0:03.22 CPU time
- **v10** around 5h: 0:02.42 CPU time

I ended up catching the command I use to get the current temperature in action and these are the stats: 0:00.06 CPU time. I will say this is again quite inaccurate at this scale, and on other times I've caught the process I've seen the statistics vary by a small bit. _Please note I've removed the recorded memory footprint because it is so small it's negligible._

These statistics should be taken with a grain of salt of course. My daily usage is usually with a bazillion tabs open in Firefox and many, many windows from various programs. I do game as well, but not usually intensive games (in Linux). These are taken from either the GNOME System Monitor or htop, and only take into account the script itself - measuring the Nvidia commands the script calls is mostly impractical and not needed. Also, I'm advertising this particular scripts' performance, not the performance of proprietary software. So whenever my script calls an Nvidia command, it is not measured in the statistics. My current CPU for measuring these stats is an i7 6700K @ 4.5GHz.


**TODO:**
- ~~add more error checking when getting the current GPU temperature~~
- ~~weird unary error on some computers~~
- ~~re-write if statements as for loops~~
- ~~make sure that "CoolBits" is enabled~~ - _not really the scope of this script_
- ~~possibly check the currently installed driver version~~ - _earlier versions used the  GPUCurrentFanSpeed command_
- ~~improve fan curve logic (ie 100%)~~
- make code more modular / more easily customisable
- add in a **really** detailed guide of how the script works
- add nouveau support (once they fix Pascal)
