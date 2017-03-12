//
//  WKPluginProtocal.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <AppKit/AppKit.h>
typedef NS_ENUM(NSUInteger, WKSerializeOption) {
    TOJSON,
    FROMJSON
};

@class WKDesktop;

@protocol WKRenderProtocal

@required
/**
 Used to determine whether the render should be paused during Workspace changes
 */
@property (nonatomic) BOOL requiresConsistentAccess;
/**
 Marks the render as "main" render. There will be only one "main" render in each workspace
 */
@property (nonatomic) BOOL requiresExclusiveBackground;
- (_Nonnull instancetype)initWithWindow:( WKDesktop* _Nonnull )window andArguments:( NSDictionary* _Nonnull )args;
/**
 Pause Current View. Called when Current Workspace has changed
 */
- (void)pause;
/**
 Start Displaying Current View
 */
- (void)play;
/**
 Convert JSON-based argument to standard argument and vice versa.

 @param args Argument
 @param op Convert operation
 @return Converted NSDictionary
 */
+( NSMutableDictionary* _Nonnull )convertArgument:( NSDictionary* _Nonnull )args Operation:(WKSerializeOption)op;
@optional
-(void)stop;
@end

