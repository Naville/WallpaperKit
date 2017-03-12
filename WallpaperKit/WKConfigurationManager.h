//
//  WKConfigurationManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/3/12.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"


typedef NS_ENUM(NSUInteger, WKConfigurationOption) {
    READWRITE,
    READONLY,
    WRITEONLY
};

/**
 Global Persistent Configuration Manager.
 */
@interface WKConfigurationManager : NSObject
+(instancetype)sharedInstance;
/**
 Global Persistent Configuration Manager.
 
 @param PluginName Render Plugin Name
 @param Config JSON-Compatible Object.Shared for one type of plugin.
 */
-(id)GetOrSetPersistentConfigurationForRender:(NSString*)PluginName Key:(NSString*)Key andConfiguration:(id)Config type:(WKConfigurationOption)type;
/**
 Serialize Current Configurations And Write To File

 @param Path Write Location
 @param op Operation To Perform
 */
-(void)Serialize:(NSURL*)Path Operation:(WKSerializeOption)op;
@end
