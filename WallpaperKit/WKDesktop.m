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
    [self setLevel:kCGDesktopIconWindowLevel-1];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    self->isPlaying=NO;
    self.collectionBehavior=(NSWindowCollectionBehaviorStationary|NSWindowCollectionBehaviorParticipatesInCycle);
    return self;
}
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(NSDictionary *)args{
    if(renderEngine==nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"RenderEngine is null" userInfo:nil];
    }
    if(![renderEngine conformsToProtocol:@protocol(WKRenderProtocal)]||![renderEngine isSubclassOfClass:[NSView class]]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",NSStringFromClass(renderEngine)] userInfo:nil];
    }
    self.currentView=[[renderEngine alloc] initWithWindow:self andArguments:args];
    if(self.err!=nil){
        @throw [NSException exceptionWithName:NSGenericException reason:self.err.localizedDescription userInfo:args];
    }
    [self setContentView:_currentView];
    
    
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
    if([self.currentView respondsToSelector:@selector(stop)]){
        [self.currentView performSelector:@selector(stop)];
    }
    [super close];
}
-(void)play{
    if(self->isPlaying==YES){
        return ;
    }
    [_currentView play];
    self->isPlaying=YES;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
-(NSString*)description{
    return [self.contentView description];
}
-(void)dealloc{
    [self.currentView pause];
    self.contentView=nil;
    self.err=nil;
}
@end

