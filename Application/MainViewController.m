//
//  MainViewController.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/10.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "MainViewController.h"
#import "WKDesktopManager.h"
#import "WKDesktopManager.h"
#import "WKRenderManager.h"
#import "WKWebpagePlugin.h"
#import "WKImagePlugin.h"
#import "WKVideoPlugin.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.window.delegate=self;
    NSApp.delegate=self;
    self.view.window.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces|NSWindowCollectionBehaviorParticipatesInCycle);
    // Insert code here to initialize your application
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/BackGroundVideos",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":path,@"Render":[WKVideoPlugin class]}];
    }
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/HTMLWallpaper",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        
        
        [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":[path URLByAppendingPathComponent:@"index.html"],@"Render":[WKWebpagePlugin class]}];
    }
    
    [WKRenderManager collectFromWallpaperEnginePath:@"/Volumes/Maets/SteamLibrary/steamapps/workshop/content/431960/"];
    [[WKDesktopManager sharedInstance] prepare];
    [[WKDesktopManager sharedInstance] start];
}
- (IBAction)discardExistingWindows:(id)sender {
    [[WKDesktopManager sharedInstance] stop];
    return;
}
/*- (void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"No shit sherlock");
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];

    WKDesktop* currentWallpaper=[[WKDesktopManager sharedInstance] windowForCurrentWorkspace];
    [currentWallpaper play];
}*/
- (IBAction)discardActiveSpace:(id)sender {
    [[WKDesktopManager sharedInstance]  discardCurrentSpace];
}

@end
