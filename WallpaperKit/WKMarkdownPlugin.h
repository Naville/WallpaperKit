//
//  WKMarkdownPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/2/11.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWebpagePlugin.h"
@interface WKMarkdownPlugin : WKWebpagePlugin
/**
 Renderer For Markdown Files
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering.Rendered HTML is wrapperin a \<div\> with id “WKMarkdownWrapper”
 
            @"Markdown" NSString* of the markdown
            @"CSS" Optional. NSString of CSS
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@end
