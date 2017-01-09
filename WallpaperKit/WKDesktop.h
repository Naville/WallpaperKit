//
//  WallpaperKit.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKRenderProtocal.h"
#define StopNotification @"com.naville.wpkit.stop"
@interface WKDesktop : NSObject
/**
    @param args The Arguments To Pass To The Render. @"Path" shoule be NSURL of corresponding file
 **/
-(void)renderWithEngine:(nonnull Class)renderEngine withArguments:(nonnull NSDictionary*)args;
-(void)cleanup;
-(void)pause;
-(void)stop;
-(void)play;
@end
