//
//  WKWebpagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWebpagePlugin.h"

@implementation WKWebpagePlugin

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    self.mainFrameURL=[(NSURL*)[args objectForKey:@"Path"] absoluteString];
    self.hostWindow=window;
    return self;
}


@end
