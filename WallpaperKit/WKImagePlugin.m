//
//  WKImagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKImagePlugin.h"

@implementation WKImagePlugin{
    NSString* desc;
    NSURL* ImagePath;
}

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    self=[super initWithFrame:frameRect];
    self->ImagePath=[args objectForKey:@"Path"];
    self->desc=[[(NSURL*)[args objectForKey:@"Path"] absoluteString] stringByRemovingPercentEncoding];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self.requiresConsistentAccess=NO;
    return self;
}
-(void)play{
    [self setImage:[[NSImage alloc] initWithContentsOfURL:self->ImagePath]];
}
-(void)pause{
    
}
@end
