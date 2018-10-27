//
//  WKVLCVideoPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 20/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
#import "VLCKit/VLCKit.h"
/**
 Video Player Using FFMPEG Wrapped In VLCKit As Decoder
 
 Requires VLCKit to build and run
 
 Downloadable from https://nightlies.videolan.org/build/macosx-intel/
 */
@interface WKVLCVideoPlugin : VLCVideoView<WKRenderProtocal,VLCMediaPlayerDelegate>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering. Available Keys:
 
 Path NSURL of target Video
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@property (nonatomic,assign,readwrite) NSDictionary* arg;
@end
