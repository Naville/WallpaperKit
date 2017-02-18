//
//  WKPluginProtocal.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#ifndef WKRENDERPROTOCAL_H
#define WKRENDERPROTOCAL_H
#import "WKDesktop.h"

@class WKDesktop;
@protocol WKRenderProtocal

@required
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@optional
- (void)pause;
- (void)play;
/**
 Called when current display space has changed. When implemented, renderer will not be pause or stopped unless new renderer also implemented the same method. Useful for Renderers to gain continously background access
 */
-(void)handleSpaceChange;
@end
#endif

