//
//  WKImagePlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
@interface WKImagePlugin : NSImageView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering. Available Keys:
 
Path NSURL of target Image
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@property (nonatomic,assign,readwrite) NSDictionary* arg;
@end
