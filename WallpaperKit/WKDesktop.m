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
#import <objc/runtime.h>
#import "WKRenderProtocal.h"
@implementation WKDesktop{
    WKWindow* displayWindow;
    NSView* currentView;
}
-(instancetype)init{
    self=[super init];
    displayWindow=[WKWindow newFullScreenWindow];
    return self;
}
-(void)stop{
    NSLog(@"Stopping Wallpaper");
    [NSApp deactivate];
    [displayWindow close];
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    
    [self cleanup];
    currentView=[[renderEngine alloc] initWithWindow:displayWindow andArguments:args];
    [displayWindow.contentView addSubview:currentView];
    
}
-(void)cleanup{
    [currentView removeFromSuperview];
    currentView=nil;
}
-(void)observer:(NSNotification *)notif{
    
}
-(void)pause{
    if([currentView respondsToSelector:@selector(pause)]){
        [currentView performSelector:@selector(pause)];
    }
}
-(void)play{
    if([currentView respondsToSelector:@selector(play)]){
        [currentView performSelector:@selector(play)];
    }
}
@end
