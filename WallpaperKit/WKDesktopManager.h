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
#import "WKUtils.h"
#define WRONG_WINDOW_ID -500
@interface WKDesktopManager : NSObject
+ (nonnull instancetype)sharedInstance;
-(void)stop;
-(void)discardSpaceID:(NSUInteger)spaceID;
/**
 Create Window of current workspace using given render if not exists. And return it.
 @param SpaceID SpaceID of target Workspace
 @param render Render.Can be obtained from WKRenderManager
 @return Wallpaper Window of current space.
 */
-(nonnull WKDesktop*)createDesktopWithSpaceID:(NSUInteger)SpaceID andRender:(nonnull NSDictionary*)render;
+(CGRect)calculatedRenderSize;
-(NSUInteger)currentSpaceID;
/**
 Display Given WKDesktop.
 @param wk Desktop to display
 */
-(void)DisplayDesktop:(nonnull WKDesktop*)wk;
@property (readwrite,retain,atomic)  NSMutableDictionary* _Nonnull  windows;
@property (readwrite,retain,atomic)  NSView* _Nullable  activeWallpaperView;
@end
