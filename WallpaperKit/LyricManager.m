//
//  LyricManager.m
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/29.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import "LyricManager.h"
#import "AbstractLyricSearchEngine.h"
#import "WKUtils.h"
static NSMutableArray<Class>* LyricSearchEngine=nil;
@implementation LyricManager{
    NSLock* lock;
}
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
    sqlite3_open([[WKUtils BaseURL] URLByAppendingPathComponent:@"naville.lyricskit.db"].absoluteString.UTF8String,&self->db);
   
    sqlite3_exec(self->db, "CREATE TABLE IF NOT EXISTS LYRICS(ARTIST STRING ,SONG STRING,LYRIC STRING,TRANSLATED STRING,PRONOUNCE STRING)", NULL, NULL, NULL);
    sqlite3_exec(self->db, "END TRANSACTION;", NULL, NULL, NULL);
    return self;
}
-(void)importLyric:(NSDictionary*)lrc{
    //TODO:Extract Exising Values for the song if possible.So components from various sources can be added together
    NSString* InsertSQLCommand=[NSString stringWithFormat:@"INSERT OR IGNORE INTO LYRICS(ARTIST,SONG,LYRIC,TRANSLATED,PRONOUNCE) \
                          VALUES(%@,%@,%@,%@,%@)",
                          ([lrc objectForKey:@"Artist"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Artist"]],
                          ([lrc objectForKey:@"Song"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Song"]],
                          ([lrc objectForKey:@"Lyric"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Lyric"]],
                          ([lrc objectForKey:@"Translated"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Translated"]],
                          ([lrc objectForKey:@"Pronounce"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Pronounce"]]
                        ];
    NSString* queryString=[NSString stringWithFormat:@"SELECT * FROM LYRICS WHERE ARTIST=\'%@\' AND SONG=\'%@\'",[lrc objectForKey:@"Artist"],
                           [lrc objectForKey:@"Song"]];
    NSError* err;
    NSArray* results=[self querySQLTableName:@"LYRICS" ColumnNames:@[@"ARTIST",@"SONG",@"LYRIC",@"TRANSLATED",@"PRONOUNCE"] Error:&err query:queryString];
    if(results.count>0){

    NSString* updateCommand=[NSString stringWithFormat:@"UPDATE LYRICS SET LYRIC=%@ where LYRIC IS NULL AND ARTIST=%@ AND SONG=%@",
                             ([lrc objectForKey:@"Lyric"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Lyric"]],
                             ([lrc objectForKey:@"Artist"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Artist"]],
                             ([lrc objectForKey:@"Song"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Song"]]
                             ];
    sqlite3_exec(self->db, updateCommand.UTF8String, NULL, NULL,NULL);
    updateCommand=[NSString stringWithFormat:@"UPDATE LYRICS SET TRANSLATED=%@ where TRANSLATED IS NULL AND ARTIST=%@ AND SONG=%@",
                                 ([lrc objectForKey:@"Translated"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Translated"]],
                                 ([lrc objectForKey:@"Artist"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Artist"]],
                                 ([lrc objectForKey:@"Song"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Song"]]
                                 ];
    sqlite3_exec(self->db, updateCommand.UTF8String, NULL, NULL,NULL);
    updateCommand=[NSString stringWithFormat:@"UPDATE LYRICS SET PRONOUNCE=%@ where PRONOUNCE IS NULL AND ARTIST=%@ AND SONG=%@",
                       ([lrc objectForKey:@"Pronounce"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Pronounce"]],
                       ([lrc objectForKey:@"Artist"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Artist"]],
                       ([lrc objectForKey:@"Song"]==nil)?@"NULL":[NSString stringWithFormat:@"\"%@\"",[lrc objectForKey:@"Song"]]
                       ];
        sqlite3_exec(self->db, updateCommand.UTF8String, NULL, NULL,NULL);

    }
    else{
        //No Existing Value. Insert Directly
        sqlite3_exec(self->db, InsertSQLCommand.UTF8String, NULL, NULL,NULL);
    }
    
    sqlite3_exec(self->db, "END TRANSACTION;", NULL, NULL, NULL);
}
//Import from QQMusicLRCExporter Folder
-(void)importQMLELyric:(NSString*)Path{
    NSFileManager* fm=[NSFileManager defaultManager];//For Code Readability's sake
    NSMutableArray* LRCList=[[fm contentsOfDirectoryAtPath:Path error:nil] mutableCopy];
    for(NSInteger i = LRCList.count - 1; i >= 0; i--){
        NSMutableDictionary* currentLyricsInfo=[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",Path,[LRCList objectAtIndex:i]]];
        
        [self importLyric:currentLyricsInfo];
        
    }
    
}
-(NSDictionary*)exportLyric:(NSDictionary*)lrc{
    NSString* queryString=[NSString stringWithFormat:@"SELECT * FROM LYRICS WHERE ARTIST=\'%@\' AND SONG=\'%@\'",[lrc objectForKey:@"Artist"],
                           [lrc objectForKey:@"Song"]];
    NSError* err;
    NSMutableArray* results=[[self querySQLTableName:@"LYRICS" ColumnNames:@[@"ARTIST",@"SONG",@"LYRIC",@"TRANSLATED",@"PRONOUNCE"] Error:&err query:queryString] mutableCopy];
    if(err!=nil){
        NSLog(@"ExportLyricError:%@",err.localizedDescription);
    }
    if(results.count>0){
        NSDictionary* rawValue=results[0];
        return @{@"Artist":rawValue[@"ARTIST"],
                 @"Song":rawValue[@"SONG"],
                 @"Lyric":rawValue[@"LYRIC"],
                 @"Translated":rawValue[@"TRANSLATED"],
                 @"Pronounce":rawValue[@"PRONOUNCE"],
                     
                     
                     };
    }
    else{
        for(Class cls in LyricSearchEngine){
            if(![cls conformsToProtocol:@protocol(AbstractLyricSearchEngine)]){
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid AbstractLyricSearchEngine class",NSStringFromClass(cls)] userInfo:nil];
            }
            NSDictionary* Lyric=[[cls new] searchLyricForSongInfo:lrc];
            if(Lyric!=nil){
                NSMutableDictionary* importDictionary=[NSMutableDictionary dictionary];
                [importDictionary addEntriesFromDictionary:lrc];
                [importDictionary addEntriesFromDictionary:Lyric];
                [self importLyric:importDictionary];
                return Lyric;
            }
        }
        return nil;
    }

}
-(NSArray *)querySQLTableName:(NSString *)tableName
          ColumnNames:(NSArray *)colunmNames
                        Error:(NSError **)error query:(NSString*)querySQL
{
    NSMutableArray * result = [NSMutableArray new];
    sqlite3_stmt *statementsql;
    
    //NSString * querySQL = @"SELECT ";
    NSInteger countOfQuery = colunmNames.count;
    /*for (NSInteger i = 0;  i < countOfQuery - 1; i++) {
        querySQL = [querySQL stringByAppendingFormat:@"%@, ",colunmNames[i]];
    }
    querySQL = [querySQL stringByAppendingFormat:@"%@ FROM %@;",colunmNames[countOfQuery - 1], tableName];*/
    
    if (sqlite3_prepare_v2(db, querySQL.UTF8String, -1, &statementsql, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statementsql) == SQLITE_ROW) {
            NSMutableDictionary * dict = [NSMutableDictionary new];
            for (int i = 0; i < countOfQuery; i++) {
                const unsigned char * text = sqlite3_column_text(statementsql, i);
                if (text) {
                    NSString * content = [[NSString alloc] initWithCString:(const  char *)text encoding:NSUTF8StringEncoding];
                    [dict setValue:content forKey:[colunmNames objectAtIndex:i]];
                }else{
                    [dict setValue:@"" forKey:[colunmNames objectAtIndex:i]];
                }
            }
            [result addObject:dict];
        }
        sqlite3_finalize(statementsql);
    }
    else
    {
        int errorCode = sqlite3_errcode(db);
        *error = [[NSError alloc] initWithDomain:@"com.0xBBC.SQLHelper" code:errorCode userInfo:@{@"Error":[NSString stringWithFormat:@"%s",sqlite3_errmsg(db)]}];
    }
    return result;
}
+(void)addSearchEngine:(Class)cls{
    if(LyricSearchEngine==nil){
        LyricSearchEngine=[NSMutableArray array];
    }
    [LyricSearchEngine addObject:cls];
    
}
@end
