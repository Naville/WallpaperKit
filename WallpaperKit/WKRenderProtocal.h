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
@end
