//
//  MainViewController.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/10.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "MainViewController.h"
#import "WallpaperKit.h"
#import <objc/runtime.h>
#include <GLUT/glut.h>
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.window.delegate=self;
    NSApp.delegate=self;
    self.view.window.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces|NSWindowCollectionBehaviorParticipatesInCycle);
    [self CollectPref];
    //[[WKRenderManager sharedInstance].renderList addObject:@{@"Render":[WKWebpagePlugin class],@"Path":[NSURL URLWithString:@"https://www.youtube.com/watch?v=Ms5hhdRFRvc"]}];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observe) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
    [self observe];
    
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
    [self.view.window setTitle:@"No Render Loaded"];
}
- (IBAction)loadActiveSpace:(id)sender {
    [self observe];
}
-(void)observe{
    @try{
        NSWindow* window=[[WKDesktopManager sharedInstance]  windowForCurrentWorkspace];
        [self.view.window setTitle:[window description]];
    }
    @catch(NSException* exp){
        [self.view.window setTitle:exp.reason];
    }

}

-(void)CollectPref{
    @autoreleasepool {
        NSMutableDictionary* Pref=[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/WallpaperKit.plist",NSHomeDirectory()]];
        [WKRenderManager collectFromWallpaperEnginePath:Pref[@"WEWorkshopPath"]];
        [Pref removeObjectForKey:@"WEWorkshopPath"];
        for(NSString* Key in Pref){
            if(objc_getClass(Key.UTF8String)!=NULL){
                NSArray* List=Pref[Key];
                for(NSDictionary* Arg in  List){
                    NSMutableDictionary* RenderArg=[NSMutableDictionary dictionaryWithDictionary:Arg];
                    RenderArg[@"Render"]=objc_getClass(Key.UTF8String);
                    if([RenderArg.allKeys containsObject:@"Path"]){
                        RenderArg[@"Path"]=[NSURL fileURLWithPath:RenderArg[@"Path"]];
                    }
                    if([RenderArg.allKeys containsObject:@"ImagePath"]){
                        RenderArg[@"ImagePath"]=[NSURL fileURLWithPath:RenderArg[@"ImagePath"]];
                    }
                    if([RenderArg.allKeys containsObject:@"Images"]){
                        NSMutableArray* FixedArray=[NSMutableArray arrayWithCapacity:[(NSArray*)RenderArg[@"Images"] count]];
                        for (NSString* Path in RenderArg[@"Images"]){
                            [FixedArray addObject:[NSURL fileURLWithPath:Path]];
                        }
                        RenderArg[@"Images"]=FixedArray;
                    }
                    [[WKRenderManager sharedInstance].renderList addObject:RenderArg];
                }
            }
            else{
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid Preferences Key:%@",Key] userInfo:nil];
            }
        }
    }
}
@end
