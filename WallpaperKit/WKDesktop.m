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
    NSMutableArray* WKViews;//Register WKRenderProtocal Views into this array for operations
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
    self->WKViews=[NSMutableArray array];
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
    NSView<WKRenderProtocal>* foo=[(NSView<WKRenderProtocal>*)[renderEngine alloc] initWithWindow:self andArguments:args];
    [self addView:foo];
    
    
}
-(void)discardMainView{
    if(self.mainView!=nil){
        [self->WKViews removeObject:self.mainView];
        if([self.mainView respondsToSelector:@selector(stop)]){
            [self.mainView performSelector:@selector(stop)];
        }
        else{
            [self.mainView pause];
        }
        [self.mainView removeFromSuperview];
        self.mainView=nil;
    }
}
-(void)pause{
    if(self->isPlaying==NO){
        return ;
    }
    for(NSView<WKRenderProtocal>* view in self->WKViews){
        [view pause];
    }
    self->isPlaying=NO;
}
-(void)close{
    [self pause];
    for(NSView<WKRenderProtocal>* view in self->WKViews){
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
    for(NSView<WKRenderProtocal>* view in self->WKViews){
            [view play];
    }
    self->isPlaying=YES;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
-(void)addView:(NSView*)view{
    if([[view class] conformsToProtocol:@protocol(WKRenderProtocal)]){
        NSView<WKRenderProtocal>* foo=(NSView<WKRenderProtocal>*)view;
        [self->WKViews addObject:foo];
        if(foo.requiresExclusiveBackground==YES){
            [self discardMainView];
        }
        if(self.mainView==nil){
            self.mainView=foo;
            
        }
        [foo play];
        
    }
    [self.contentView addSubview:view];
    [view display];
    
}

-(NSString*)description{
    return [self.mainView description];
}
-(void)dealloc{
    [self pause];
}
@end

