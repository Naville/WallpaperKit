//
//  WKPluginProtocal.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <AppKit/AppKit.h>
#define TOJSON 1
#define FROMJSON 0
@class WKDesktop;

@protocol WKRenderProtocal

@required
@property (nonatomic) BOOL requiresConsistentAccess;
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
+(nullable NSDictionary*)convertArgument:( NSDictionary* _Nonnull )args Operation:(NSUInteger)op;
@end

