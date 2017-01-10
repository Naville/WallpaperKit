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
    [self.view.window setOpaque:NO];
    [self.view.window setBackgroundColor:[NSColor clearColor]];
    [self.view.window setLevel:kCGUtilityWindowLevelKey];
    [self.view.window setStyleMask:NSWindowStyleMaskBorderless];
    [self.view.window setAcceptsMouseMovedEvents:YES];
    [self.view.window setMovableByWindowBackground:NO];
    self.view.window.collectionBehavior=(NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorParticipatesInCycle);
    self.view.window.hasShadow=NO;
    // Insert code here to initialize your application
    
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/ActiveWallpapers",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
       // [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":path,@"Render":[WKImagePlugin class]}];
    }
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/BackGroundVideos",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
       // [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":path,@"Render":[WKVideoPlugin class]}];
    }
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/HTMLWallpaper",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        
        
        [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":[path URLByAppendingPathComponent:@"index.html"],@"Render":[WKWebpagePlugin class]}];
    }
    [[WKDesktopManager sharedInstance] prepare];
    [[WKDesktopManager sharedInstance] start];
}
- (IBAction)discardExistingWindows:(id)sender {
    [[WKDesktopManager sharedInstance] stop];
    [[WKDesktopManager sharedInstance] start];
    return;
}
/*- (void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"No shit sherlock");
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];

    WKDesktop* currentWallpaper=[[WKDesktopManager sharedInstance] windowForCurrentWorkspace];
    [currentWallpaper play];
}*/
-(void)mouseMoved:(NSEvent *)event{
    [super mouseMoved:event];
    NSLog(@"mouseMoved:%@",event);
}

@end
