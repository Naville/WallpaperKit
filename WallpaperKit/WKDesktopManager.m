//
//  WKDesktopManager.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#include <unistd.h>
#include <CoreServices/CoreServices.h>
#include <ApplicationServices/ApplicationServices.h>
#import "WKDesktopManager.h"

/* Reverse engineered Space API; stolen from xmonad */
typedef void *CGSConnectionID;
extern CGSConnectionID _CGSDefaultConnection(void);
#define CGSDefaultConnection _CGSDefaultConnection()

typedef uint64_t CGSSpace;
typedef enum _CGSSpaceType {
    kCGSSpaceUser,
    kCGSSpaceFullscreen,
    kCGSSpaceSystem,
    kCGSSpaceUnknown
} CGSSpaceType;
typedef enum _CGSSpaceSelector {
    kCGSSpaceCurrent = 5,
    kCGSSpaceOther = 6,
    kCGSSpaceAll = 7
} CGSSpaceSelector;

extern CFArrayRef CGSCopySpaces(const CGSConnectionID cid, CGSSpaceSelector type);
extern CGSSpaceType CGSSpaceGetType(const CGSConnectionID cid, CGSSpace space);



@implementation WKDesktopManager{
    NSUInteger lastActiveSpaceID;
}
+ (instancetype)sharedInstance{
    static WKDesktopManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKDesktopManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    self.windows=[NSMutableDictionary dictionary];
    self->lastActiveSpaceID=INT_MAX;
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observe:) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
    return self;
}
-(void)stop{
    for(NSNumber* key in self.windows.allKeys){
        WKDesktop* currentDesktop=(WKDesktop*)[self.windows objectForKey:key];
        [currentDesktop close];
        currentDesktop=nil;
    }
    [self.windows removeAllObjects];

    self->lastActiveSpaceID=INT_MAX;
}
-(void)observe:(NSNotification*)notifi{
    //Do nothing when the system is in fullscreen
    if([NSApp currentSystemPresentationOptions]==NSApplicationPresentationFullScreen){
        return;
    }
    NSUInteger currentSpaceID=[self currentSpaceID];
    if(currentSpaceID==WRONG_WINDOW_ID){
        return;
    }
    lastActiveSpaceID=currentSpaceID;
    WKDesktop* wk=(WKDesktop*)[self.windows objectForKey:[NSNumber numberWithInteger:currentSpaceID]];//New Space's WKDesktop
    if(wk==nil){
        wk=[[WKDesktop alloc] initWithContentRect:[self.class calculatedRenderSize] styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
        NSDictionary* randomEngine=[[WKRenderManager sharedInstance] randomRender];
        if(randomEngine==nil){
            NSLog(@"No More Renders");
            return;
        }
        [wk renderWithEngine:[randomEngine objectForKey:@"Render"] withArguments:randomEngine];
        self.activeWallpaperView=wk.currentView;
        
        [self.windows setObject:wk forKey:[NSNumber numberWithInteger:currentSpaceID]];
    }
    [wk play];
    //Keep Current Video Playing if next Window is not playing video,etc
    for(NSString* key in self.windows.allKeys){
        WKDesktop* currentDesktop=[self.windows objectForKey:key];
        if([currentDesktop isEqualTo:wk]){//Ignore next space's WKDesktop
            continue;
        }
        if(currentDesktop.currentView.requiresConsistentAccess==YES && wk.currentView.requiresConsistentAccess==NO){
            //Old view needs consistent access while the new one doesn't. Leave it running
        }
    }

}
-(NSUInteger)currentSpaceID{
    CFArrayRef spaces = CGSCopySpaces(CGSDefaultConnection, kCGSSpaceCurrent);
    // CFArrayRef spaces = CGSCopySpaces(CGSDefaultConnection, kCGSSpaceAll);
    long count = CFArrayGetCount(spaces);
    
    long ii;
    for (ii = count - 1; ii >= 0; ii--) {
        CGSSpace spaceId = [(__bridge id)CFArrayGetValueAtIndex(spaces, ii) intValue];
        if (CGSSpaceGetType(CGSDefaultConnection, spaceId) == kCGSSpaceSystem)
            continue;
        CFRelease(spaces);
        return spaceId;
    }
    return WRONG_WINDOW_ID;

}
-(WKDesktop*)windowForCurrentWorkspace{
    WKDesktop* retVal=(WKDesktop*)[self.windows objectForKey:[NSNumber numberWithInteger:[self currentSpaceID]]];
    if(retVal==nil){
        [self observe:nil];//Force Create one
        retVal=(WKDesktop*)[self.windows objectForKey:[NSNumber numberWithInteger:[self currentSpaceID]]];

    }
    return retVal;
}
-(void)discardCurrentSpace{
    [[self->_windows objectForKey:[NSNumber numberWithInteger:[self currentSpaceID]]] close];
    [self->_windows removeObjectForKey:[NSNumber numberWithInteger:[self currentSpaceID]]];
    
}
+(CGRect)calculatedRenderSize{
    CGRect rawSize=[NSScreen mainScreen].visibleFrame;
    //rawSize.origin.y+=7;
    //rawSize.size.height*=0.97;
    return rawSize;
}
@end
