since i'm lazy to run that command

and also for easier ctrl+c ctrl+v, here is the output of `nvidia-settings -q all`

first thing i'll be looking for is fan settings, as well as other extra settings : 

ubuntu 16.04 kfa2 gtx 1060 6 GB :

```
Attributes queryable via amd2018-MS-7B86:0.0:

  Attribute 'OperatingSystem' (amd2018-MS-7B86:0.0): 0.
    The valid values for 'OperatingSystem' are in the range 0 - 2 (inclusive).
    'OperatingSystem' is a read-only attribute.
    'OperatingSystem' can use the following target types: X Screen, GPU.

  Attribute 'NvidiaDriverVersion' (amd2018-MS-7B86:0.0): 384.130 
    'NvidiaDriverVersion' is a string attribute.
    'NvidiaDriverVersion' is a read-only attribute.
    'NvidiaDriverVersion' can use the following target types: X Screen, GPU.

  Attribute 'NvControlVersion' (amd2018-MS-7B86:0.0): 1.29 
    'NvControlVersion' is a string attribute.
    'NvControlVersion' is a read-only attribute.
    'NvControlVersion' can use the following target types: X Screen.

  Attribute 'GLXServerVersion' (amd2018-MS-7B86:0.0): 1.4 
    'GLXServerVersion' is a string attribute.
    'GLXServerVersion' is a read-only attribute.
    'GLXServerVersion' can use the following target types: X Screen.

  Attribute 'GLXClientVersion' (amd2018-MS-7B86:0.0): 1.4 
    'GLXClientVersion' is a string attribute.
    'GLXClientVersion' is a read-only attribute.
    'GLXClientVersion' can use the following target types: X Screen.

  Attribute 'OpenGLVersion' (amd2018-MS-7B86:0.0): 4.5.0 NVIDIA 384.130 
    'OpenGLVersion' is a string attribute.
    'OpenGLVersion' is a read-only attribute.
    'OpenGLVersion' can use the following target types: X Screen.

  Attribute 'XRandRVersion' (amd2018-MS-7B86:0.0): 1.5 
    'XRandRVersion' is a string attribute.
    'XRandRVersion' is a read-only attribute.
    'XRandRVersion' can use the following target types: X Screen.

  Attribute 'XF86VidModeVersion' (amd2018-MS-7B86:0.0): 2.2 
    'XF86VidModeVersion' is a string attribute.
    'XF86VidModeVersion' is a read-only attribute.
    'XF86VidModeVersion' can use the following target types: X Screen.

  Attribute 'XvVersion' (amd2018-MS-7B86:0.0): 2.2 
    'XvVersion' is a string attribute.
    'XvVersion' is a read-only attribute.
    'XvVersion' can use the following target types: X Screen.

  Attribute 'TwinView' (amd2018-MS-7B86:0.0): 0.
    'TwinView' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'TwinView' is a read-only attribute.
    'TwinView' can use the following target types: X Screen.

  Attribute 'ConnectedDisplays' (amd2018-MS-7B86:0.0): 0x00000100.
    'ConnectedDisplays' is a bitmask attribute.
    'ConnectedDisplays' is a read-only attribute.
    'ConnectedDisplays' can use the following target types: X Screen, GPU.

  Attribute 'EnabledDisplays' (amd2018-MS-7B86:0.0): 0x00000100.
    'EnabledDisplays' is a bitmask attribute.
    'EnabledDisplays' is a read-only attribute.
    'EnabledDisplays' can use the following target types: X Screen, GPU.

  Attribute 'AssociatedDisplays' (amd2018-MS-7B86:0.0): 0x00000f00.
    'AssociatedDisplays' is a bitmask attribute.
    'AssociatedDisplays' can use the following target types: X Screen.

  Attribute 'InitialPixmapPlacement' (amd2018-MS-7B86:0.0): 2.
    The valid values for 'InitialPixmapPlacement' are in the range 0 - 4
    (inclusive).
    'InitialPixmapPlacement' can use the following target types: X Screen.

  Attribute 'MultiGpuDisplayOwner' (amd2018-MS-7B86:0.0): 0.
    'MultiGpuDisplayOwner' is an integer attribute.
    'MultiGpuDisplayOwner' is a read-only attribute.
    'MultiGpuDisplayOwner' can use the following target types: X Screen.

  Attribute 'GlyphCache' (amd2018-MS-7B86:0.0): 1.
    'GlyphCache' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'GlyphCache' can use the following target types: X Screen.

  Attribute 'Depth30Allowed' (amd2018-MS-7B86:0.0): 1.
    'Depth30Allowed' is a boolean attribute; valid values are: 1 (on/true) and
    0 (off/false).
    'Depth30Allowed' is a read-only attribute.
    'Depth30Allowed' can use the following target types: X Screen, GPU.

  Attribute 'NoScanout' (amd2018-MS-7B86:0.0): 0.
    'NoScanout' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'NoScanout' is a read-only attribute.
    'NoScanout' can use the following target types: X Screen, GPU.

  Attribute 'XServerUniqueId' (amd2018-MS-7B86:0.0): -790081161.
    'XServerUniqueId' is an integer attribute.
    'XServerUniqueId' is a read-only attribute.
    'XServerUniqueId' can use the following target types: X Screen.

  Attribute 'PixmapCache' (amd2018-MS-7B86:0.0): 1.
    'PixmapCache' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'PixmapCache' can use the following target types: X Screen.

  Attribute 'PixmapCacheRoundSizeKB' (amd2018-MS-7B86:0.0): 1024.
    The valid values for 'PixmapCacheRoundSizeKB' are in the range 4 - 1048576
    (inclusive).
    'PixmapCacheRoundSizeKB' can use the following target types: X Screen.

  Attribute 'AccelerateTrapezoids' (amd2018-MS-7B86:0.0): 1.
    'AccelerateTrapezoids' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'AccelerateTrapezoids' can use the following target types: X Screen.

  Attribute 'ScreenPosition' (amd2018-MS-7B86:0.0): x=0, y=0, width=1920,
  height=1080 
    'ScreenPosition' is a string attribute.
    'ScreenPosition' is a read-only attribute.
    'ScreenPosition' can use the following target types: X Screen.

  Attribute 'SyncToVBlank' (amd2018-MS-7B86:0.0): 1.
    'SyncToVBlank' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'SyncToVBlank' can use the following target types: X Screen.

  Attribute 'LogAniso' (amd2018-MS-7B86:0.0): 0.
    The valid values for 'LogAniso' are in the range 0 - 4 (inclusive).
    'LogAniso' can use the following target types: X Screen.

  Attribute 'FSAA' (amd2018-MS-7B86:0.0): 0.
    Valid values for 'FSAA' are: 0, 1, 5, 9, 10 and 11.
    'FSAA' can use the following target types: X Screen.

  Attribute 'TextureClamping' (amd2018-MS-7B86:0.0): 1.
    'TextureClamping' is an integer attribute.
    'TextureClamping' can use the following target types: X Screen.

  Attribute 'FXAA' (amd2018-MS-7B86:0.0): 0.
    'FXAA' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'FXAA' can use the following target types: X Screen.

  Attribute 'AllowFlipping' (amd2018-MS-7B86:0.0): 1.
    'AllowFlipping' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'AllowFlipping' can use the following target types: X Screen.

  Attribute 'FSAAAppControlled' (amd2018-MS-7B86:0.0): 1.
    'FSAAAppControlled' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FSAAAppControlled' can use the following target types: X Screen.

  Attribute 'LogAnisoAppControlled' (amd2018-MS-7B86:0.0): 1.
    'LogAnisoAppControlled' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'LogAnisoAppControlled' can use the following target types: X Screen.

  Attribute 'OpenGLImageSettings' (amd2018-MS-7B86:0.0): 1.
    The valid values for 'OpenGLImageSettings' are in the range 0 - 3
    (inclusive).
    'OpenGLImageSettings' can use the following target types: X Screen.

  Attribute 'FSAAAppEnhanced' (amd2018-MS-7B86:0.0): 0.
    'FSAAAppEnhanced' is a boolean attribute; valid values are: 1 (on/true) and
    0 (off/false).
    'FSAAAppEnhanced' can use the following target types: X Screen.

  Attribute 'SliMosaicModeAvailable' (amd2018-MS-7B86:0.0): 0.
    'SliMosaicModeAvailable' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SliMosaicModeAvailable' is a read-only attribute.
    'SliMosaicModeAvailable' can use the following target types: X Screen, GPU,
    VCS.

  Attribute 'BusType' (amd2018-MS-7B86:0.0): 2.
    The valid values for 'BusType' are in the range 0 - 3 (inclusive).
    'BusType' is a read-only attribute.
    'BusType' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'PCIEMaxLinkSpeed' (amd2018-MS-7B86:0.0): 8000.
    'PCIEMaxLinkSpeed' is an integer attribute.
    'PCIEMaxLinkSpeed' is a read-only attribute.
    'PCIEMaxLinkSpeed' can use the following target types: X Screen, GPU, SDI
    Input Device.

  Attribute 'PCIEMaxLinkWidth' (amd2018-MS-7B86:0.0): 16.
    The valid values for 'PCIEMaxLinkWidth' are in the range 1 - 16
    (inclusive).
    'PCIEMaxLinkWidth' is a read-only attribute.
    'PCIEMaxLinkWidth' can use the following target types: X Screen, GPU, SDI
    Input Device.

  Attribute 'PCIECurrentLinkSpeed' (amd2018-MS-7B86:0.0): 8000.
    'PCIECurrentLinkSpeed' is an integer attribute.
    'PCIECurrentLinkSpeed' is a read-only attribute.
    'PCIECurrentLinkSpeed' can use the following target types: X Screen, GPU,
    SDI Input Device.

  Attribute 'PCIECurrentLinkWidth' (amd2018-MS-7B86:0.0): 16.
    'PCIECurrentLinkWidth' is an integer attribute.
    'PCIECurrentLinkWidth' is a read-only attribute.
    'PCIECurrentLinkWidth' can use the following target types: X Screen, GPU,
    SDI Input Device.

  Attribute 'VideoRam' (amd2018-MS-7B86:0.0): 6291456.
    'VideoRam' is an integer attribute.
    'VideoRam' is a read-only attribute.
    'VideoRam' can use the following target types: X Screen, GPU.

  Attribute 'Irq' (amd2018-MS-7B86:0.0): 48.
    'Irq' is an integer attribute.
    'Irq' is a read-only attribute.
    'Irq' can use the following target types: X Screen, GPU, SDI Input Device.

  Attribute 'CUDACores' (amd2018-MS-7B86:0.0): 1280.
    'CUDACores' is an integer attribute.
    'CUDACores' is a read-only attribute.
    'CUDACores' can use the following target types: X Screen, GPU.

  Attribute 'GPUMemoryInterface' (amd2018-MS-7B86:0.0): 192.
    'GPUMemoryInterface' is an integer attribute.
    'GPUMemoryInterface' is a read-only attribute.
    'GPUMemoryInterface' can use the following target types: X Screen, GPU.

  Attribute 'GPUCoreTemp' (amd2018-MS-7B86:0.0): 27.
    'GPUCoreTemp' is an integer attribute.
    'GPUCoreTemp' is a read-only attribute.
    'GPUCoreTemp' can use the following target types: X Screen, GPU.

  Attribute 'GPUCurrentClockFreqs' (amd2018-MS-7B86:0.0): 1518,3948.
    'GPUCurrentClockFreqs' is a packed integer attribute.
    'GPUCurrentClockFreqs' is a read-only attribute.
    'GPUCurrentClockFreqs' can use the following target types: X Screen, GPU.

  Attribute 'BusRate' (amd2018-MS-7B86:0.0): 16.
    The valid values for 'BusRate' are in the range 1 - 16 (inclusive).
    'BusRate' is a read-only attribute.
    'BusRate' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'PCIEGen' (amd2018-MS-7B86:0.0): 3.
    'PCIEGen' is an integer attribute.
    'PCIEGen' is a read-only attribute.
    'PCIEGen' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'GPUErrors' (amd2018-MS-7B86:0.0): 0.
    'GPUErrors' is an integer attribute.
    'GPUErrors' is a read-only attribute.
    'GPUErrors' can use the following target types: X Screen.

  Attribute 'GPUPowerSource' (amd2018-MS-7B86:0.0): 0.
    'GPUPowerSource' is an integer attribute.
    'GPUPowerSource' is a read-only attribute.
    'GPUPowerSource' can use the following target types: X Screen, GPU.

  Attribute 'GPUCurrentPerfLevel' (amd2018-MS-7B86:0.0): 3.
    'GPUCurrentPerfLevel' is an integer attribute.
    'GPUCurrentPerfLevel' is a read-only attribute.
    'GPUCurrentPerfLevel' can use the following target types: X Screen, GPU.

  Attribute 'GPUAdaptiveClockState' (amd2018-MS-7B86:0.0): 1.
    'GPUAdaptiveClockState' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'GPUAdaptiveClockState' is a read-only attribute.
    'GPUAdaptiveClockState' can use the following target types: X Screen, GPU.

  Attribute 'ECCConfigurationSupported' (amd2018-MS-7B86:0.0): 0.
    'ECCConfigurationSupported' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'ECCConfigurationSupported' is a read-only attribute.
    'ECCConfigurationSupported' can use the following target types: X Screen,
    GPU.

  Attribute 'GPUCurrentClockFreqsString' (amd2018-MS-7B86:0.0): nvclock=1518,
  nvclockmin=151, nvclockmax=1923, nvclockeditable=1, memclock=3948,
  memclockmin=3954, memclockmax=3954, memclockeditable=1, memTransferRate=7896,
  memTransferRatemin=7908, memTransferRatemax=7908, memTransferRateeditable=1 
    'GPUCurrentClockFreqsString' is a string attribute.
    'GPUCurrentClockFreqsString' can use the following target types: X Screen,
    GPU.

  Attribute 'GPUPerfModes' (amd2018-MS-7B86:0.0): perf=0, nvclock=139,
  nvclockmin=139, nvclockmax=607, nvclockeditable=1, memclock=405,
  memclockmin=405, memclockmax=405, memclockeditable=1, memTransferRate=810,
  memTransferRatemin=810, memTransferRatemax=810, memTransferRateeditable=1 ;
  perf=1, nvclock=139, nvclockmin=139, nvclockmax=1911, nvclockeditable=1,
  memclock=810, memclockmin=810, memclockmax=810, memclockeditable=1,
  memTransferRate=1620, memTransferRatemin=1620, memTransferRatemax=1620,
  memTransferRateeditable=1 ; perf=2, nvclock=151, nvclockmin=151,
  nvclockmax=1923, nvclockeditable=1, memclock=3752, memclockmin=3752,
  memclockmax=3752, memclockeditable=1, memTransferRate=7504,
  memTransferRatemin=7504, memTransferRatemax=7504, memTransferRateeditable=1 ;
  perf=3, nvclock=151, nvclockmin=151, nvclockmax=1923, nvclockeditable=1,
  memclock=3954, memclockmin=3954, memclockmax=3954, memclockeditable=1,
  memTransferRate=7908, memTransferRatemin=7908, memTransferRatemax=7908,
  memTransferRateeditable=1 
    'GPUPerfModes' is a string attribute.
    'GPUPerfModes' is a read-only attribute.
    'GPUPerfModes' can use the following target types: X Screen, GPU.

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0.0; display device: TV-0):
  0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'FrameLockFirmwareUnsupported' (amd2018-MS-7B86:0.0): 0.
    'FrameLockFirmwareUnsupported' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'FrameLockFirmwareUnsupported' is a read-only attribute.
    'FrameLockFirmwareUnsupported' can use the following target types: X
    Screen, GPU.

  Attribute 'GvoSupported' (amd2018-MS-7B86:0.0): 0.
    'GvoSupported' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'GvoSupported' is a read-only attribute.
    'GvoSupported' can use the following target types: X Screen.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0.0; display device: TV-0): 0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'DigitalVibrance' (amd2018-MS-7B86:0.0; display device: TV-0): 0.
    The valid values for 'DigitalVibrance' are in the range -1024 - 1023
    (inclusive).
    'DigitalVibrance' is display device specific.
    'DigitalVibrance' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'ImageSharpeningDefault' (amd2018-MS-7B86:0.0; display device:
  TV-0): 127.
    'ImageSharpeningDefault' is an integer attribute.
    'ImageSharpeningDefault' is a read-only attribute.
    'ImageSharpeningDefault' is display device specific.
    'ImageSharpeningDefault' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'RefreshRate' (amd2018-MS-7B86:0.0; display device: TV-0): 60,00
  Hz.
    'RefreshRate' is an integer attribute.
    'RefreshRate' is a read-only attribute.
    'RefreshRate' is display device specific.
    'RefreshRate' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'RefreshRate3' (amd2018-MS-7B86:0.0; display device: TV-0): 60,000
  Hz.
    'RefreshRate3' is an integer attribute.
    'RefreshRate3' is a read-only attribute.
    'RefreshRate3' is display device specific.
    'RefreshRate3' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0.0; display device: TV-0): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0.0; display device: TV-0): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0.0; display device: TV-0):
  0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0.0; display device: TV-0):
  0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentMetaModeID' (amd2018-MS-7B86:0.0): 50.
    'CurrentMetaModeID' is an integer attribute.
    'CurrentMetaModeID' can use the following target types: X Screen.

  Attribute 'CurrentMetaMode' (amd2018-MS-7B86:0.0): id=50, switchable=yes,
  source=xconfig :: DPY-0: nvidia-auto-select @1920x1080 +0+0
  {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0} 
    'CurrentMetaMode' is a string attribute.
    'CurrentMetaMode' can use the following target types: X Screen.

  Attribute 'XineramaInfoOrder' (amd2018-MS-7B86:0.0): DVI-D-0 
    'XineramaInfoOrder' is a string attribute.
    'XineramaInfoOrder' can use the following target types: X Screen.

  Attribute 'XVideoSyncToDisplay' (amd2018-MS-7B86:0.0): 0x00000100.
    'XVideoSyncToDisplay' is a bitmask attribute.
    'XVideoSyncToDisplay' can use the following target types: X Screen.

  Attribute 'XVideoSyncToDisplayID' (amd2018-MS-7B86:0.0): -1.
    'XVideoSyncToDisplayID' is an integer attribute.
    'XVideoSyncToDisplayID' can use the following target types: X Screen.

  Attribute 'CurrentXVideoSyncToDisplayID' (amd2018-MS-7B86:0.0): 0.
    'CurrentXVideoSyncToDisplayID' is an integer attribute.
    'CurrentXVideoSyncToDisplayID' is a read-only attribute.
    'CurrentXVideoSyncToDisplayID' can use the following target types: X
    Screen.

Attributes queryable via amd2018-MS-7B86:0[gpu:0]:

  Attribute 'OperatingSystem' (amd2018-MS-7B86:0[gpu:0]): 0.
    The valid values for 'OperatingSystem' are in the range 0 - 2 (inclusive).
    'OperatingSystem' is a read-only attribute.
    'OperatingSystem' can use the following target types: X Screen, GPU.

  Attribute 'NvidiaDriverVersion' (amd2018-MS-7B86:0[gpu:0]): 384.130 
    'NvidiaDriverVersion' is a string attribute.
    'NvidiaDriverVersion' is a read-only attribute.
    'NvidiaDriverVersion' can use the following target types: X Screen, GPU.

  Attribute 'ConnectedDisplays' (amd2018-MS-7B86:0[gpu:0]): 0x00000100.
    'ConnectedDisplays' is a bitmask attribute.
    'ConnectedDisplays' is a read-only attribute.
    'ConnectedDisplays' can use the following target types: X Screen, GPU.

  Attribute 'EnabledDisplays' (amd2018-MS-7B86:0[gpu:0]): 0x00000100.
    'EnabledDisplays' is a bitmask attribute.
    'EnabledDisplays' is a read-only attribute.
    'EnabledDisplays' can use the following target types: X Screen, GPU.

  Attribute 'Depth30Allowed' (amd2018-MS-7B86:0[gpu:0]): 1.
    'Depth30Allowed' is a boolean attribute; valid values are: 1 (on/true) and
    0 (off/false).
    'Depth30Allowed' is a read-only attribute.
    'Depth30Allowed' can use the following target types: X Screen, GPU.

  Attribute 'NoScanout' (amd2018-MS-7B86:0[gpu:0]): 0.
    'NoScanout' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'NoScanout' is a read-only attribute.
    'NoScanout' can use the following target types: X Screen, GPU.

  Attribute 'SliMosaicModeAvailable' (amd2018-MS-7B86:0[gpu:0]): 0.
    'SliMosaicModeAvailable' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SliMosaicModeAvailable' is a read-only attribute.
    'SliMosaicModeAvailable' can use the following target types: X Screen, GPU,
    VCS.

  Attribute 'BusType' (amd2018-MS-7B86:0[gpu:0]): 2.
    The valid values for 'BusType' are in the range 0 - 3 (inclusive).
    'BusType' is a read-only attribute.
    'BusType' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'PCIEMaxLinkSpeed' (amd2018-MS-7B86:0[gpu:0]): 8000.
    'PCIEMaxLinkSpeed' is an integer attribute.
    'PCIEMaxLinkSpeed' is a read-only attribute.
    'PCIEMaxLinkSpeed' can use the following target types: X Screen, GPU, SDI
    Input Device.

  Attribute 'PCIEMaxLinkWidth' (amd2018-MS-7B86:0[gpu:0]): 16.
    The valid values for 'PCIEMaxLinkWidth' are in the range 1 - 16
    (inclusive).
    'PCIEMaxLinkWidth' is a read-only attribute.
    'PCIEMaxLinkWidth' can use the following target types: X Screen, GPU, SDI
    Input Device.

  Attribute 'PCIECurrentLinkSpeed' (amd2018-MS-7B86:0[gpu:0]): 8000.
    'PCIECurrentLinkSpeed' is an integer attribute.
    'PCIECurrentLinkSpeed' is a read-only attribute.
    'PCIECurrentLinkSpeed' can use the following target types: X Screen, GPU,
    SDI Input Device.

  Attribute 'PCIECurrentLinkWidth' (amd2018-MS-7B86:0[gpu:0]): 16.
    'PCIECurrentLinkWidth' is an integer attribute.
    'PCIECurrentLinkWidth' is a read-only attribute.
    'PCIECurrentLinkWidth' can use the following target types: X Screen, GPU,
    SDI Input Device.

  Attribute 'VideoRam' (amd2018-MS-7B86:0[gpu:0]): 6291456.
    'VideoRam' is an integer attribute.
    'VideoRam' is a read-only attribute.
    'VideoRam' can use the following target types: X Screen, GPU.

  Attribute 'TotalDedicatedGPUMemory' (amd2018-MS-7B86:0[gpu:0]): 6064.
    'TotalDedicatedGPUMemory' is an integer attribute.
    'TotalDedicatedGPUMemory' is a read-only attribute.
    'TotalDedicatedGPUMemory' can use the following target types: GPU.

  Attribute 'UsedDedicatedGPUMemory' (amd2018-MS-7B86:0[gpu:0]): 1064.
    'UsedDedicatedGPUMemory' is an integer attribute.
    'UsedDedicatedGPUMemory' is a read-only attribute.
    'UsedDedicatedGPUMemory' can use the following target types: GPU.

  Attribute 'Irq' (amd2018-MS-7B86:0[gpu:0]): 48.
    'Irq' is an integer attribute.
    'Irq' is a read-only attribute.
    'Irq' can use the following target types: X Screen, GPU, SDI Input Device.

  Attribute 'CUDACores' (amd2018-MS-7B86:0[gpu:0]): 1280.
    'CUDACores' is an integer attribute.
    'CUDACores' is a read-only attribute.
    'CUDACores' can use the following target types: X Screen, GPU.

  Attribute 'GPUMemoryInterface' (amd2018-MS-7B86:0[gpu:0]): 192.
    'GPUMemoryInterface' is an integer attribute.
    'GPUMemoryInterface' is a read-only attribute.
    'GPUMemoryInterface' can use the following target types: X Screen, GPU.

  Attribute 'GPUCoreTemp' (amd2018-MS-7B86:0[gpu:0]): 27.
    'GPUCoreTemp' is an integer attribute.
    'GPUCoreTemp' is a read-only attribute.
    'GPUCoreTemp' can use the following target types: X Screen, GPU.

  Attribute 'GPUCurrentClockFreqs' (amd2018-MS-7B86:0[gpu:0]): 1518,3948.
    'GPUCurrentClockFreqs' is a packed integer attribute.
    'GPUCurrentClockFreqs' is a read-only attribute.
    'GPUCurrentClockFreqs' can use the following target types: X Screen, GPU.

  Attribute 'BusRate' (amd2018-MS-7B86:0[gpu:0]): 16.
    The valid values for 'BusRate' are in the range 1 - 16 (inclusive).
    'BusRate' is a read-only attribute.
    'BusRate' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'PCIDomain' (amd2018-MS-7B86:0[gpu:0]): 0.
    'PCIDomain' is an integer attribute.
    'PCIDomain' is a read-only attribute.
    'PCIDomain' can use the following target types: GPU, SDI Input Device.

  Attribute 'PCIBus' (amd2018-MS-7B86:0[gpu:0]): 28.
    'PCIBus' is an integer attribute.
    'PCIBus' is a read-only attribute.
    'PCIBus' can use the following target types: GPU, SDI Input Device.

  Attribute 'PCIDevice' (amd2018-MS-7B86:0[gpu:0]): 0.
    'PCIDevice' is an integer attribute.
    'PCIDevice' is a read-only attribute.
    'PCIDevice' can use the following target types: GPU, SDI Input Device.

  Attribute 'PCIFunc' (amd2018-MS-7B86:0[gpu:0]): 0.
    'PCIFunc' is an integer attribute.
    'PCIFunc' is a read-only attribute.
    'PCIFunc' can use the following target types: GPU, SDI Input Device.

  Attribute 'PCIID' (amd2018-MS-7B86:0[gpu:0]): 4318,7171.
    'PCIID' is a packed integer attribute.
    'PCIID' is a read-only attribute.
    'PCIID' can use the following target types: GPU, SDI Input Device.

  Attribute 'PCIEGen' (amd2018-MS-7B86:0[gpu:0]): 3.
    'PCIEGen' is an integer attribute.
    'PCIEGen' is a read-only attribute.
    'PCIEGen' can use the following target types: X Screen, GPU, SDI Input
    Device.

  Attribute 'GPUPowerSource' (amd2018-MS-7B86:0[gpu:0]): 0.
    'GPUPowerSource' is an integer attribute.
    'GPUPowerSource' is a read-only attribute.
    'GPUPowerSource' can use the following target types: X Screen, GPU.

  Attribute 'GPUCurrentPerfLevel' (amd2018-MS-7B86:0[gpu:0]): 3.
    'GPUCurrentPerfLevel' is an integer attribute.
    'GPUCurrentPerfLevel' is a read-only attribute.
    'GPUCurrentPerfLevel' can use the following target types: X Screen, GPU.

  Attribute 'GPUAdaptiveClockState' (amd2018-MS-7B86:0[gpu:0]): 1.
    'GPUAdaptiveClockState' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'GPUAdaptiveClockState' is a read-only attribute.
    'GPUAdaptiveClockState' can use the following target types: X Screen, GPU.

  Attribute 'GPUPowerMizerMode' (amd2018-MS-7B86:0[gpu:0]): 2.
    Valid values for 'GPUPowerMizerMode' are: 0, 1 and 2.
    'GPUPowerMizerMode' can use the following target types: GPU.

  Attribute 'GPUPowerMizerDefaultMode' (amd2018-MS-7B86:0[gpu:0]): 0.
    'GPUPowerMizerDefaultMode' is an integer attribute.
    'GPUPowerMizerDefaultMode' is a read-only attribute.
    'GPUPowerMizerDefaultMode' can use the following target types: GPU.

  Attribute 'ECCSupported' (amd2018-MS-7B86:0[gpu:0]): 0.
    'ECCSupported' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'ECCSupported' is a read-only attribute.
    'ECCSupported' can use the following target types: GPU.

  Attribute 'GPULogoBrightness' (amd2018-MS-7B86:0[gpu:0]): 100.
    The valid values for 'GPULogoBrightness' are in the range 0 - 100
    (inclusive).
    'GPULogoBrightness' can use the following target types: GPU.

  Attribute 'ECCConfigurationSupported' (amd2018-MS-7B86:0[gpu:0]): 0.
    'ECCConfigurationSupported' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'ECCConfigurationSupported' is a read-only attribute.
    'ECCConfigurationSupported' can use the following target types: X Screen,
    GPU.

  Attribute 'GPUFanControlState' (amd2018-MS-7B86:0[gpu:0]): 1.
    'GPUFanControlState' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'GPUFanControlState' can use the following target types: GPU.

  Attribute 'BaseMosaic' (amd2018-MS-7B86:0[gpu:0]): 0.
    Valid values for 'BaseMosaic' are: 0.
    'BaseMosaic' is a read-only attribute.
    'BaseMosaic' can use the following target types: GPU.

  Attribute 'MultiGpuMasterPossible' (amd2018-MS-7B86:0[gpu:0]): 0.
    'MultiGpuMasterPossible' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'MultiGpuMasterPossible' is a read-only attribute.
    'MultiGpuMasterPossible' can use the following target types: GPU.

  Attribute 'VideoEncoderUtilization' (amd2018-MS-7B86:0[gpu:0]): 0.
    'VideoEncoderUtilization' is an integer attribute.
    'VideoEncoderUtilization' is a read-only attribute.
    'VideoEncoderUtilization' can use the following target types: GPU.

  Attribute 'VideoDecoderUtilization' (amd2018-MS-7B86:0[gpu:0]): 0.
    'VideoDecoderUtilization' is an integer attribute.
    'VideoDecoderUtilization' is a read-only attribute.
    'VideoDecoderUtilization' can use the following target types: GPU.

  Attribute 'GPUCurrentClockFreqsString' (amd2018-MS-7B86:0[gpu:0]):
  nvclock=1518, nvclockmin=151, nvclockmax=1923, nvclockeditable=1,
  memclock=3948, memclockmin=3954, memclockmax=3954, memclockeditable=1,
  memTransferRate=7896, memTransferRatemin=7908, memTransferRatemax=7908,
  memTransferRateeditable=1 
    'GPUCurrentClockFreqsString' is a string attribute.
    'GPUCurrentClockFreqsString' can use the following target types: X Screen,
    GPU.

  Attribute 'GPUPerfModes' (amd2018-MS-7B86:0[gpu:0]): perf=0, nvclock=139,
  nvclockmin=139, nvclockmax=607, nvclockeditable=1, memclock=405,
  memclockmin=405, memclockmax=405, memclockeditable=1, memTransferRate=810,
  memTransferRatemin=810, memTransferRatemax=810, memTransferRateeditable=1 ;
  perf=1, nvclock=139, nvclockmin=139, nvclockmax=1911, nvclockeditable=1,
  memclock=810, memclockmin=810, memclockmax=810, memclockeditable=1,
  memTransferRate=1620, memTransferRatemin=1620, memTransferRatemax=1620,
  memTransferRateeditable=1 ; perf=2, nvclock=151, nvclockmin=151,
  nvclockmax=1923, nvclockeditable=1, memclock=3752, memclockmin=3752,
  memclockmax=3752, memclockeditable=1, memTransferRate=7504,
  memTransferRatemin=7504, memTransferRatemax=7504, memTransferRateeditable=1 ;
  perf=3, nvclock=151, nvclockmin=151, nvclockmax=1923, nvclockeditable=1,
  memclock=3954, memclockmin=3954, memclockmax=3954, memclockeditable=1,
  memTransferRate=7908, memTransferRatemin=7908, memTransferRatemax=7908,
  memTransferRateeditable=1 
    'GPUPerfModes' is a string attribute.
    'GPUPerfModes' is a read-only attribute.
    'GPUPerfModes' can use the following target types: X Screen, GPU.

  Attribute 'GpuUUID' (amd2018-MS-7B86:0[gpu:0]):
  GPU-bdef8eed-dc7d-98d0-d839-3ae081ee865f 
    'GpuUUID' is a string attribute.
    'GpuUUID' is a read-only attribute.
    'GpuUUID' can use the following target types: GPU.

  Attribute 'GPUUtilization' (amd2018-MS-7B86:0[gpu:0]): graphics=17, memory=3,
  video=0, PCIe=0 
    'GPUUtilization' is a string attribute.
    'GPUUtilization' is a read-only attribute.
    'GPUUtilization' can use the following target types: GPU.

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'FrameLockFirmwareUnsupported' (amd2018-MS-7B86:0[gpu:0]): 0.
    'FrameLockFirmwareUnsupported' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'FrameLockFirmwareUnsupported' is a read-only attribute.
    'FrameLockFirmwareUnsupported' can use the following target types: X
    Screen, GPU.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'Dithering' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0): 0.
    'Dithering' is an integer attribute.
    'Dithering' is display device specific.
    'Dithering' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDithering' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 1.
    'CurrentDithering' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'CurrentDithering' is a read-only attribute.
    'CurrentDithering' is display device specific.
    'CurrentDithering' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringMode' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  0.
    Valid values for 'DitheringMode' are: 0, 1, 2 and 3.
    'DitheringMode' is display device specific.
    'DitheringMode' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringMode' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 3.
    'CurrentDitheringMode' is an integer attribute.
    'CurrentDitheringMode' is a read-only attribute.
    'CurrentDitheringMode' is display device specific.
    'CurrentDitheringMode' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringDepth' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  0.
    'DitheringDepth' is an integer attribute.
    'DitheringDepth' is display device specific.
    'DitheringDepth' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringDepth' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 2.
    'CurrentDitheringDepth' is an integer attribute.
    'CurrentDitheringDepth' is a read-only attribute.
    'CurrentDitheringDepth' is display device specific.
    'CurrentDitheringDepth' can use the following target types: GPU, Display
    Device.

  Attribute 'DigitalVibrance' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  0.
    The valid values for 'DigitalVibrance' are in the range -1024 - 1023
    (inclusive).
    'DigitalVibrance' is display device specific.
    'DigitalVibrance' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'ImageSharpeningDefault' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 127.
    'ImageSharpeningDefault' is an integer attribute.
    'ImageSharpeningDefault' is a read-only attribute.
    'ImageSharpeningDefault' is display device specific.
    'ImageSharpeningDefault' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'RefreshRate' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  60,00 Hz.
    'RefreshRate' is an integer attribute.
    'RefreshRate' is a read-only attribute.
    'RefreshRate' is display device specific.
    'RefreshRate' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'RefreshRate3' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0):
  60,000 Hz.
    'RefreshRate3' is an integer attribute.
    'RefreshRate3' is a read-only attribute.
    'RefreshRate3' is display device specific.
    'RefreshRate3' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0[gpu:0]; display device:
  TV-0): 0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'SynchronousPaletteUpdates' (amd2018-MS-7B86:0[gpu:0]; display
  device: TV-0): 0.
    'SynchronousPaletteUpdates' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SynchronousPaletteUpdates' is display device specific.
    'SynchronousPaletteUpdates' can use the following target types: GPU,
    Display Device.

  Attribute 'Hdmi3D' (amd2018-MS-7B86:0[gpu:0]; display device: TV-0): 0.
    'Hdmi3D' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'Hdmi3D' is a read-only attribute.
    'Hdmi3D' is display device specific.
    'Hdmi3D' can use the following target types: GPU, Display Device.

Attributes queryable via amd2018-MS-7B86:0[fan:0]:

  Attribute 'GPUTargetFanSpeed' (amd2018-MS-7B86:0[fan:0]): 50.
    The valid values for 'GPUTargetFanSpeed' are in the range 0 - 100
    (inclusive).
    'GPUTargetFanSpeed' can use the following target types: Fan.

  Attribute 'GPUCurrentFanSpeed' (amd2018-MS-7B86:0[fan:0]): 50.
    The valid values for 'GPUCurrentFanSpeed' are in the range 0 - 100
    (inclusive).
    'GPUCurrentFanSpeed' is a read-only attribute.
    'GPUCurrentFanSpeed' can use the following target types: Fan.

  Attribute 'GPUCurrentFanSpeedRPM' (amd2018-MS-7B86:0[fan:0]): 1596.
    'GPUCurrentFanSpeedRPM' is an integer attribute.
    'GPUCurrentFanSpeedRPM' is a read-only attribute.
    'GPUCurrentFanSpeedRPM' can use the following target types: Fan.

  Attribute 'GPUFanControlType' (amd2018-MS-7B86:0[fan:0]): 2.
    'GPUFanControlType' is an integer attribute.
    'GPUFanControlType' is a read-only attribute.
    'GPUFanControlType' can use the following target types: Fan.

  Attribute 'GPUFanTarget' (amd2018-MS-7B86:0[fan:0]): 0x00000007.
    'GPUFanTarget' is a bitmask attribute.
    'GPUFanTarget' is a read-only attribute.
    'GPUFanTarget' can use the following target types: Fan.

Attributes queryable via amd2018-MS-7B86:0[thermalsensor:0]:

  Attribute 'ThermalSensorReading' (amd2018-MS-7B86:0[thermalsensor:0]): 27.
    The valid values for 'ThermalSensorReading' are in the range 0 - 127
    (inclusive).
    'ThermalSensorReading' is a read-only attribute.
    'ThermalSensorReading' can use the following target types: Thermal Sensor.

  Attribute 'ThermalSensorProvider' (amd2018-MS-7B86:0[thermalsensor:0]): 1.
    'ThermalSensorProvider' is an integer attribute.
    'ThermalSensorProvider' is a read-only attribute.
    'ThermalSensorProvider' can use the following target types: Thermal
    Sensor.

  Attribute 'ThermalSensorTarget' (amd2018-MS-7B86:0[thermalsensor:0]): 1.
    'ThermalSensorTarget' is an integer attribute.
    'ThermalSensorTarget' is a read-only attribute.
    'ThermalSensorTarget' can use the following target types: Thermal Sensor.

Attributes queryable via amd2018-MS-7B86:0[dpy:0]:

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0[dpy:0]): 0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0[dpy:0]): 0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'Dithering' (amd2018-MS-7B86:0[dpy:0]): 0.
    'Dithering' is an integer attribute.
    'Dithering' is display device specific.
    'Dithering' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDithering' (amd2018-MS-7B86:0[dpy:0]): 1.
    'CurrentDithering' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'CurrentDithering' is a read-only attribute.
    'CurrentDithering' is display device specific.
    'CurrentDithering' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringMode' (amd2018-MS-7B86:0[dpy:0]): 0.
    Valid values for 'DitheringMode' are: 0, 1, 2 and 3.
    'DitheringMode' is display device specific.
    'DitheringMode' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringMode' (amd2018-MS-7B86:0[dpy:0]): 3.
    'CurrentDitheringMode' is an integer attribute.
    'CurrentDitheringMode' is a read-only attribute.
    'CurrentDitheringMode' is display device specific.
    'CurrentDitheringMode' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringDepth' (amd2018-MS-7B86:0[dpy:0]): 0.
    'DitheringDepth' is an integer attribute.
    'DitheringDepth' is display device specific.
    'DitheringDepth' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringDepth' (amd2018-MS-7B86:0[dpy:0]): 2.
    'CurrentDitheringDepth' is an integer attribute.
    'CurrentDitheringDepth' is a read-only attribute.
    'CurrentDitheringDepth' is display device specific.
    'CurrentDitheringDepth' can use the following target types: GPU, Display
    Device.

  Attribute 'DigitalVibrance' (amd2018-MS-7B86:0[dpy:0]): 0.
    The valid values for 'DigitalVibrance' are in the range -1024 - 1023
    (inclusive).
    'DigitalVibrance' is display device specific.
    'DigitalVibrance' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'ImageSharpeningDefault' (amd2018-MS-7B86:0[dpy:0]): 127.
    'ImageSharpeningDefault' is an integer attribute.
    'ImageSharpeningDefault' is a read-only attribute.
    'ImageSharpeningDefault' is display device specific.
    'ImageSharpeningDefault' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'RefreshRate' (amd2018-MS-7B86:0[dpy:0]): 60,00 Hz.
    'RefreshRate' is an integer attribute.
    'RefreshRate' is a read-only attribute.
    'RefreshRate' is display device specific.
    'RefreshRate' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'RefreshRate3' (amd2018-MS-7B86:0[dpy:0]): 60,000 Hz.
    'RefreshRate3' is an integer attribute.
    'RefreshRate3' is a read-only attribute.
    'RefreshRate3' is display device specific.
    'RefreshRate3' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0[dpy:0]): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0[dpy:0]): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0[dpy:0]): 0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0[dpy:0]): 0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'SynchronousPaletteUpdates' (amd2018-MS-7B86:0[dpy:0]): 0.
    'SynchronousPaletteUpdates' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SynchronousPaletteUpdates' is display device specific.
    'SynchronousPaletteUpdates' can use the following target types: GPU,
    Display Device.

  Attribute 'RandROutputID' (amd2018-MS-7B86:0[dpy:0]): 446.
    'RandROutputID' is an integer attribute.
    'RandROutputID' is a read-only attribute.
    'RandROutputID' is display device specific.
    'RandROutputID' can use the following target types: Display Device.

  Attribute 'Hdmi3D' (amd2018-MS-7B86:0[dpy:0]): 0.
    'Hdmi3D' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'Hdmi3D' is a read-only attribute.
    'Hdmi3D' is display device specific.
    'Hdmi3D' can use the following target types: GPU, Display Device.

Attributes queryable via amd2018-MS-7B86:0[dpy:1]:

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0[dpy:1]): 0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0[dpy:1]): 0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'Dithering' (amd2018-MS-7B86:0[dpy:1]): 0.
    'Dithering' is an integer attribute.
    'Dithering' is display device specific.
    'Dithering' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDithering' (amd2018-MS-7B86:0[dpy:1]): 0.
    'CurrentDithering' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'CurrentDithering' is a read-only attribute.
    'CurrentDithering' is display device specific.
    'CurrentDithering' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringMode' (amd2018-MS-7B86:0[dpy:1]): 0.
    Valid values for 'DitheringMode' are: 0, 1, 2 and 3.
    'DitheringMode' is display device specific.
    'DitheringMode' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringMode' (amd2018-MS-7B86:0[dpy:1]): 0.
    'CurrentDitheringMode' is an integer attribute.
    'CurrentDitheringMode' is a read-only attribute.
    'CurrentDitheringMode' is display device specific.
    'CurrentDitheringMode' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringDepth' (amd2018-MS-7B86:0[dpy:1]): 0.
    'DitheringDepth' is an integer attribute.
    'DitheringDepth' is display device specific.
    'DitheringDepth' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringDepth' (amd2018-MS-7B86:0[dpy:1]): 0.
    'CurrentDitheringDepth' is an integer attribute.
    'CurrentDitheringDepth' is a read-only attribute.
    'CurrentDitheringDepth' is display device specific.
    'CurrentDitheringDepth' can use the following target types: GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0[dpy:1]): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0[dpy:1]): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0[dpy:1]): 0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0[dpy:1]): 0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'SynchronousPaletteUpdates' (amd2018-MS-7B86:0[dpy:1]): 0.
    'SynchronousPaletteUpdates' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SynchronousPaletteUpdates' is display device specific.
    'SynchronousPaletteUpdates' can use the following target types: GPU,
    Display Device.

  Attribute 'RandROutputID' (amd2018-MS-7B86:0[dpy:1]): 459.
    'RandROutputID' is an integer attribute.
    'RandROutputID' is a read-only attribute.
    'RandROutputID' is display device specific.
    'RandROutputID' can use the following target types: Display Device.

Attributes queryable via amd2018-MS-7B86:0[dpy:2]:

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0[dpy:2]): 0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0[dpy:2]): 0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'Dithering' (amd2018-MS-7B86:0[dpy:2]): 0.
    'Dithering' is an integer attribute.
    'Dithering' is display device specific.
    'Dithering' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDithering' (amd2018-MS-7B86:0[dpy:2]): 0.
    'CurrentDithering' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'CurrentDithering' is a read-only attribute.
    'CurrentDithering' is display device specific.
    'CurrentDithering' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringMode' (amd2018-MS-7B86:0[dpy:2]): 0.
    Valid values for 'DitheringMode' are: 0, 1, 2 and 3.
    'DitheringMode' is display device specific.
    'DitheringMode' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringMode' (amd2018-MS-7B86:0[dpy:2]): 0.
    'CurrentDitheringMode' is an integer attribute.
    'CurrentDitheringMode' is a read-only attribute.
    'CurrentDitheringMode' is display device specific.
    'CurrentDitheringMode' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringDepth' (amd2018-MS-7B86:0[dpy:2]): 0.
    'DitheringDepth' is an integer attribute.
    'DitheringDepth' is display device specific.
    'DitheringDepth' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringDepth' (amd2018-MS-7B86:0[dpy:2]): 0.
    'CurrentDitheringDepth' is an integer attribute.
    'CurrentDitheringDepth' is a read-only attribute.
    'CurrentDitheringDepth' is display device specific.
    'CurrentDitheringDepth' can use the following target types: GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0[dpy:2]): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0[dpy:2]): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0[dpy:2]): 0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0[dpy:2]): 0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'SynchronousPaletteUpdates' (amd2018-MS-7B86:0[dpy:2]): 0.
    'SynchronousPaletteUpdates' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SynchronousPaletteUpdates' is display device specific.
    'SynchronousPaletteUpdates' can use the following target types: GPU,
    Display Device.

  Attribute 'RandROutputID' (amd2018-MS-7B86:0[dpy:2]): 460.
    'RandROutputID' is an integer attribute.
    'RandROutputID' is a read-only attribute.
    'RandROutputID' is display device specific.
    'RandROutputID' can use the following target types: Display Device.

  Attribute 'DisplayPortConnectorType' (amd2018-MS-7B86:0[dpy:2]): 0.
    'DisplayPortConnectorType' is an integer attribute.
    'DisplayPortConnectorType' is a read-only attribute.
    'DisplayPortConnectorType' is display device specific.
    'DisplayPortConnectorType' can use the following target types: X Screen,
    GPU, Display Device.

  Attribute 'DisplayPortIsMultiStream' (amd2018-MS-7B86:0[dpy:2]): 0.
    'DisplayPortIsMultiStream' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'DisplayPortIsMultiStream' is a read-only attribute.
    'DisplayPortIsMultiStream' is display device specific.
    'DisplayPortIsMultiStream' can use the following target types: X Screen,
    GPU, Display Device.

  Attribute 'DisplayPortSinkIsAudioCapable' (amd2018-MS-7B86:0[dpy:2]): 0.
    'DisplayPortSinkIsAudioCapable' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'DisplayPortSinkIsAudioCapable' is a read-only attribute.
    'DisplayPortSinkIsAudioCapable' is display device specific.
    'DisplayPortSinkIsAudioCapable' can use the following target types: X
    Screen, GPU, Display Device.

Attributes queryable via amd2018-MS-7B86:0[dpy:3]:

  Attribute 'FrameLockAvailable' (amd2018-MS-7B86:0[dpy:3]): 0.
    'FrameLockAvailable' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'FrameLockAvailable' is a read-only attribute.
    'FrameLockAvailable' is display device specific.
    'FrameLockAvailable' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'IsGvoDisplay' (amd2018-MS-7B86:0[dpy:3]): 0.
    'IsGvoDisplay' is a boolean attribute; valid values are: 1 (on/true) and 0
    (off/false).
    'IsGvoDisplay' is a read-only attribute.
    'IsGvoDisplay' is display device specific.
    'IsGvoDisplay' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'Dithering' (amd2018-MS-7B86:0[dpy:3]): 0.
    'Dithering' is an integer attribute.
    'Dithering' is display device specific.
    'Dithering' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDithering' (amd2018-MS-7B86:0[dpy:3]): 0.
    'CurrentDithering' is a boolean attribute; valid values are: 1 (on/true)
    and 0 (off/false).
    'CurrentDithering' is a read-only attribute.
    'CurrentDithering' is display device specific.
    'CurrentDithering' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringMode' (amd2018-MS-7B86:0[dpy:3]): 0.
    Valid values for 'DitheringMode' are: 0, 1, 2 and 3.
    'DitheringMode' is display device specific.
    'DitheringMode' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringMode' (amd2018-MS-7B86:0[dpy:3]): 0.
    'CurrentDitheringMode' is an integer attribute.
    'CurrentDitheringMode' is a read-only attribute.
    'CurrentDitheringMode' is display device specific.
    'CurrentDitheringMode' can use the following target types: GPU, Display
    Device.

  Attribute 'DitheringDepth' (amd2018-MS-7B86:0[dpy:3]): 0.
    'DitheringDepth' is an integer attribute.
    'DitheringDepth' is display device specific.
    'DitheringDepth' can use the following target types: GPU, Display Device.

  Attribute 'CurrentDitheringDepth' (amd2018-MS-7B86:0[dpy:3]): 0.
    'CurrentDitheringDepth' is an integer attribute.
    'CurrentDitheringDepth' is a read-only attribute.
    'CurrentDitheringDepth' is display device specific.
    'CurrentDitheringDepth' can use the following target types: GPU, Display
    Device.

  Attribute 'ColorSpace' (amd2018-MS-7B86:0[dpy:3]): 0.
    Valid values for 'ColorSpace' are: 0.
    'ColorSpace' is display device specific.
    'ColorSpace' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'ColorRange' (amd2018-MS-7B86:0[dpy:3]): 0.
    Valid values for 'ColorRange' are: 0 and 1.
    'ColorRange' is display device specific.
    'ColorRange' can use the following target types: X Screen, GPU, Display
    Device.

  Attribute 'CurrentColorSpace' (amd2018-MS-7B86:0[dpy:3]): 0.
    Valid values for 'CurrentColorSpace' are: 0 and 3.
    'CurrentColorSpace' is a read-only attribute.
    'CurrentColorSpace' is display device specific.
    'CurrentColorSpace' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'CurrentColorRange' (amd2018-MS-7B86:0[dpy:3]): 0.
    Valid values for 'CurrentColorRange' are: 0 and 1.
    'CurrentColorRange' is a read-only attribute.
    'CurrentColorRange' is display device specific.
    'CurrentColorRange' can use the following target types: X Screen, GPU,
    Display Device.

  Attribute 'SynchronousPaletteUpdates' (amd2018-MS-7B86:0[dpy:3]): 0.
    'SynchronousPaletteUpdates' is a boolean attribute; valid values are: 1
    (on/true) and 0 (off/false).
    'SynchronousPaletteUpdates' is display device specific.
    'SynchronousPaletteUpdates' can use the following target types: GPU,
    Display Device.

  Attribute 'RandROutputID' (amd2018-MS-7B86:0[dpy:3]): 461.
    'RandROutputID' is an integer attribute.
    'RandROutputID' is a read-only attribute.
    'RandROutputID' is display device specific.
    'RandROutputID' can use the following target types: Display Device.
 ```
