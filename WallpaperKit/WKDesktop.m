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
#import <CoreGraphics/CoreGraphics.h>
@implementation WKDesktop
-(instancetype)init{
    
    self= [super initWithContentRect:CGDisplayBounds(CGMainDisplayID())
                                                   styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    [self setWindow];
    self.delegate=self;
    
    return self;
}
-(void)setWindow{
    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setLevel:kCGDesktopIconWindowLevel-1];
    [self setStyleMask:NSWindowStyleMaskBorderless];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    self.collectionBehavior=(NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorParticipatesInCycle);
    self.hasShadow=NO;
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    
    [self->_currentView removeFromSuperview];
    self->_currentView=nil;
    _currentView=[[renderEngine alloc] initWithWindow:self andArguments:args];
    
    
}
-(void)pause{
    if([_currentView respondsToSelector:@selector(pause)]){
        [_currentView performSelector:@selector(pause)];
    }
  //  [self orderOut:self];
}
-(void)stop{
    [self pause];
    [_currentView removeFromSuperview];
    self->_currentView=nil;
    [self close];
}
-(void)play{
    if([_currentView respondsToSelector:@selector(play)]){
        
        [_currentView performSelector:@selector(play)];
    }
    [self setContentView:_currentView];
    [self orderFront:nil];
    [self makeKeyAndOrderFront:self];
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
-(BOOL)canBecomeKeyWindow{return YES;}
-(void)windowDidBecomeKey:(NSNotification *)notification{
    [self setWindow];
    NSLog(@"%@--windowDidBecomeKey",self);
}
-(void)windowDidBecomeMain:(NSNotification *)notification{
     [self setWindow];
    NSLog(@"%@--windowDidBecomeMain",self);
}
-(void)windowDidResignMain:(NSNotification *)notification{
    NSLog(@"%@--windowDidResignMain",self);
}
-(void)windowDidResignKey:(NSNotification *)notification{
    NSLog(@"%@--windowDidResignKey",self);
}
@end
