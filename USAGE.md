# how do?

So you want to use my script, huh? Well lucky for you it's pretty easy. But before we start I have to ask you a few questions:

**Questions:**
1. Do you have an Nvidia graphics card installed in your computer?
2. Do you have Bash (version 4 and above) and the **latest** nvidia-glx driver installed on your system?
3. Do you want to use this script part-time? Or would you prefer it be always running in the background?
4. Did you want to change the default script values?

**Answers:**
1. If not... well you're probably looking in the wrong place - sorry... D:
2. Most Linux distributions have them in the repositories. Go have a look. If you don't know where bash is, it is probably your default Terminal shell anyway. Open your **F**avourite **T**erminal **A**pplication or **E**mulator (**FTAE**) and type `bash --version`. _Please be aware that if you use the 304 or 340 glx driver versions, my script will more than likely not work! (will be fixed someday, I promise)_
3. See "automating this script" below if you want it always running in the background. If you want to use it whenever you want, you can just run the script by typing "./temp.sh" into your **FTAE** when you're in the directory you've put my script. If you literally just downloaded it it'll be in your Downloads folder... duh!
4. I'd like to consider my script as being well-commented so if you're game then jump right in by opening my script in your favourite text editor. For **versions 6 through 11**, you may want to have a look at the line that defines the `CURVE` variable; where in the following example, a is the desired temperature you'd like the upper bound to be for changing the fan speed, and b is the fan-speed-percentage you want the fans to be running at: `["a"]="b"`. Also, I've written the script in such a way that you can have as many temperature and fan-speed-percentage pairs as you like; just make sure they're all seperated by a space. For **versions 12 through 14** I've split the array into `fcurve` and `tcurve` (fan and temperature respectively) to make things slightly easier. Make sure that the two arrays are of the same length, though. Otherwise everything I said before still applies. For **version 15** I've made a seperate config file called _config.txt_ that contains all the editable variables. For **versions 16** I adjusted the structure and renamed config.txt to _config.sh_ to make it easier and neater. Any **versions greater than 16** have the _config.sh_ file renamed just to _config_.

## automating this script
You're going to have to make a .desktop file (copy the code below). Also, place my script (temp.sh) somewhere safe but somewhere that you know where it is and makes sense. I usually put it somewhere in my home folder.

So if you put my script in your home folder, and lets say your user name/account name is "foo", your following "Path" and "Exec" lines would go as follows:
- `Path=/home/foo/`
- `Exec=/home/foo/temp.sh`

If your user name/account name is not "foo" then you can change that to what it actually is.

Now the .desktop file should now read as follows:
```
[Desktop Entry]
Name=nan0s7's fan curve script
Type=Application
Path=/home/foo/
Exec=/home/foo/temp.sh
```

Now you've got to move the .desktop file (it may have re-named itself to "nan0s7's fan curve script") to a folder where it'll be automatically started. In some Ubuntu based distributions, you can place .desktop in the /home/foo/.config/autostart/ folder (replacing foo with your user name of course... unless that is your user name). 

Some distributions have a tool where you have to enable new applications to be autostarted, such as the Gnome Tweak Tool.

If you don't know how to set programs to autostart in your distribution of choice, just google how to and apply those instructions to my .desktop file. It usually isn't too difficult.

## making sure your bits are always cool
This is a fairly easy thing to do, and it should become second-nature to you if you plan on using Linux for the long-term. The easiest way to make sure at every boot, CoolBits is always enabled is to make use of the `xorg.conf.d` directory. **You will need root access, though.**

Go to the directory X11 via typing the following command: `cd /etc/X11/`
If you don't see a file called `xorg.conf` (use the `ls` command), you should open Nvidia Settings for the first time. This will generate one for you. 
Go into the `xorg.conf` file with your favourite text editor (mine is **nano**, so I'd type `nano xorg.conf`), and go down to the section that is labelled `"Device"`. Make sure you know what it says next to `Identifier`, in the quotation marks. I've copied what you'll need below; so when you paste it into the file we're going to create, remember to change your `Identifier` as needed.

You can now exit the editor and go back to the Terminal. Now, go into the directory `xorg.conf.d`. We're going to make a file, and you can technically call it whatever you like, but personally mine is called `nvidia.conf` (remember you need to be **root** in order to be able to save this file). Paste the following lines in this file:

```
Section "Device"
    Identifier     "Device0"
    Option         "Coolbits" "12"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
EndSection

# Trail
```

And don't forget to change your `Identifier`!

On an Ubuntu 20.04 fresh installation, the file is called `10-nvidia.conf` and located at `/usr/share/X11/xorg.conf.d` that can be updated as:

```
Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "Coolbits" "1"
    ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
EndSection
```
A reboot makes the changes permanent and nfancurve will take over your NVIDIA GPU's fan controls based on your assigned settings.

This file will make sure `Coolbits` is enabled each time your system generates a new `xorg.conf` file, which is usually whenever you update your graphics drivers (as Nvidia likes to do this).

You can change your `Coolbits` value (in my case the number `12`) to whatever you need it to be; different values enable different things. Any value above 4 will enable you to control your fan speed manually, and therefore use this script as it's intended. _Remember that Google is your friend._
