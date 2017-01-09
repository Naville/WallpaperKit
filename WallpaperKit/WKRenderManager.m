//
//  WKRenderManager.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKRenderManager.h"
#import <objc/runtime.h>
#import "WKRenderProtocal.h"
@implementation WKRenderManager
+ (instancetype)sharedInstance{
    static WKRenderManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKRenderManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    self->_renderList=[NSMutableArray array];
    return self;
}
-(NSDictionary*)randomRender{
    return [_renderList objectAtIndex: arc4random()%[_renderList count]];
}
@end
