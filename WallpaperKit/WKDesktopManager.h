//
//  WKDesktopManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "WKRenderManager.h"
#import "WKDesktop.h"
#define WRONG_WINDOW_ID -500
@interface WKDesktopManager : NSObject
+ (instancetype)sharedInstance;
-(void)stop;
/**
 Create Window of current workspace if not exists. And return it
 
 @return Wallpaper Window of current space.
 */
-(WKDesktop*)windowForCurrentWorkspace;
-(void)discardCurrentSpace;
@property (readwrite,retain,atomic) NSMutableDictionary* windows;
@property (readwrite,retain,atomic) NSView* activeWallpaperView;
@end
