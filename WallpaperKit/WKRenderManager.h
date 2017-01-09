//
//  WKRenderManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKRenderManager : NSObject

+(instancetype)sharedInstance;
-(NSDictionary*)randomRender;
@property (readwrite,retain,atomic) NSMutableArray<NSDictionary*>* renderList;
@end
