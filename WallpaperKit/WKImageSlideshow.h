//
//  WKImageSlideshow.h
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//
#import "WKDesktop.h"

@interface WKImageSlideshow : NSImageView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Arguments For Rendering:
 
    @"Interval" unsigned int seconds to sleep between image changes
    @"Images" NSArray* of image path NSURL
    or @"ImagePath" NSURL* Path to Image Folder
 
 @return UIView for Caller to deal with
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@end
