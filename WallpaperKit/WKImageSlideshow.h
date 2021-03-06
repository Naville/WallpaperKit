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
 
    @"Interval" unsigned int seconds to sleep between image changes. Default to 5
    @"Images" NSArray* of image path NSURL
    or @"ImagePath" NSURL* Path to Image Folder
    @"SortingKey" NSURLResourceKey's name as String, or @"Random". Its absence will disable sorting
    @"ImageScaling" ImageScaling Number. Default to NSImageScaleProportionallyUpOrDown
 
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@property (nonatomic) BOOL requiresExclusiveBackground;
@property (nonatomic,readwrite) NSArray<NSURL *> *ImageURLList;
@property (nonatomic,assign,readwrite) NSDictionary* arg;
@end
