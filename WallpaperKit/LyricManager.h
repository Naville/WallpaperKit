//
//  LyricManager.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/29.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
/**
 LyricManager
 
 All Info follows the same protocal:
    A NSDictionary Containing Following Fields:
        
- Album
- AlbumArtist Only used for Lyrics Searching. Discarded Afterwards
- Song
- Artist
 
 Furthermore, for Info regarding saving/loading of LRCs, these extra fields exists if possible:
 
- Lyric Raw Lyrics
- Translated Translated Lyrics
- Pronounce Pronounce of The Song
 
 */
@interface LyricManager : NSObject{
    sqlite3* db;
}
+(instancetype)sharedManager;
-(void)importLyric:(NSDictionary*)lrc;
/**
 Lyrics From SongInfo

SongInfo will be trimmed internally
 @param SongInfo SongInformation
 @return Info with lyrics
 */
-(NSDictionary*)exportLyric:(NSDictionary*)SongInfo;
-(void)importQMLELyric:(NSString*)Path;//Import from QQMusicLRCExporter Folder
/**
 Add Lyrics Search Engines

 @param cls A Class That Conforms To The AbstractLyricSearchEngine Protocal
 */
+(void)addSearchEngine:(Class)cls;
-(NSArray *)querySQLTableName:(NSString *)tableName
                  ColumnNames:(NSArray *)colunmNames
                        Error:(NSError **)error query:(NSString*)querySQL;
@end
