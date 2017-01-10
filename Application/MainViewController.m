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
    // Insert code here to initialize your application
    
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/ActiveWallpapers",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":path,@"Render":[WKImagePlugin class]}];
    }
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Desktop/BackGroundVideos",NSHomeDirectory()]]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":path,@"Render":[WKVideoPlugin class]}];
    }
    [[WKDesktopManager sharedInstance] prepare];
    [[WKDesktopManager sharedInstance] start];
}
- (IBAction)discardExistingWindows:(id)sender {
    [[WKDesktopManager sharedInstance] stop];
    [[WKDesktopManager sharedInstance] start];
    return;
}

@end
