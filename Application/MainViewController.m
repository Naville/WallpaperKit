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
#import <AVFoundation/AVFoundation.h>
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
    self.RenderListView.dataSource=self;
    self.RenderListView.delegate=self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self CollectPref];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->wkrm.renderList addObject:@{@"Render":[WKiTunesLyrics class]}];
            [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(observe) name:NSWorkspaceActiveSpaceDidChangeNotification object:nil];
            [self observe];
            [self.RenderListView reloadData];
        });
    });
    
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
    NSString* value=[tableView.dataSource tableView:tableView objectValueForTableColumn:nil row:row];
    return ([value componentsSeparatedByString:@"\n"].count+1)*tableView.rowHeight;
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
                    NSMutableDictionary* RenderArg=[NSClassFromString(Key) convertArgument:Arg Operation:FROMJSON];
                    [[WKRenderManager sharedInstance].renderList addObject:RenderArg];
                }
            }
            else{
                @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"Invalid Preferences Key:%@",Key] userInfo:nil];
            }
        }
    }
}
//NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self->wkrm.renderList.count;
}
- (NSString*)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSDictionary* arg=[self->wkrm.renderList objectAtIndex:row];
    Class cls=[arg objectForKey:@"Render"];
    NSDictionary* convertedJSON= [cls convertArgument:arg Operation:TOJSON];
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:convertedJSON options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(nullable id)object forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    Class cls=NSClassFromString([dict objectForKey:@"Render"]);
    NSDictionary* convertedJSON= [cls convertArgument:dict Operation:FROMJSON];
    [self->wkrm.renderList setObject:convertedJSON atIndexedSubscript:row];
}
@end
