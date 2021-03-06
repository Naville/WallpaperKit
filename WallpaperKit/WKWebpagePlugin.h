//
//  WKWebpagePlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import "WKDesktop.h"
#import <WebKit/WebKit.h>

@interface WKWebpagePlugin : WKWebView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering
    Webpage can be specified by using either:
 
            @"Path" the NSURL of target webpage
            @"HTML" the raw HTML NSString*
 
    @"Javascript" is an optional NSString*,which will be evaluated after the page is loaded
    @"BaseURL" is an optional NSURL*,which will be used as BaseURL for the request
    @"Cookie" is an optional Cookie string
 @discussion MouseEvents are supported by explicited overwrite NSEvent Handlers and execute JS
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@property (nonatomic,assign,readwrite) NSDictionary* arg;
@end
