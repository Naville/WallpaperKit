//
//  WallpaperKit.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <AppKit/AppKit.h>
#import "WKRenderProtocal.h"
@interface WKDesktop : NSWindow<NSWindowDelegate>
/**
 Render Current WKDesktop Object

 @param renderEngine Class for Rendering Current Object
 @param args Arguments For The Render
 */
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(nonnull NSDictionary*)args;
/**
 Cleanup Subviews
 */
-(void)pause;
-(void)play;
@property (readwrite,retain,nonatomic,nonnull) NSView<WKRenderProtocal>* currentView;
/**
 NSError used by Render
 */
@property (readwrite,strong,nonatomic,nullable) NSError* err;
@end
