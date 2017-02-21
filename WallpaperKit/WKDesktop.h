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
 Call this instead of rdirectly interacting with render
 */
-(void)play;
@property (readwrite,retain,nonatomic,nonnull) NSView<WKRenderProtocal>* currentView;
/**
 NSError used by Render
 */
@property (readwrite,strong,nonatomic,nullable) NSError* err;
@end
NS_ASSUME_NONNULL_END
