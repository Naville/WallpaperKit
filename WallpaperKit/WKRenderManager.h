//
//  WKRenderManager.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WallpaperKit.h"

@interface WKRenderManager : NSObject
#define EmptyRenderListNotification @"com.naville.wallpaperkit.emptyrenderlist"
+(instancetype)sharedInstance;
/**
 Register EmptyRenderListNotification for Notification when the renderer list is empty
 @return NSDictionary* with @"Render" being the Render Engine. The whole dictionary is argument for the renderer.
 */
-(NSDictionary*)randomRender;
/**
 Build Render from existing Wallpaper Engine Workshop folder

 @param RootPath Path to workshop root.
 
    Looks like SteamLibrary/steamapps/workshop/content/431960/
 */
-(void)collectFromWallpaperEnginePath:(NSString*)RootPath;

/**
 Convert Renders from/to JSON-Compatible Format

 @param renderList Render List
 @param op Convert Type
 @return Converted NSArray
 */
+(NSArray*)CovertRenders:(NSMutableArray<NSDictionary*>*)renderList operation:(WKSerializeOption)op;



/**
 Add render from a NSDictionary

 @param arg Argument
 
    Note that arg can contains a key called @"LibraryPath". If exists,this path will be loaded using dlopen and [NSBundle load] before resolving other args. Useful for loading external plugins
 */
-(void)addRender:(NSDictionary*)arg;
/**
 An NSMutableArray of NSDictionary. Each NSDictionary has the same structure as described in randomRender's documentation.
 Note that this contains ready-to-use renders instead of JSON-Compatible ones
 */
@property (readwrite,retain,atomic) NSMutableArray<NSDictionary*>* renderList;
@end
