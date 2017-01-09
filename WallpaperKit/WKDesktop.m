//
//  WallpaperKit.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
#import "WKWindow.h"
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
@implementation WKDesktop{
    WKWindow* displayWindow;
}
-(instancetype)init{
    self=[super init];
    displayWindow=[WKWindow newFullScreenWindow];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observer:) name:StopNotification object:nil];
    return self;
}
-(void)stop{
    NSLog(@"Stopping Wallpaper");
    [NSApp deactivate];
    [displayWindow close];
}
-(void)renderWithEngine:(Class)renderEngine withArguments:(NSDictionary *)args{
    [self cleanup];
    NSView* subView=[[renderEngine alloc] initWithWindow:displayWindow andArguments:args];
    [displayWindow.contentView addSubview:subView];
    
}
-(void)cleanup{
    for(NSView* view in [displayWindow.contentView subviews]){
        [view removeFromSuperview];
    }
}
-(void)observer:(NSNotification *)notif{
    if([notif.name isEqualToString:@"com.naville.wpkit.stop"]){
        [self stop];
    }
    
}
@end
