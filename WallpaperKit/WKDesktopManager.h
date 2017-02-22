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
 Create Window of current workspace using given render. Remove existing Window
 @param SpaceID SpaceID of target Workspace
 @param render Render.Can be obtained from WKRenderManager
 @return Wallpaper Window of current space.
 */
-(nonnull WKDesktop*)createDesktopWithSpaceID:(NSUInteger)SpaceID andRender:(nonnull NSDictionary*)render;
-(NSUInteger)currentSpaceID;
/**
 Display Given WKDesktop.
 @param wk Desktop to display
 */
-(void)DisplayDesktop:(nonnull WKDesktop*)wk;
/**
 Obtain Desktop for a give SpaceID. Return nil if there is no Desktop for the SpaceID

 @param spaceID SpaceID for the query
 @return <#return value description#>
 */
-(nullable WKDesktop*)desktopForSpaceID:(NSUInteger)spaceID;
@property (readwrite,retain,atomic)  NSMutableDictionary<NSNumber*,WKDesktop *>* _Nonnull  windows;
@property (readwrite,retain,atomic)  NSView* _Nullable  activeWallpaperView;
@end
