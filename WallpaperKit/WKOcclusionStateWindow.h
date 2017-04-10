//
//  WKOcclusionStateWindow.h
//  WallpaperKit
//
//  Created by Naville Zhang on 18/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <AppKit/AppKit.h>
#define OStateChangeNotificationName @"com.naville.wallpaperkit.occulastionstate"
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
 
 @discussion [NSScreen mainScreen].visibleFrame returns the frame without menubar/dock and stuff.
            However that means our window must be fully covered pixel by pixel to trigger an OSChange,
            which is unlikely to happen in real-life scenario. (Remember a Cocoa Window usually has circle bounds instead of rects,thus it will always left out a few pixels.
            Thus we craft a frame slightly smaller than this frame to suit real-life usage better.
 @return Invisible NSWindow
 */
+ (instancetype)sharedInstance;
/**
 Post New Notification With Current OcculastionState
 */
-(void)refreshOSState;
@end
