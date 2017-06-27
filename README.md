# nfancurve
Small bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

This script works for tempurature values in the range 0 < temp < 999, and is currently set up for Celcius. However, it can easily be modified for other scales.

TODO:
- add more error checking when getting the current GPU temperature [fixed in ver. 3]
- [this may need to be a separate script] make sure that "CoolBits" is enabled
- possibly check the currently installed driver version (earlier versions used a different GPUTargetFanSpeed command)
