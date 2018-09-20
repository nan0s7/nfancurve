nfancurve
---------
You are probably wondering why I have chosen to write this script in Bash. The reason is very simple; I wanted a script with the minimum number of dependencies possible. To get this script up-and-running you _technically_ only need the `temp.sh` file, and the `config` file. If you don't have a certain dependency (i.e. git or procps) you can just remove the code that uses them.

The current version of the script is **version 16**.

This script is currently set up for Celsius. However, it can easily be modified for other temperature scales.

If you need any help configuring my script or don't know how to make it start automatically check the [USAGE.md](USAGE.md) file.

## Features
- by default it has a slightly aggressive fan curve profile (lower temps, louder noise)
- uses `nvidia-settings` commands
- automatically enables/disables GPU fan control (but **not** `CoolBits`)
- easy to read code, with plentiful comments (beginner friendly)
- "intelligently" adjusts the time between tempurature readings
- very lightweight
- easy-to-use update script that uses `git`
- supports multiple GPU control
- now uses a config file that doesn't get overwritten after updates

## Prerequisites
- **_bash_** version 4 and above, or a bash-like shell with the same syntax (others untested)
- **_NVIDIA GLX Driver_** version greater than 304
- **_nvidia-settings_** for controlling the GPU(s)
- **_coreutils_** for printf, etc.
- **_procps_** in version 14 and greater - you can comment out the function `check_already_running` if you don't have it
- **_git_** is needed for use of `update.sh` (it'll check for it when it's run)

## How to install
### GitHub
- Download the .zip file straight from the GitHubs
- Extract it somewhere, and open a terminal to that directory
- Make sure `CoolBits` is enabled (see [USAGE.md](USAGE.md))
- Run `./temp.sh` for a foreground process, or `./update.sh` for a background* one

### git
- Choose a folder you want to download/install the script in
- `git clone https://github.com/nan0s7/nfancurve`
- See instructions for **GitHub** for the rest

### Arch Linux
There are unofficial AUR packages maintained by [@Scrumplex](https://github.com/Scrumplex).
- Stable: [nfancurve](https://aur.archlinux.org/packages/nfancurve/)<sup>AUR</sup>
- Git Master: [nfancurve-git](https://aur.archlinux.org/packages/nfancurve-git/)<sup>AUR</sup>

*or just execute this command: `nohup ./temp.sh >/dev/null 2>&1 &`

## Honourable mentions
- [@aryonoco](https://github.com/aryonoco), for being my multi-GPU guinea pig
- [@civyshk](https://github.com/civyshk), for making a Python fork
- [@zJelly](https://github.com/zJelly), for working on an AMD-GPU supporting fork
- [@dpayne](https://github.com/dpayne), for adding useful script parameters
- [@Scrumplex](https://github.com/Scrumplex), for adding check to avoid errors when config is missing, and maintaining the AUR package

## TODO
- ~~make sure that "CoolBits" is enabled~~ - _not really the scope of this script_
- ~~possibly check the currently installed driver version~~ - _earlier versions used the  GPUCurrentFanSpeed command_
- add in a **really** detailed guide of how the script works
- add nouveau support (once they fix Pascal)
- add AMD support?
- add support for GPU's that have more than one controllable fan (i.e. >1 fan controller)
