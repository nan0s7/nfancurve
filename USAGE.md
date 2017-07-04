# how do?

So you want to use my script, huh? Well lucky for you it's pretty easy. But before we start I have to ask you a few questions:

**Questions:**
1. Do you have an Nvidia graphics card installed in your computer?
2. Do you have Bash (version 3 and above) and the latest nvidia-glx driver installed on your system?
3. Do you want to use this script part-time? Or would you prefer it be always running in the background?
4. Did you want to change the default script values?

**Answers:**
1. Well you're probably looking in the wrong place. Sorry... D:
2. Most Linux distributions have them in the repositories. Go have a look. If you don't know where bash is, it is probably your default Terminal shell. Open your **f**avourite **T**erminal **a**pplication or **e**mulator (**ftae**) and type "bash --version" without the quotation marks.
3. See "automating this script" below if you want it always running in the background. If you want to use it whenever you want, you can just run the script by typing "./temp.sh" into your **ftae** when you're in the directory you've put my script. If you literally just downloaded it it'll be in your Downloads folder... duh!
4. I'd like to consider my script as being well-commented so if you're game then jump right in by opening my script in your favourite text editor. In particular you may want to have a look at the line that defines the "CURVE" variable (I'm assuming you're using at least version 6 of my script); where in the following example, a is the desired temperature you'd like the upper bound to be for changing the fan speed, and b is the fan-speed-percentage you want the fans to be running at: `["a"]="b"`. Also, I've written the script in such a way that you can have as many tempurature and fan-speed-percentage pairs as you like; just make sure they're all seperated by a space.

## automating this script
I've taken the (very small amount of) time to include a partially-completed .desktop file - you should locate that now. You need to change the "Path" and "Exec" lines (after the equal-sign). Also, place my script (temp.sh) somewhere safe but somewhere that you know where it is and makes sense. I usually put it somewhere in my home folder.

So if you put my script in your home folder, and lets say your user name/account name is "foo", your "Path" and "Exec" lines would go as follows (without the quotation marks):
- "Path=/home/foo/"
- "Exec=/home/foo/temp.sh"
If your user name/account name is not "foo" then you can change that to what it actually is.

Now the .desktop file should now read as follows:
```
[Desktop Entry]
Name=nan0s7's fan curve script
Type=Application
Path=/home/foo/
Exec=/home/foo/temp.sh
```

Now you've got to move the .desktop file (it may have re-named itself to "nan0s7's fan curve script") to a folder where it'll be automatically started. I'm currently running Solus OS which is based off of the Gnome Desktop currently, so I can place the .desktop in the /home/foo/.config/autostart/ folder (replacing foo with your user name of course... unless that is your user name). 

Then all I have to do is open up the good 'ol Gnome Tweak Tool, and make sure that my .desktop file shows up in the autostart section (again it may be called "nan0s7's fan curve script"). 

If you don't know how to set programs to autostart in your distribution of choice, just google how to and apply those instructions to my .desktop file. It usually isn't too difficult.
