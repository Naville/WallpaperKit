//
//  WCiTunesLyrics.h
//  WallpaperKit
//
//  Created by Naville Zhang on 19/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WKDesktop.h"
#import "iTunes.h"
#import "LyricManager.h"
#import "Lyric.h"
/**
For HTML Based Rendering. Following Strings in HTML will replaced at runtime
 
 - %LYRIC%
 - %SONGNAME%
 - %ARTISTNAME%
 - %ALBUMNAME%
 - %PRONOUNCE%
 - %TRANSLATED%
 */
@interface WKiTunesLyrics : NSView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Not Used
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@property (nonatomic,assign,readwrite) NSDictionary* arg;
@end
