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
    NSApp.delegate=self;
    self->wkdm=[WKDesktopManager sharedInstance];
    self->wkrm=[WKRenderManager sharedInstance];
    self.view.window.collectionBehavior=(NSWindowCollectionBehaviorCanJoinAllSpaces |
                                         NSWindowCollectionBehaviorStationary |
                                         NSWindowCollectionBehaviorIgnoresCycle);
    self.RenderListView.dataSource=self;
    self.RenderListView.delegate=self;
    [self.view.window setLevel:NSStatusWindowLevel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.RenderListView reloadData];
    });
    [[WKConfigurationManager sharedInstance] Serialize:[[WKUtils BaseURL] URLByAppendingPathComponent:@"Config.json"] Operation:FROMJSON];
    [self LoadCurrentRender:nil];
}
- (IBAction)discardExistingWindows:(id)sender {
    [[WKDesktopManager sharedInstance] stop];
    [self.view.window setTitle:@"No Render Loaded"];
    return;
}
- (IBAction)discardActiveSpace:(id)sender {
    [self->wkdm  discardSpaceID:[self->wkdm currentSpaceID]];
    [self.view.window setTitle:@"No Render Loaded"];
}
- (IBAction)loadActiveSpace:(id)sender {
    WKDesktop* render=[self->wkdm createDesktopWithSpaceID:[self->wkdm currentSpaceID] andRender:[self->wkrm randomRender]];
    [self->wkdm DisplayDesktop:render];
    [self.view.window setTitle:[render description]];
}
- (IBAction)chooseRenderForCurrentDesktop:(id)sender {
    NSUInteger index=[self.RenderListView selectedRow];
    id Render=[self->wkrm.renderList objectAtIndex:index];
    
    WKDesktop* wk=[self->wkdm desktopForSpaceID:[self->wkdm currentSpaceID]];
    if(wk==nil){
        wk=[self->wkdm createDesktopWithSpaceID:[self->wkdm currentSpaceID] andRender:[self->wkrm.renderList objectAtIndex:index]];
    }
    else{
        [wk renderWithEngine:[Render objectForKey:@"Render"] withArguments:Render];
    }
    [self->wkdm DisplayDesktop:wk];
    [self.view.window setTitle:[wk description]];
    [[WKConfigurationManager sharedInstance] Serialize:[[WKUtils BaseURL] URLByAppendingPathComponent:@"Config.json"] Operation:TOJSON];
    
    
}
- (CGFloat)tableView:(NSTableView *)tableView
              heightOfRow:(NSInteger)row {
    // Access the content of the cell.
    NSString* value=[tableView.dataSource tableView:tableView objectValueForTableColumn:nil row:row];
    return ([value componentsSeparatedByString:@"\n"].count+1)*tableView.rowHeight;
}
- (IBAction)LoadCurrentRender:(id)sender {
    NSString* SavePath=[NSString stringWithFormat:@"%@/WallpaperKit/WallpaperKit.json",NSHomeDirectory()];
    NSError* err;
    NSMutableArray* JSONCompatibleArray=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:SavePath] options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&err];
    if(JSONCompatibleArray!=nil && err==nil){
        for(NSDictionary* dic in JSONCompatibleArray){
            [self->wkrm addRender:dic];
            [self->_RenderListView reloadData];
        }
    }
    else{
        [self.view.window setTitle:err.localizedDescription];
    }
    
    
}

- (IBAction)SaveCurrentRender:(id)sender {
    
    NSString* SavePath=[NSString stringWithFormat:@"%@/WallpaperKit/WallpaperKit.json",NSHomeDirectory()];
    
    NSArray* converted=[WKRenderManager CovertRenders:self->wkrm.renderList operation:TOJSON];
    NSError* err;
    NSData* convertedData=[NSJSONSerialization dataWithJSONObject:converted options:NSJSONWritingPrettyPrinted error:&err];
    if(err!=nil){
        [self.view.window setTitle:err.localizedDescription];
    }
    else{
        [convertedData writeToFile:SavePath atomically:YES];
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
    return [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:convertedJSON options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] stringByRemovingPercentEncoding];
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(nullable id)object forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    Class cls=NSClassFromString([dict objectForKey:@"Render"]);
    NSDictionary* convertedJSON= [cls convertArgument:dict Operation:FROMJSON];
    [self->wkrm.renderList setObject:convertedJSON atIndexedSubscript:row];
}

@end
