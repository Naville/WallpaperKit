//
//  WKWebpagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWebpagePlugin.h"

@implementation WKWebpagePlugin{
    NSURL* webURL;
    NSString* HTMLString;
    NSString* Javascript;
}

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    self->webURL=(NSURL*)[args objectForKey:@"Path"];
    self->HTMLString=(NSString*)[args objectForKey:@"HTML"];
    self->Javascript=(NSString*)[args objectForKey:@"Javascript"];
    if(webURL==nil && HTMLString==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"No valid webpage." userInfo:args];
    }
    if(webURL!=nil && HTMLString!=nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please Specify Either URL or HTML String." userInfo:args];
    }
    return self;
}
-(void)play{
    [self evaluateJavaScript:@"document.querySelector('body').innerHTML" completionHandler:^(id result, NSError *error) {
        if (!result || ([result isKindOfClass:[NSString class]] && [((NSString *)result) length] == 0)) {
            if(webURL!=nil){
                [self loadRequest:[NSURLRequest requestWithURL:self->webURL]];
            }
            else{
                [self loadHTMLString:HTMLString baseURL:nil];
            }
            
        }
        }];
    if(self->Javascript!=nil){
        [self evaluateJavaScript:Javascript completionHandler:^(id result, NSError *error) {}];
    }

   
}
@end
