//
//  WKVLCVideoPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WKRenderProtocal.h"
#import <VLCKit/VLCKit.h>

@interface WKVLCVideoPlugin : VLCVideoView<WKRenderProtocal>

@end
