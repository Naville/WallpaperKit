//
//  WKWebpagePlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "WKRenderProtocal.h"
@interface WKWebpagePlugin : WKWebView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args NSDictionary with @"Path" being the NSURL of target webpage
 @return UIView for Caller to deal with
 */
- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args;
@end
