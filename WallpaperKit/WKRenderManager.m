//
//  WKRenderManager.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKRenderManager.h"
#import <objc/runtime.h>
#import <dlfcn.h>
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
    return [self.renderList objectAtIndex: arc4random()%[_renderList count]];
}
+(NSArray*)CovertRenders:(NSMutableArray<NSDictionary*>*)renderList operation:(WKSerializeOption)op{
    @autoreleasepool {
        NSMutableArray* retArray=[NSMutableArray array];
        for (NSDictionary* dict in renderList){
            Class<WKRenderProtocal> cls;
            id render=dict[@"Render"];
            NSString* libPath=[dict objectForKey:@"LibraryPath"];//Load External Libraries if exists
            if(libPath!=nil && [libPath respondsToSelector:@selector(isEqualToString:)]){
                dlopen(libPath.UTF8String, RTLD_NOW|RTLD_GLOBAL);
                [[NSBundle bundleWithPath:libPath] load];
            }
            if ([render respondsToSelector:@selector(isEqualToString:)]){
                cls=NSClassFromString(render);
            }
            else{
                cls=render;
            }
            [retArray addObject:[cls convertArgument:dict Operation:op]];
        }
        return retArray;
    }
    
}
-(void)collectFromWallpaperEnginePath:(NSString*)RootPath{
    @autoreleasepool {
        NSError* err;
        for(NSURL* path in  [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:RootPath]
                                                          includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey]
                                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                               error:&err]){
            NSData* projectData=[NSData dataWithContentsOfURL:[path URLByAppendingPathComponent:@"project.json"]];
            if(projectData==nil){
                continue;
            }
            NSMutableDictionary* ProjectInfo=[NSJSONSerialization JSONObjectWithData:projectData options:NSJSONReadingMutableContainers error:nil];
            
            NSString* projectType=[(NSString*)[ProjectInfo objectForKey:@"type"] lowercaseString];
            
            NSURL* filePath=[path URLByAppendingPathComponent:[ProjectInfo objectForKey:@"file"]];
            [ProjectInfo setObject:filePath.path forKey:@"Path"];
                                
            if([projectType isEqualToString:@"video"]){
                NSDictionary* ConvertedProjectInfo=[[WKVideoPlugin class] convertArgument:ProjectInfo Operation:FROMJSON];
                [self.renderList addObject:ConvertedProjectInfo];
                
            }
            else if([projectType isEqualToString:@"web"]){
                NSMutableDictionary* ConvertedProjectInfo=[[WKWebpagePlugin class] convertArgument:ProjectInfo Operation:FROMJSON];
                [ConvertedProjectInfo setObject:path forKey:@"BaseURL"];
                [self.renderList addObject:ConvertedProjectInfo];
            }
            else{
                NSLog(@"WallpaperEngine Project Type:%@ Unsupported",[ProjectInfo objectForKey:@"type"]);
                
            }
            
            
        }
        if(err!=nil){
            NSLog(@"%@",err.localizedDescription);
        }
    }
    
}
-(void)addRender:(NSDictionary*)dict{
    @autoreleasepool {
        id render=dict[@"Render"];
        
        NSString* libPath=[dict objectForKey:@"LibraryPath"];//Load External Libraries if exists
        if(libPath!=nil && [libPath respondsToSelector:@selector(isEqualToString:)]){
            dlopen(libPath.UTF8String, RTLD_NOW|RTLD_GLOBAL);
            [[NSBundle bundleWithPath:libPath] load];
        }
        if ([render respondsToSelector:@selector(isEqualToString:)]){
            Class<WKRenderProtocal> cls=NSClassFromString(render);
            if(class_conformsToProtocol(cls,@protocol(WKRenderProtocal))){
                NSDictionary* foo=[cls convertArgument:dict Operation:FROMJSON];
                [self.renderList addObject:foo];
            }
            else{
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid WKRenderProtocal class",render] userInfo:nil];
            }
        }
        else{
            
            [self.renderList addObject:dict];
            
        }
        
        
        
    }
}

@end
