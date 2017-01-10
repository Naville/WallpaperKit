//
//  AppDelegate.m
//  Application
//
//  Created by Naville Zhang on 2017/1/10.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "AppDelegate.h"
#import "WKDesktopManager.h"
#import "WKRenderManager.h"
#import "WKWebpagePlugin.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":[NSURL fileURLWithPath:@"/Users/Naville/Desktop/HTMLWallpaper/835186492/index.html"],@"Render":[WKWebpagePlugin class]}];
    [[WKDesktopManager sharedInstance] prepare];
    [[WKDesktopManager sharedInstance] start];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
