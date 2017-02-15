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
 @param args Arguments For Rendering
    Webpage can be specified by using either:
 
            @"Path" the NSURL of target webpage
            @"HTML" the raw HTML
 
    @"Javascript" is an optional item,which will be evaluated after the page is loaded
 @return UIView for Caller to deal with
 */
- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args;
@end
