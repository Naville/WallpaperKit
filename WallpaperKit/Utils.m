//
//  Utils.m
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(instancetype)sharedManager{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
-(instancetype)init{
    self=[super init];
    self.SongMatchRules=[NSMutableArray array];
    self.ViewRenderTemplates=[NSMutableDictionary dictionary];
    [_SongMatchRules addObject:@"%SONG% %ALBUM%"];
    [_SongMatchRules addObject:@"%SONG% %ARTIST%"];
    [_SongMatchRules addObject:@"%SONG% %ALBUMARTIST%"];
    [_SongMatchRules addObject:@"%SONG% "];
    NSURL* BasePath=[Utils BaseURL];
    NSURL* LyricsTemplatePath=[BasePath URLByAppendingPathComponent:@"Lyric.html"];
    NSURL* TranslatedTemplatePath=[BasePath URLByAppendingPathComponent:@"Translated.html"];
    NSURL* PronounceTemplatePath=[BasePath URLByAppendingPathComponent:@"Pronounce.html"];
    NSURL* TitleTemplatePath=[BasePath URLByAppendingPathComponent:@"Title.html"];
    for(NSURL* curPath in @[LyricsTemplatePath,TranslatedTemplatePath,PronounceTemplatePath,TitleTemplatePath]){
        NSString* Key=[curPath.lastPathComponent stringByReplacingOccurrencesOfString:@".html" withString:@""];
        NSError* err;
        NSString* dat=[NSString stringWithContentsOfURL:curPath encoding:NSUTF8StringEncoding error:&err];
        if(dat==nil || dat.length==0){
            NSURL* ResourcesURL=[[NSBundle mainBundle] URLForResource:Key withExtension:@".html"];
            dat=[NSString stringWithContentsOfURL:ResourcesURL encoding:NSUTF8StringEncoding error:&err];
        }
        [_ViewRenderTemplates setObject:dat forKey:Key];
    }
    
    return self;
}
-(NSMutableSet*)SongMatchQueriesFromInfo:(NSDictionary*)Info{
    NSMutableSet* retVal=[NSMutableSet set];
    for(NSString* Rule in _SongMatchRules){
        NSString* Query=[Rule copy];
        for (NSString* Key in @[@"Song",@"Album",@"Artist",@"AlbumArtist"]){
            NSString* PlaceHolder=[NSString stringWithFormat:@"%%%@%%",Key.uppercaseString];
            if([Info.allKeys containsObject:Key]){
                Query=[Query stringByReplacingOccurrencesOfString:PlaceHolder withString:[Info objectForKey:Key]];
            }
            else{
                Query=[Query stringByReplacingOccurrencesOfString:PlaceHolder withString:@""];
            }
            
        }
        [retVal addObject:Query];
    }
    
    return retVal;
}
+(NSURL*)BaseURL{
    NSURL* retVal= [[[NSFileManager defaultManager] URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask][0] URLByAppendingPathComponent:@"NCLyrics"];
    BOOL isFolder=NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:retVal.absoluteURL.absoluteString isDirectory:&isFolder]==NO || isFolder==NO){
        NSError* err;
        BOOL flag=[[NSFileManager defaultManager] createDirectoryAtPath:retVal.absoluteURL.absoluteString withIntermediateDirectories:YES attributes:nil error:&err];
        if(!flag){
            @throw [NSException exceptionWithName:NSGenericException reason:@"Create Base Failed" userInfo:@{@"Error":err.localizedDescription}];
        }
    }
    return retVal;
}

@end
