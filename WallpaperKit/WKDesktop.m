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
    self.opaque=NO;
    self.contentView=[[NSView alloc] initWithFrame:contentRect];
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
    self.mainView=[[renderEngine alloc] initWithWindow:self andArguments:args];
    if(self.err!=nil){
        @throw [NSException exceptionWithName:NSGenericException reason:self.err.localizedDescription userInfo:args];
    }
    
    [self.contentView addSubview:self.mainView];
    [self.mainView display];
    
    
}
-(void)pause{
    if(self->isPlaying==NO){
        return ;
    }
    for(NSView<WKRenderProtocal>* view in self.contentView.subviews){
        if([view respondsToSelector:@selector(pause)]){
            [view pause];
        }
    }
    self->isPlaying=NO;
}
-(void)close{
    [self pause];
    for(NSView<WKRenderProtocal>* view in self.contentView.subviews){
        if([view respondsToSelector:@selector(stop)]){
            [view stop];
        }
    }
    [super close];
}
-(void)play{
    if(self->isPlaying==YES){
        return ;
    }
    for(NSView<WKRenderProtocal>* view in self.contentView.subviews){
        if([view respondsToSelector:@selector(play)]){
            [view play];
        }
    }
    self->isPlaying=YES;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
-(NSString*)description{
    return [self.mainView description];
}
-(void)dealloc{
    [self pause];
}
@end

