//
//  WKWebpagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWebpagePlugin.h"
#import "WKUtils.h"
#import <AVFoundation/AVFoundation.h>
@implementation WKWebpagePlugin {
        NSURL *webURL;
        NSString *HTMLString;
        NSString *Javascript;
        NSString *description;
        NSURL *baseURL;
}

- (instancetype)initWithWindow:(WKDesktop *)window
                  andArguments:(NSDictionary *)args {
        [window setBackgroundColor:[NSColor blackColor]];
        NSRect frameRect = window.frame;
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        WKUserContentController *controller =
            [[WKUserContentController alloc] init];
    if(args[@"Cookie"]!=nil){
        NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = '%@';", args[@"Cookie"]];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [controller addUserScript:cookieScript];
    }

        config.userContentController = controller;

        self = [super initWithFrame:frameRect configuration:config];

        // Stolen from
        // http://stackoverflow.com/questions/40007753/macos-wkwebview-background-transparency
        if (NSAppKitVersionNumber > 1500) {
                [self setValue:@(NO) forKey:@"drawsBackground"];
        } else {
                [self setValue:@(YES) forKey:@"drawsTransparentBackground"];
        }
        self->webURL = (NSURL *)[args objectForKey:@"Path"];
        self->baseURL = (NSURL *)[args objectForKey:@"BaseURL"];
        self->HTMLString = (NSString *)[args objectForKey:@"HTML"];
        self->Javascript = (NSString *)[args objectForKey:@"Javascript"];
        if (webURL != nil && HTMLString != nil) {
                @throw [NSException
                    exceptionWithName:NSInvalidArgumentException
                               reason:
                                   @"Please Specify Either URL or HTML String."
                             userInfo:args];
        }
        self->description = (webURL != nil) ? webURL.path : self->HTMLString;
        self.acceptsTouchEvents = YES;
        self.requiresConsistentAccess = NO;
        self.requiresExclusiveBackground = YES;
        self.arg=args;
        return self;
}
- (void)play {
        [self.window setAcceptsMouseMovedEvents:YES];
        [self evaluateJavaScript:@"document.querySelector('body').innerHTML"
               completionHandler:^(id result, NSError *error) {
                 if (!result || ([result isKindOfClass:[NSString class]] &&
                                 [((NSString *)result)length] == 0)) {
                         if (webURL != nil) {
                                 NSMutableURLRequest *req =
                                     [NSMutableURLRequest requestWithURL:self->webURL];
                             if(self.arg[@"Cookie"]!=nil){
                                 [req addValue:self.arg[@"Cookie"] forHTTPHeaderField:@"Cookie"];
                             }
                                 [self loadRequest:req];

                         } else {
                                 [self loadHTMLString:HTMLString
                                              baseURL:self->baseURL];
                         }
                 }
               }];
        if (self->Javascript != nil) {
                [self evaluateJavaScript:Javascript completionHandler:nil];
        }
}
- (NSString *)description {
        return [@"WKWebpagePlugin " stringByAppendingString:self->description];
}
- (void)pause {
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (NSMutableDictionary *)convertArgument:(NSDictionary *)args
                               Operation:(WKSerializeOption)op {
        NSMutableDictionary *returnValue =
            [NSMutableDictionary dictionaryWithDictionary:args];
        if (op == TOJSON) {
                returnValue[@"Render"] = @"WKWebpagePlugin";
                if ([returnValue.allKeys containsObject:@"Path"]) {
                        returnValue[@"Path"] =
                            [(NSURL *)returnValue[@"Path"] absoluteString];
                }
                if ([returnValue.allKeys containsObject:@"BaseURL"]) {
                        returnValue[@"BaseURL"] =
                            [(NSURL *)returnValue[@"BaseURL"] absoluteString];
                }
        } else if (op == FROMJSON) {
                returnValue[@"Render"] = NSClassFromString(@"WKWebpagePlugin");
                if ([returnValue.allKeys containsObject:@"Path"]) {
                        returnValue[@"Path"] =
                            [NSURL URLWithString:[args objectForKey:@"Path"]];
                }
                if ([returnValue.allKeys containsObject:@"BaseURL"]) {
                        returnValue[@"BaseURL"] = [NSURL
                            URLWithString:[args objectForKey:@"BaseURL"]];
                }
        }

        return returnValue;
}
@end
