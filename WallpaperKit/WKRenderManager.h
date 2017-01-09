//
//  WKRenderManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRenderManager : NSObject
#define EmptyRenderListNotification @"com.naville.wallpaperkit.emptyrenderlist"
+(instancetype)sharedInstance;
/**
 Register EmptyRenderListNotification for Notification when the renderer list is empty
 @return NSDictionary* with @"Render" being the Render Engine. The whole dictionary is argument for the renderer
 */
-(NSDictionary*)randomRender;
/**
 An NSMutableArray of NSDictionary. Each NSDictionary has the same structure as described in randomRender's documentation
 */
@property (readwrite,retain,atomic) NSMutableArray<NSDictionary*>* renderList;
@end
