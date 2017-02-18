//
//  WKPluginProtocal.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <AppKit/AppKit.h>
@class WKDesktop;

@protocol WKRenderProtocal

@required
@property (nonatomic) BOOL requiresConsistentAccess;
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
/**
 Pause Current View. Called when Current Workspace has changed
 */
- (void)pause;
/**
 Start Displaying Current View
 */
- (void)play;

@end

