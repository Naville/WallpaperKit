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
 Requires VLCKit to build and run
 
 Downloadable from https://nightlies.videolan.org/build/macosx-intel/
 */
@interface WKVLCVideoPlugin : VLCVideoView<WKRenderProtocal,VLCMediaPlayerDelegate>
@property (nonatomic) BOOL requiresConsistentAccess;
@end
