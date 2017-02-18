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
#import "WKVideoPlugin.h"
#import "WKWebpagePlugin.h"
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
    self.renderList=[NSMutableArray array];
    return self;
}
-(NSDictionary*)randomRender{
    if([_renderList count]==0){//This is the last renderer
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"No Available Render" userInfo:nil];
    }
    NSDictionary* renderer=[self.renderList objectAtIndex: arc4random()%[_renderList count]];
    return renderer;
}
+(void)collectFromWallpaperEnginePath:(NSString*)RootPath{
    for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:RootPath]
                                                      includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                           error:nil]){
        NSData* projectData=[NSData dataWithContentsOfURL:[path URLByAppendingPathComponent:@"project.json"]];
        if(projectData==nil){
            continue;
        }
        NSMutableDictionary* ProjectInfo=[NSJSONSerialization JSONObjectWithData:projectData options:NSJSONReadingMutableContainers error:nil];
        
        NSString* projectType=[(NSString*)[ProjectInfo objectForKey:@"type"] lowercaseString];
        if([projectType isEqualToString:@"video"]){
            NSString* FileName=[ProjectInfo objectForKey:@"file"];
            NSURL* actualPath=[path URLByAppendingPathComponent:FileName];
            [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":actualPath,@"Render":[WKVideoPlugin class]}];
        }
        else if([projectType isEqualToString:@"web"]){
            NSString* FileName=[ProjectInfo objectForKey:@"file"];
            NSURL* actualPath=[path URLByAppendingPathComponent:FileName];
            [[WKRenderManager sharedInstance].renderList addObject:@{@"Path":actualPath,@"Render":[WKWebpagePlugin class]}];
        }
        else{
            NSLog(@"WallpaperEngine Project Type:%@ Unsupported",[ProjectInfo objectForKey:@"type"]);
        }
        projectData=nil;
        ProjectInfo=nil;
        
    
    }
    
}
@end
