//
//  WKVideoPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WKRenderProtocal.h"

@interface WKVideoPlugin : AVPlayerView<WKRenderProtocal>

@end