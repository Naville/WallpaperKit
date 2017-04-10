//
//  WKDraggableImage.h
//  WallpaperKit
//
//  Created by Naville Zhang on 25/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <WallpaperKit/WallpaperKit.h>

/**
 Default appears in top-most window level.
 Double click to bring it back to desktop
 Double click again to bring it to top-most again
 */
@interface WKDraggableImage : WKImagePlugin<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering. Available Keys:
 
 Path NSURL of target Image
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@end
