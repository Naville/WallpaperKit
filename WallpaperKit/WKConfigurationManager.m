//
//  WKConfigurationManager.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/3/12.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKConfigurationManager.h"

@implementation WKConfigurationManager{
    NSMutableDictionary* PersistentConfigDictionary;
}
+ (instancetype)sharedInstance{
    static WKConfigurationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKConfigurationManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    self->PersistentConfigDictionary=[NSMutableDictionary dictionary];
    return self;
}
-(id)GetOrSetPersistentConfigurationForRender:(NSString*)PluginName Key:(NSString*)Key andConfiguration:(id)Config type:(WKConfigurationOption)type{
    if(self->PersistentConfigDictionary[PluginName]==nil){
        self->PersistentConfigDictionary[PluginName]=[NSMutableDictionary dictionary];
    }
    if(type==READONLY){
        return self->PersistentConfigDictionary[PluginName][Key];
    }
    else if(type==WRITEONLY){
        if(Config!=nil){
            self->PersistentConfigDictionary[PluginName][Key]=Config;
        }
    }
    else if(type==READWRITE){
        if(self->PersistentConfigDictionary[PluginName][Key]==nil){
            if(Config!=nil){
                self->PersistentConfigDictionary[PluginName][Key]=Config;
            }
        }
        return self->PersistentConfigDictionary[PluginName][Key];
    }
    return nil;
}
-(void)Serialize:(NSURL *)Path Operation:(WKSerializeOption)op{
    if(op==TOJSON){
        [[NSJSONSerialization dataWithJSONObject:self->PersistentConfigDictionary options:NSJSONWritingPrettyPrinted error:nil] writeToURL:Path atomically:YES];
    }else{
        NSData* JSONData=[NSData dataWithContentsOfURL:Path];
        if(JSONData!=nil){
            self->PersistentConfigDictionary=[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        }
    }
}
@end
