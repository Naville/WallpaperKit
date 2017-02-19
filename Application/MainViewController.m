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
@interface MainViewController (){
    WKDesktopManager* wkdm;
    WKRenderManager* wkrm;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.window.delegate=self;
    NSApp.delegate=self;
    self->wkdm=[WKDesktopManager sharedInstance];
    self->wkrm=[WKRenderManager sharedInstance];
    self.view.window.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces|NSWindowCollectionBehaviorParticipatesInCycle);
    self.RenderListView.dataSource=[WKRenderManager sharedInstance];
    self.RenderListView.delegate=self;
    
    [self CollectPref];
    [self->wkrm.renderList addObject:@{@"Render":[WKiTunesLyrics class]}];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observe) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
    [self observe];
    [self.RenderListView reloadData];
    
}
- (IBAction)discardExistingWindows:(id)sender {
    [[WKDesktopManager sharedInstance] stop];
    return;
}
- (IBAction)discardActiveSpace:(id)sender {
    [self->wkdm  discardSpaceID:[self->wkdm currentSpaceID]];
    [self.view.window setTitle:@"No Render Loaded"];
}
- (IBAction)loadActiveSpace:(id)sender {
    [self observe];
}
-(void)observe{
    @try{
        WKDesktop* window=[self->wkdm createDesktopWithSpaceID:[self->wkdm currentSpaceID] andRender:[self->wkrm randomRender]];
        [self.view.window setTitle:[window description]];
        [self->wkdm DisplayDesktop:window];
    }
    @catch(NSException* exp){
        [self.view.window setTitle:exp.reason];
    }

}
- (IBAction)chooseRenderForCurrentDesktop:(id)sender {
    NSUInteger index=[self.RenderListView selectedRow];
    [self->wkdm discardSpaceID:[self->wkdm currentSpaceID]];
    WKDesktop* wk=[self->wkdm createDesktopWithSpaceID:[self->wkdm currentSpaceID] andRender:[self->wkrm.renderList objectAtIndex:index]];
    [self->wkdm DisplayDesktop:wk];
    
    
}
- (CGFloat)tableView:(NSTableView *)tableView
              heightOfRow:(NSInteger)row {
    // Access the content of the cell.
    return tableView.rowHeight*4;

}

-(void)CollectPref{
    @autoreleasepool {
        NSMutableDictionary* Pref=[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/WallpaperKit/WallpaperKit.plist",NSHomeDirectory()]];
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
                   // [[WKRenderManager sharedInstance].renderList addObject:RenderArg];
                }
            }
            else{
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid Preferences Key:%@",Key] userInfo:nil];
            }
        }
    }
}
@end
