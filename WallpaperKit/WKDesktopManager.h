//
//  WKDesktopManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#define WRONG_WINDOW_ID -500
@interface WKDesktopManager : NSObject
+ (instancetype)sharedInstance;
/**
 Call after WKRenderManager has been properly populated to create Wallpaper for current space
 */
-(void)start;
@property (readwrite,retain,atomic) NSMutableDictionary* windows;
@property (readwrite,retain,atomic) NSView* activeWallpaperView;
@end
