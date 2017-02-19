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
            if([Key isEqualToString:@"Lyric"]){
                dat=[[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"PCFET0NUWVBFIGh0bWw+DQo8aHRtbCBsYW5nPSJlbiI+DQoJPGhlYWQ+DQoJCTxtZXRhIGNoYXJzZXQ9IlVURi04IiAvPg0KCTwvaGVhZD4NCgk8Ym9keT4NCiAgICA8cCBzdHlsZT0iY29sb3I6cmVkIj4lTFlSSUMlPC9wPg0KCTwvYm9keT4NCjwvaHRtbD4NCg==" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
            }
            else if([Key isEqualToString:@"Title"]){
                dat=[[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"PCFET0NUWVBFIGh0bWw+DQo8aHRtbCBsYW5nPSJlbiIgY2xhc3M9Im5vLWpzIj4NCgk8aGVhZD4NCgkJPG1ldGEgY2hhcnNldD0iVVRGLTgiIC8+DQogICAgPHN0eWxlPg0KICAgICAgICAjQ29udGV4dCB7DQogICAgICAgICAgICBjb2xvcjogYmx1ZTsNCiAgICAgICAgfQ0KICAgIDwvc3R5bGU+DQoJPC9oZWFkPg0KCTxib2R5Pg0KICA8ZGl2IGlkPSJDb250ZXh0Ij4NCiAgICA8cCBzdHlsZT0iY29sb3I6cmVkIj48c3Ryb25nPiVTT05HTkFNRSU8L3N0cm9uZz48L3A+DQogICAgPHAgc3R5bGU9ImNvbG9yOnJlZCI+PHN0cm9uZz4lQVJUSVNUTkFNRSU8L3N0cm9uZz48L3A+DQogICAgPHAgc3R5bGU9ImNvbG9yOnJlZCI+PHN0cm9uZz4lQUxCVU1OQU1FJTwvc3Ryb25nPjwvcD4NCiAgPC9kaXY+DQoNCgk8L2JvZHk+DQo8L2h0bWw+DQo=" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
            }
            else if([Key isEqualToString:@"Pronounce"]){
                dat=[[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"PCFET0NUWVBFIGh0bWw+DQo8aHRtbCBsYW5nPSJlbiIgY2xhc3M9Im5vLWpzIj4NCgk8aGVhZD4NCgkJPG1ldGEgY2hhcnNldD0iVVRGLTgiIC8+DQogICAgPHN0eWxlPg0KICAgICAgICAjQ29udGV4dCB7DQogICAgICAgICAgICBjb2xvcjogYmx1ZTsNCiAgICAgICAgfQ0KICAgIDwvc3R5bGU+DQoJPC9oZWFkPg0KCTxib2R5Pg0KICA8ZGl2IGlkPSJDb250ZXh0Ij4NCiAgICA8c3Ryb25nPiVQUk9OT1VOQ0UlPC9zdHJvbmc+DQogIDwvZGl2Pg0KDQoJPC9ib2R5Pg0KPC9odG1sPg0K" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
                    
            }
            else if([Key isEqualToString:@"Translated"]){
                dat=[[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:@"PCFET0NUWVBFIGh0bWw+DQo8aHRtbCBsYW5nPSJlbiIgY2xhc3M9Im5vLWpzIj4NCgk8aGVhZD4NCgkJPG1ldGEgY2hhcnNldD0iVVRGLTgiIC8+DQogICAgPHN0eWxlPg0KICAgICAgICAjQ29udGV4dCB7DQogICAgICAgICAgICBjb2xvcjogYmx1ZTsNCiAgICAgICAgfQ0KICAgIDwvc3R5bGU+DQoJPC9oZWFkPg0KCTxib2R5Pg0KICA8ZGl2IGlkPSJDb250ZXh0Ij4NCiAgICA8c3Ryb25nPiVUUkFOU0xBVEVEJTwvc3Ryb25nPg0KICA8L2Rpdj4NCg0KCTwvYm9keT4NCjwvaHRtbD4NCg==" options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
                
            }
            [dat writeToURL:curPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
    NSURL* retVal= [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"WallpaperKit"] isDirectory:YES];
    BOOL isFolder=NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:retVal.absoluteURL.absoluteString isDirectory:&isFolder]==NO || isFolder==NO){
        NSError* err;
        BOOL flag=[[NSFileManager defaultManager] createDirectoryAtPath:retVal.absoluteURL.absoluteString withIntermediateDirectories:YES attributes:nil error:&err];
        if(!flag || err!=nil){
            @throw [NSException exceptionWithName:NSGenericException reason:@"Create Base Failed" userInfo:@{@"Error":err.localizedDescription}];
        }
    }
    return retVal;
}

@end
