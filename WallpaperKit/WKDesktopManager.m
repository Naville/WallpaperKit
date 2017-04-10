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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOSChange:) name:OStateChangeNotificationName object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(handleWorkspaceChange:) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
    self->DummyWindow=[WKOcclusionStateWindow new];
    return self;
}
-(void)stop{
    for(NSNumber* key in self.windows.allKeys){
        [[self->_windows objectForKey:key] close];
    }
    
    [self.windows removeAllObjects];
    
    self->lastActiveSpaceID=INT_MAX;
}
-(WKDesktop*)desktopForSpaceID:(NSUInteger)spaceID{
    return [self.windows objectForKey:[NSNumber numberWithInteger:spaceID]];

}
-(void)DisplayDesktop:(WKDesktop*)wk{
    [wk orderFront:nil];
    [wk play];
    [self->DummyWindow orderFront:nil];
    //Keep Current Video Playing if next Window is not playing video,etc
    for(id key in self.windows.allKeys){
        WKDesktop* currentDesktop=[self->_windows objectForKey:key];
            if([currentDesktop isEqualTo:wk]){//Ignore next space's WKDesktop
                continue;
            }
            if(currentDesktop.mainView.requiresConsistentAccess==YES && wk.mainView.requiresConsistentAccess==NO){
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
        
            [[self.windows objectForKey:[NSNumber numberWithInteger:spaceID]] close];
            [self->_windows removeObjectForKey:[NSNumber numberWithInteger:spaceID]];
    }
    
}
-(void)handleWorkspaceChange:(NSNotification*)notification{
    //Do nothing when the system is in fullscreen
    if([NSApp currentSystemPresentationOptions]==NSApplicationPresentationFullScreen){
        return;
    }
    NSUInteger currentSpaceID=[self currentSpaceID];
    if(currentSpaceID==WRONG_WINDOW_ID){
        return;
    }
    lastActiveSpaceID=currentSpaceID;
    NSNumber* SID=[NSNumber numberWithUnsignedInteger:currentSpaceID];
    WKDesktop* wk=[self->_windows objectForKey:SID];
    if(wk!=nil){
        [self DisplayDesktop:wk];
    }
    
    
}
-(void)handleOSChange:(NSNotification*)notification{
    BOOL isVisible=[[notification.userInfo objectForKey:@"Visibility"] boolValue];
    NSNumber* newSpaceID=[notification.userInfo objectForKey:@"CurrentSpaceID"];
    for(id key in self.windows.allKeys){
        if(isVisible==NO){
                [[self.windows objectForKey:key] pause];
            continue;
        }
        if([key isEqualTo:newSpaceID]){
             [[self.windows objectForKey:key] play];
        }
        else{
            [[self.windows objectForKey:key] pause];
        }
    }
}
-(WKDesktop*)createDesktopWithSpaceID:(NSUInteger)SpaceID andRender:(NSDictionary*)render{
    WKDesktop*  wk=[[WKDesktop alloc] initWithContentRect:CGDisplayBounds(CGMainDisplayID()) styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    if(render==nil|| ![render.allKeys containsObject:@"Render"]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Render Invalid" userInfo:render];
    }
    [wk renderWithEngine:[render objectForKey:@"Render"] withArguments:render];
    [self->_windows setObject:wk forKey:[NSNumber numberWithInteger:SpaceID]];

    return wk;
}
@end
