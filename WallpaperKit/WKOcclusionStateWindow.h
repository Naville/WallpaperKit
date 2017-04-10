//
//  WKOcclusionStateWindow.h
//  WallpaperKit
//
//  Created by Naville Zhang on 18/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <AppKit/AppKit.h>
#define OStateChangeNotificationName @"com.naville.wallpaperkit.occulastionstate"
#define OSStateFrameNotification
/**
 Dummy Invisible Singleton Window For Handling OcclusionState Changes
 As the default NSWindowDelegate one doesn't work well for kCGDesktopIconWindowLevel-1
 */
@interface WKOcclusionStateWindow : NSWindow<NSWindowDelegate>
/**
Singleton of the Window which persists across all WorkSpaces
OStateChangeNotificationName is posted when OcclusionState Changes.
Notification UserInfo Contains:
    - @"Visibility" and @"CurrentSpaceID" wrapped in NSNumber
 
 @return Invisible NSWindow
 */
+ (instancetype)sharedInstance;
@end
