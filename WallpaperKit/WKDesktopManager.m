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
#import "WKOcclusionStateWindow.h"

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
    WKOcclusionStateWindow* DummyWindow;//Dummy Transparent Window at kCGDesktopIconWindowLevel+1 for OcclusionState Observe
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOSChange:) name:OSNotificationCenterName object:nil];
    self->DummyWindow=[WKOcclusionStateWindow new];
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
    WKDesktop* wk=[self desktopForSpaceID:currentSpaceID];
    if(wk==nil){
        wk=[self createDesktopWithSpaceID:currentSpaceID andRender:[[WKRenderManager sharedInstance] randomRender]];
    }

    [self DisplayDesktop:wk];
}
-(WKDesktop*)desktopForSpaceID:(NSUInteger)spaceID{
    if([self.windows.allKeys containsObject:[NSNumber numberWithInteger:spaceID]]){
        return [self.windows objectForKey:[NSNumber numberWithInteger:spaceID]];
    }
    else{
        return nil;
    }
}
-(void)DisplayDesktop:(WKDesktop*)wk{
    [wk orderFront:nil];
    [wk play];
    [self->DummyWindow orderFront:nil];
    //Keep Current Video Playing if next Window is not playing video,etc
    for(id key in self.windows.allKeys){
        WKDesktop* currentDesktop=[self.windows objectForKey:key];
        if([currentDesktop isEqualTo:wk]){//Ignore next space's WKDesktop
            continue;
        }
        if(currentDesktop.currentView.requiresConsistentAccess==YES && wk.currentView.requiresConsistentAccess==NO){
            //Old view needs consistent access while the new one doesn't. Leave it running
        }
        else{
            [currentDesktop pause];
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
    CFRelease(spaces);
    return WRONG_WINDOW_ID;

}
-(void)discardSpaceID:(NSUInteger)spaceID{
    if([self.windows.allKeys containsObject:[NSNumber numberWithInteger:spaceID]]){
        __weak WKDesktop* win=[self->_windows objectForKey:[NSNumber numberWithInteger:spaceID]];
        [win close];
        [self->_windows removeObjectForKey:[NSNumber numberWithInteger:spaceID]];
    }
    
}
-(void)handleOSChange:(NSNotification*)notification{
    BOOL isVisible=[[notification.userInfo objectForKey:@"Visibility"] boolValue];
    NSNumber* newSpaceID=[notification.userInfo objectForKey:@"CurrentSpaceID"];
    for(id key in self.windows.allKeys){
        if(isVisible==NO){
            [(WKDesktop*)[self.windows objectForKey:key] pause];
            continue;
        }
        if([key isEqualTo:newSpaceID]){
            [(WKDesktop*)[self.windows objectForKey:key] play];
        }
        else{
            [(WKDesktop*)[self.windows objectForKey:key] pause];
        }
    }
}
-(WKDesktop*)createDesktopWithSpaceID:(NSUInteger)SpaceID andRender:(NSDictionary*)render{
    [self discardSpaceID:SpaceID];
      WKDesktop*  wk=[[WKDesktop alloc] initWithContentRect:CGDisplayBounds(CGMainDisplayID()) styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
        if(render==nil|| ![render.allKeys containsObject:@"Render"]){
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Render Invalid" userInfo:render];
        }
        [wk renderWithEngine:[render objectForKey:@"Render"] withArguments:render];
        self.activeWallpaperView=wk.currentView;
        
        [self.windows setObject:wk forKey:[NSNumber numberWithInteger:SpaceID]];
    return wk;

    
    
}
@end
