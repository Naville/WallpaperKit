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
-(void)handleSpaceChange;//Implement This Method To Avoid @selector(pause) sent to self
@end

