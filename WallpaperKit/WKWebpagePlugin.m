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
}

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    self->webURL=(NSURL*)[args objectForKey:@"Path"];
    return self;
}
-(void)play{
    [self loadRequest:[NSURLRequest requestWithURL:self->webURL]];
}
- (void)mouseMoved:(NSEvent *)event
{
    NSLog(@"%@",event);
}
@end
