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
        CGPoint center=NSMakePoint((rawSize.origin.x+rawSize.size.width)/2, (rawSize.origin.y+rawSize.size.height)/2);
        CGFloat diagonalLength=400;
        sI = [[WKOcclusionStateWindow alloc] initWithContentRect:NSMakeRect(center.x-diagonalLength,center.y-diagonalLength,2*diagonalLength,2*diagonalLength) styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:YES];
    });
    return sI;
}
-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if(sI!=nil){
        return sI;
    }
    self=[super initWithContentRect:contentRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:YES];
    [self setIgnoresMouseEvents:YES];
    self.delegate=self;
    [self setLevel:kCGDesktopIconWindowLevel];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setOpaque:YES];
    self.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces |
                             NSWindowCollectionBehaviorStationary |
                             NSWindowCollectionBehaviorIgnoresCycle);
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
- (void)windowDidChangeOcclusionState:(NSNotification *)notification{
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
@end
