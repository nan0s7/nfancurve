nfancurve
---------
You are probably wondering why I have chosen to write this script in ~~Bash~~ Shell Script. The reason is very simple; I wanted a script with the minimum number of dependencies possible. To get this script up-and-running you _technically_ only need the `temp.sh` file, and the `config` file.

The current version of the script is **version 19.6**.

This script is currently set up for Celsius. However, it can easily be modified for other temperature scales.

If you need any help configuring my script or don't know how to make it start automatically check the [USAGE.md](USAGE.md) file.

## Features
- comes with a more aggressive fan curve than the nvidia default (lower temps, louder noise)
- uses `nvidia-settings` commands
- automatically enables/disables GPU fan control (but **not** `CoolBits`)
- very lightweight
- multiple GPU control with individual fan controller support
- makes use of a config file with explanations for each setting
- POSIX compliant

## Prerequisites
- a POSIX compliant shell; tested with recent versions of `bash` and `dash`
- `nvidia glx driver` version greater than 304
- `nvidia-settings` for controlling the GPU(s)
- `coreutils`
- `procps` - you can comment out the function `check_already_running` if you don't have it

## How to install
### GitHub
- Download the .zip file straight from the GitHubs
- Extract it somewhere, and open a terminal to that directory
- Make sure `CoolBits` is enabled (see [USAGE.md](USAGE.md))
- Run `sh temp.sh` (or any compatable shell) or `./temp.sh` for a foreground process. Run with the option `-D` (case sensitive) for a background process (i.e. `./temp.sh -D`). Note that using `sh` or `./` will automatically use your default shell.

### git
- Choose a folder you want to download/install the script in
- `git clone https://github.com/nan0s7/nfancurve`
- Follow the last two steps under the **GitHub** guide area

### Arch Linux
There are unofficial AUR packages:
- Stable: [nfancurve](https://aur.archlinux.org/packages/nfancurve/)<sup>AUR</sup>, maintained by [@ReneHollander](https://github.com/ReneHollander)
- Git Master: [nfancurve-git](https://aur.archlinux.org/packages/nfancurve-git/)<sup>AUR</sup>, outdated and unmaintained

## Using the systemd service
Ensure the script and the config paths are correct.
Move or copy the nfancurve.service file to /etc/systemd/user/nfancurve.service then enable and start the service with:

    systemctl --user daemon-reload
    systemctl --user start nfancurve.service
    systemctl --user enable nfancurve.service

### Troubleshooting
On some Distro's which are further behind in updates, or if there's a slight misconfiguration with services, you may encounter issues with the service file.

To work around this, you may change the following lines in the `nfancurve.service` file:
1. Change `After=graphical-session.target` to `After=default.target`
2. Remove the line `Requires=graphical-session.target`
3. Change `WantedBy=graphical-session.target` to `WantedBy=default.target`
4. Under the `[Service]` heading, add the line `ExecStartPre=/bin/sleep 20`

Don't forget to reload and reenable the service:

    systemctl --user daemon-reload
    systemctl reenable --user nfancurve

## Honourable mentions
- [@aryonoco](https://github.com/aryonoco), for being my multi-GPU guinea pig
- [@civyshk](https://github.com/civyshk), for making a Python fork
- [@zJelly](https://github.com/zJelly), for working on an AMD-GPU supporting fork
- [@dpayne](https://github.com/dpayne), for adding useful script parameters
- [@Scrumplex](https://github.com/Scrumplex), for adding check to avoid errors when config is missing, and initialising the AUR packages
- [@stefmitropoulos](https://github.com/stefmitropoulos), for greatly improving the way config files are loaded
- [@mklement0](https://stackoverflow.com/users/45375/mklement0), (stackoverflow) for a [POSIX implimentation](https://stackoverflow.com/questions/29832037/how-to-get-script-directory-in-posix-sh) of resolving file symlinks
- [@xberg](https://github.com/xberg), for finding and fixing a bug with the multi-GPU side of the script
- [@edave](https://github.com/edave), for helping test the initial implimentation of multi-fan GPU support
- [@louissmit](https://github.com/louissmit), for helping test the final multi-fan GPU feature implimentation
- [@D3473R](https://github.com/D3473R), for adding an example systemd service file
- [@ReneHollander](https://github.com/ReneHollander), for maintaining and improving the stable AUR package
- [@kenbeese](https://github.com/kenbeese), for making me aware of a multi-GPU bug
- [@BryanHitchcock](https://github.com/BryanHitchcock), for fixing an issue with single GPU, multi-fan configurations
- [@mooninite](https://github.com/mooninite), for fixing a couple of bugs

## TODO
- ~~make sure that "CoolBits" is enabled~~ - _not really the scope of this script_
- ~~possibly check the currently installed driver version~~ - _earlier versions used the  GPUCurrentFanSpeed command_
- add in a **really** detailed guide of how the script works
- add nouveau support (once they fix Pascal)
- add AMD support?
- make fans controllable without needing to use the `nvidia-settings` app (for headless support)
