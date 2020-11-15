Android rsync Builds
====================

![Build status](https://github.com/ribbons/android-rsync/workflows/Build/badge.svg)

Build script to cross-compile [rsync](https://rsync.samba.org/) for Android.


Precompiled Binaries
--------------------

armv7a and aarch64 binaries compiled under GitHub Actions are available as
release assets from this repository.


Manual Build
------------

* Ensure that the Android NDK is located at `$ANDROID_NDK_HOME` or
  `$ANDROID_HOME/ndk-bundle`.
* Download and unpack the latest rsync source into a subfolder named `rsync`.
* Run `./build`

Testing
-------
### Copy/Sync a Remote Directory to a Local Machine
```
$ rsync -avzh root@192.168.0.100:/home/tarunika/rpmpkgs /tmp/myrpms
```

Version History:
----------------
2020-11-15: Build using NDK android-ndk-r13b

[1]: https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/