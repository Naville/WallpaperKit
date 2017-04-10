//
//  WKOcclusionStateWindow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 18/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKOcclusionStateWindow.h"
#import "WKDesktopManager.h"
static WKOcclusionStateWindow *sI = nil;
static dispatch_once_t onceToken;
@implementation WKOcclusionStateWindow
+ (instancetype)sharedInstance{
    dispatch_once(&onceToken, ^{
        CGRect rawSize=[NSScreen mainScreen].visibleFrame;
        NSRect windowRect=NSMakeRect(rawSize.size.width/20, rawSize.size.height/20,11*rawSize.size.width/12, 11*rawSize.size.height/12);
        //CGRect windowRect=[NSScreen mainScreen].visibleFrame;
        sI = [[WKOcclusionStateWindow alloc] initWithContentRect:windowRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:YES];
    });
    return sI;
}
-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if(sI!=nil){
        return sI;
    }
    self=[super initWithContentRect:contentRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:YES];
    self.delegate=self;
    [self setLevel:kCGDesktopIconWindowLevel+1];
    [self setBackgroundColor:[NSColor clearColor]];
    //[self setBackgroundColor:[NSColor redColor]];
    [self setOpaque:YES];
    self.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces |
                             NSWindowCollectionBehaviorStationary |
                             NSWindowCollectionBehaviorIgnoresCycle);
    NSTrackingArea* foo=[[NSTrackingArea alloc] initWithRect:self.contentView.frame options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self.contentView addTrackingArea:foo];
    sI=self;
    return self;
}
-(BOOL)canBecomeKeyWindow{
    return NO;
}
-(BOOL)canBecomeMainWindow{
    return NO;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return YES;
}
-(void)mouseEntered:(NSEvent *)event{
    NSUInteger currentID=[[WKDesktopManager sharedInstance] currentSpaceID];
    WKDesktop* wk=[[WKDesktopManager sharedInstance] desktopForSpaceID:currentID];
    [wk.firstResponder mouseEntered:event];
}
-(void)mouseExited:(NSEvent *)event{
    NSUInteger currentID=[[WKDesktopManager sharedInstance] currentSpaceID];
    WKDesktop* wk=[[WKDesktopManager sharedInstance] desktopForSpaceID:currentID];
    [wk.firstResponder mouseExited:event];
}
-(void)refreshOSState{
    BOOL isVisible;
    if(self.occlusionState & NSWindowOcclusionStateVisible){
        isVisible=YES;
    }
    else{
        isVisible=NO;
    }
    NSDictionary* UserInfo=@{@"CurrentSpaceID":[NSNumber numberWithInteger:[[WKDesktopManager sharedInstance] currentSpaceID]],@"Visibility":[NSNumber numberWithBool:isVisible]};
    [[NSNotificationCenter defaultCenter] postNotificationName:OStateChangeNotificationName object:nil  userInfo:UserInfo];
}
- (void)windowDidChangeOcclusionState:(NSNotification *)notification{
    [self refreshOSState];
}
@end
