//
//  WKImagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKImagePlugin.h"

@implementation WKImagePlugin

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    self=[super initWithFrame:frameRect];
    [self setImage:[[NSImage alloc] initWithContentsOfURL:[args objectForKey:@"Path"]]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    return self;
}

@end
