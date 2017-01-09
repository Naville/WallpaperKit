//
//  WKPluginProtocal.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
@protocol WKRenderProtocal<NSObject>

@required
- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args;
@optional
- (void)pause;
-(void)play;
/**
 Called when current display space has changed. When implemented, renderer will not be pause or stopped unless new renderer also implemented the same method. Useful for Renderers to gain continously background access
 */
-(void)handleSpaceChange;
@end

