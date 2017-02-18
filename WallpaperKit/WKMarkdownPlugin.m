//
//  WKMarkdownPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/2/11.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKMarkdownPlugin.h"
#import <MMMarkdown/MMMarkdown.h>
@implementation WKMarkdownPlugin

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSString* markdown=[args objectForKey:@"Markdown"];
    NSString* CSS=[args objectForKey:@"CSS"];
    NSString *rawHTML = [MMMarkdown HTMLStringWithMarkdown:markdown extensions:MMMarkdownExtensionsGitHubFlavored error:NULL];
    NSString* htmlString=[NSString stringWithFormat:@"<head>\
                          <style>\
                          %@\
                          </style>\
                          </head>\
                          <div id=\"WKMarkdownWrapper\">\
                          %@\
                          </div>",(CSS==nil)?@"":CSS,rawHTML];
    return [super initWithWindow:window andArguments:@{@"HTML":htmlString}];
}
@end
