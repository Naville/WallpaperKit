//
//  WallpaperKit.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//
#import <AppKit/AppKit.h>
#import "WKRenderProtocal.h"
#import "WKUtils.h"
#import "WKConfigurationManager.h"
NS_ASSUME_NONNULL_BEGIN
@interface WKDesktop : NSWindow<NSWindowDelegate>
/**
 Render Current WKDesktop Object

 @param renderEngine Class for Rendering Current Object
 @param args Arguments For The Render
 */
-(void)renderWithEngine:(Class)renderEngine withArguments:(NSDictionary*)args;
-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag NS_DESIGNATED_INITIALIZER;
/**
 Pause wrapped render with internal state manipulation.
 Call this instead of directly interacting with render
 */
-(void)pause;
/**
 Play wrapped render with internal state manipulation.
 Call this instead of directly interacting with render
 */
-(void)play;

/**
 Add view to contentView. Call this instead of directly using contentView as this contains internal state manipulation. If this view is "mainRender",old main view will be discarded;

 @param view View To Add
 */
-(void)addView:(NSView*)view;
/**
 “Main” Render of current desktop. There can be at most one main Render for each Desktop
 */
@property (readwrite,retain,nonatomic) NSView<WKRenderProtocal>* mainView;
/**
 NSError used by Render
 */
@property (readwrite,retain,nonatomic) NSNumber* spaceID;
@property (readwrite,retain,nonatomic) NSMutableArray* WKViews;// Register WKRenderProtocal Views into this array for operations
@property (readwrite,strong,nonatomic,nullable) NSError* err;
@end
NS_ASSUME_NONNULL_END
