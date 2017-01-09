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
@implementation WKRenderManager{
    NSMutableArray<Class>* render;
}
+ (instancetype)sharedInstance{
    static WKRenderManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKRenderManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(void)refreshRender{
    unsigned int classCnt=0;
    Class* classes =objc_copyClassList(&classCnt);
    for( unsigned int i = 0; i < classCnt; ++i){
        Class class = classes[i];
        if([class conformsToProtocol:objc_getProtocol("WKRenderProtocal")]){
            [render addObject:class];
        }
    }
    
    free(classes);
}
@end
