//
//  MainViewController.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/10.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController<NSWindowDelegate,NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *RenderListView;
@property (weak) IBOutlet NSButton *loadactiveworkspace;
@end
