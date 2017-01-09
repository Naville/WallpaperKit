//
//  WKWindow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWindow.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation WKWindow

+(instancetype)newFullScreenWindow{
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    id menubar = [NSMenu new];
    id appMenuItem = [NSMenuItem new];
    [menubar addItem:appMenuItem];
    [NSApp setMainMenu:menubar];
    id appMenu = [NSMenu new];
    [appMenuItem setSubmenu:appMenu];
    
    WKWindow* window = [[WKWindow alloc] initWithContentRect:CGDisplayBounds(CGMainDisplayID())
                                                styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor clearColor]];
    [window makeKeyAndOrderFront:nil];
    [window setLevel:kCGDesktopIconWindowLevel-1];
    window.ignoresMouseEvents=YES;
    window.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces |
                               NSWindowCollectionBehaviorStationary |
                               NSWindowCollectionBehaviorIgnoresCycle);
    window.hasShadow=NO;
    [NSApp activateIgnoringOtherApps:YES];
    return window;

}
-(BOOL)canBecomeKeyWindow{
    return false;
}
-(BOOL)canBecomeMainWindow{
    return false;
}
-(BOOL)canBeVisibleOnAllSpaces{
    return NO;
}
-(instancetype)init{
    self=[super init];
    return self;
}
@end
