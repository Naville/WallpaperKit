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
-(void)renderWithEngine:(Class)renderEngine withArguments:(NSDictionary*)args;
-(void)cleanup;
@end
