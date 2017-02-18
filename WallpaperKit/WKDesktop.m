//
//  WallpaperKit.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation WKDesktop{
    BOOL isPlaying;
}
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    self= [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag];
    self.releasedWhenClosed=NO;//Fix Memory Issue
    self.delegate=self;
    [self setBackgroundColor:[NSColor blackColor]];
    [self setLevel:kCGDesktopIconWindowLevel-1];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    self.ThresholdDisplayCoveredRate=0.8;
    self->isPlaying=NO;
    self.collectionBehavior=NSWindowCollectionBehaviorStationary;
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(handleAppChange:) name:NSWorkspaceDidActivateApplicationNotification object:nil];
    return self;
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    _currentView=[[renderEngine alloc] initWithWindow:self andArguments:args];
    if(self.err!=nil){
        @throw [NSException exceptionWithName:NSGenericException reason:self.err.localizedDescription userInfo:args];
    }
    
    
}
-(void)pause{
    if(self->isPlaying==NO){
        return ;
    }
    [_currentView pause];
    self->isPlaying=NO;
}
-(void)close{
    
    [self pause];
    self->_currentView=nil;
    [super close];
}
-(void)play{
    if(self->isPlaying==YES){
        return ;
    }
    [self setContentView:_currentView];
    [_currentView play];
    [self makeKeyAndOrderFront:nil];
    self->isPlaying=YES;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
- (void)windowDidChangeOcclusionState:(NSNotification *)notification
{
    if ([[notification object] occlusionState]  &  NSWindowOcclusionStateVisible) {
       // NSLog(@"Visible");
        [self play];
    } else {
        //NSLog(@"Hidden");
        [self pause];
    }
}
-(void)handleAppChange:(NSNotification*)notif{
    if([[notif.userInfo objectForKey: NSWorkspaceApplicationKey] isEqualTo:[NSRunningApplication currentApplication]]){
        [self play];
        return ;
    }
    double HiddenRate=[WKUtils OcclusionRateForWindow:self];
    if(HiddenRate>0.8){
       // NSLog(@"Hidden. %f Covered",HiddenRate);
        [self pause];
    }
}
-(NSString*)description{
    return [self.contentView description];
}
@end

