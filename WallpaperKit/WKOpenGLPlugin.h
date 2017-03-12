//
//  WKOpenGLPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
@interface WKOpenGLPlugin : NSOpenGLView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering. Available Keys:
 
 @"OpenGLDrawingBlock" A Block with current WKOpenGLPlugin* being the only argument; Draw in it
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@end
