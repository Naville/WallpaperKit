#WallpaperKit

Yet another macOS Desktop Rendering Kit.  

#Documentation
Built-in AppleDoc-style documentation.  
Built and saved in project root automatically when attempting to build the framework in Xcode, provided that appledoc is installed

#Status
Currently GUI settings are still minimal, check [UpdateWallpaperKitDB.py](https://gist.github.com/Naville/b7b635d82ba520044be031a297efa008)

Note the format of the output from this python script is only compatible for use with 

```
+[MainViewController CollectPref]
```

to have an idea about this process

#Build Process
VLCPlayer is enabled by default, which makes the project depends on VLCKit.  
Build it yourself and mess around with the project's link settings (*Quite an effort!*)
Or Download [Official Nightly Builds](https://nightlies.videolan.org/build/macosx-intel/) and install to /Library/Frameworks/
