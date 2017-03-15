# WallpaperKit

Yet another macOS Desktop Rendering Kit.  

# Documentation
Built-in AppleDoc-style documentation.  
Built and saved in project root automatically when attempting to build the framework in Xcode, provided that appledoc is installed

# Status
## Database Version 1

***This is now deprecated and only used by following metthod explicitly***

```
+[MainViewController CollectPref]
```

[UpdateWallpaperKitDBSample.py](https://gist.github.com/Naville/b7b635d82ba520044be031a297efa008)

## Database Version 2
An ***NSArray*** of serialised ***NSDictionary***  

Serialization can be achieved bidirectionally by calling 

```
+(NSMutableDictionary*)convertArgument:(NSDictionary*)args Operation:(RenderConvertOperation)op;  
```

of corresponding Plugin

Check **WKRenderProtocal.h** for usage

Example Python Script: [WallpaperKitDatabaseExampleV2.py](https://gist.github.com/Naville/77947441895131545d065b8c36274d23)



# Build Process
VLCPlayer is enabled by default, which makes the project depends on VLCKit.  
Build it yourself and mess around with the project's link settings (*Quite an effort!*)
Or Download [Official Nightly Builds](https://nightlies.videolan.org/build/macosx-intel/) and install to /Library/Frameworks/
