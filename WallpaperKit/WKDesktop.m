//
//  WallpaperKit.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
@implementation WKDesktop
-(instancetype)init{
    self=[super init];
    _displayWindow=[WKWindow newFullScreenWindow];
    return self;
}
-(void)stop{
    NSLog(@"Stopping Wallpaper");
    [NSApp deactivate];
    [_displayWindow close];
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    
    [self cleanup];
    _currentView=[[renderEngine alloc] initWithWindow:_displayWindow andArguments:args];
    [_displayWindow.contentView addSubview:_currentView];
    
}
-(void)cleanup{
    [_currentView removeFromSuperview];
    _currentView=nil;
}
-(void)observer:(NSNotification *)notif{
    
}
-(void)pause{
    if([_currentView respondsToSelector:@selector(pause)]){
        [_currentView performSelector:@selector(pause)];
    }
}
-(void)play{
    if([_currentView respondsToSelector:@selector(play)]){
        [_currentView performSelector:@selector(play)];
    }
}
@end
