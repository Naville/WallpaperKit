//
//  WallpaperKit.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKRenderProtocal.h"
#import "WKWindow.h"
#define StopNotification @"com.naville.wpkit.stop"
@interface WKDesktop : NSObject
/**
 Render Current WKDesktop Object

 @param renderEngine Class for Rendering Current Object
 @param args Arguments For The Render
 */
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(nonnull NSDictionary*)args;
/**
 Cleanup Subviews
 */
-(void)cleanup;
-(void)pause;
-(void)stop;
-(void)play;
@property (readwrite,retain,atomic,nonnull) WKWindow* displayWindow;
@property (readwrite,retain,atomic,nonnull) NSView* currentView;
@end
