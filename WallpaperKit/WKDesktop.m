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
    
    CGRect fullRect=CGDisplayBounds(CGMainDisplayID());
    self= [super initWithContentRect:fullRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    self.releasedWhenClosed=NO;//Fix Memory Issue
    [self setWindow];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setOpaque:NO];
    self.delegate=self;
    
    return self;
}
-(void)setWindow{
    [self setLevel:kCGDesktopIconWindowLevel-1];
    [self setStyleMask:NSWindowStyleMaskBorderless];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    self.collectionBehavior=(NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorParticipatesInCycle);
    self.hasShadow=NO;
    [self setContentView:_currentView];
    [self orderFront:nil];
    [self makeKeyAndOrderFront:self];
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    _currentView=[[renderEngine alloc] initWithWindow:self andArguments:args];
    
    
}
-(void)pause{
    if([_currentView respondsToSelector:@selector(pause)]){
        [_currentView performSelector:@selector(pause)];
    }
}
-(void)close{
    [self pause];
    [_currentView removeFromSuperview];
    self->_currentView=nil;
    [super close];
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
- (void)windowDidChangeOcclusionState:(NSNotification *)notification{
    if(self.occlusionState & NSApplicationOcclusionStateVisible){
        NSLog(@"VS:%@",[self description]);
        [self play];
    }
    else{
        [self pause];
        NSLog(@"NVS:%@",[self description]);
    }
}
-(NSString*)description{
    return [[super description] stringByAppendingString:[@" with view:" stringByAppendingString:[_contentView description]]];
}
@end

