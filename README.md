# nfancurve
Small bash script for using a custom fan curve in Linux for those with an Nvidia GPU.

Within the if-statements, the "TEMP:53:2" is just cutting the whole output of the query that asks for the current GPU core temperature; 53 is the position and it's assuming the temperature is 9 < temp < 100.

TODO:
- add more error checking when getting the current GPU temperature
- [this may need to be a separate script] make sure that "CoolBits" is enabled
- possibly check the currently installed driver version (earlier versions used a different GPUTargetFanSpeed command)
