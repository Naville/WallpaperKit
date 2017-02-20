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
    [window setBackgroundColor:[NSColor blackColor]];
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
    self=[super initWithWindow:window andArguments:@{@"HTML":htmlString}];
    
    self.requiresConsistentAccess=NO;
    return self;
}
+(NSDictionary*)convertArgument:(NSDictionary *)args Operation:(NSUInteger)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKMarkdownPlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[[(NSURL*)returnValue[@"Path"] absoluteString] stringByRemovingPercentEncoding];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=NSClassFromString(@"WKMarkdownPlugin");
        if([returnValue.allKeys containsObject:@"Path"]){
            NSMutableString* url=[[args objectForKey:@"Path"] mutableCopy];
            if([url hasPrefix:@"/"]){
                [url insertString:@"file://" atIndex:0];
            }
            returnValue[@"Path"]=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return returnValue;
}
@end
