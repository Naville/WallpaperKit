//
//  WKDesktopManager.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktopManager.h"
#import "WKDesktop.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation WKDesktopManager{
    NSMutableDictionary* windows;
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
    windows=[NSMutableDictionary dictionary];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observe:) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
    

    return self;
}
-(void)observe:(NSNotification*)notifi{
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:@"com.apple.spaces"];
    [[NSUserDefaults standardUserDefaults] addSuiteNamed:@"com.apple.spaces"];
    NSDictionary* currentSpaceInfo=[[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"SpacesDisplayConfiguration"] objectForKey:@"Management Data"] objectForKey:@"Monitors"] objectAtIndex:0] objectForKey:@"Current Space"];
    NSString* currentSpaceUUID=[currentSpaceInfo objectForKey:@"uuid"];
    if([windows objectForKey:currentSpaceUUID]==nil){
        WKDesktop* wk=[WKDesktop new];
    }
    else{
        [(WKDesktop*)[windows objectForKey:currentSpaceUUID] play];
    }

}
@end
