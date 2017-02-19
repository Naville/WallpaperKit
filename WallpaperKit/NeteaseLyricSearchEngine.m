//
//  NeteaseLyricSearchEngine.m
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//  Reimplementation of http://www.jianshu.com/p/3269321e0df5

#import "NeteaseLyricSearchEngine.h"
#import "Utils.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NeteaseLyricSearchEngine
+(void)load{
    [LyricManager addSearchEngine:self];
}
-(instancetype)init{
    self=[super init];
    self->HTTPHeaders=[NSMutableDictionary dictionary];
    [HTTPHeaders setObject:@"*/*" forKey:@"Accept"];
    [HTTPHeaders setObject:@"appver=1.5.0.75771" forKey:@"Cookie"];
    [HTTPHeaders setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36" forKey:@"User-Agent"];
    [HTTPHeaders setObject:@"https://music.163.com" forKey:@"Origin"];
    [HTTPHeaders setObject:@"https://music.163.com/search/" forKey:@"Referer"];
    return self;
}
-(NSData*)POST:(NSString*)URL Params:(id)Params{
    NSURL* POSTURL=[NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:POSTURL];
    request.allHTTPHeaderFields=self->HTTPHeaders;
    [request setHTTPMethod:@"POST"];
    NSMutableArray* ParamsList=[NSMutableArray array];
    [Params enumerateKeysAndObjectsUsingBlock:^(id Key,id obj,BOOL* stop){
        [ParamsList addObject:[NSString stringWithFormat:@"%@=%@",Key,obj]];
    }];
    NSString* POSTBody=[ParamsList componentsJoinedByString:@"&"];
    [request setHTTPBody:[POSTBody dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse* response;
    NSError* err;
    NSData* retVal=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if(err!=nil){
        NSLog(@"%s %@",__PRETTY_FUNCTION__,err.localizedDescription);
    }
    return retVal;
}
-(NSDictionary*)searchSongInfo:(NSString*)s{
   // NSString* s=[NSString stringWithFormat:@"%@ %@",[Info objectForKey:@"Song"],[Info objectForKey:@"Artist"]];
    NSDictionary* Params=@{@"s":s,
                           @"type":@1,
                           @"offset":@0,
                           @"total":@1,
                           @"limit":@100
                           };
    NSData* POSTData=[self POST:@"https://music.163.com/api/search/get" Params:Params];
    return [NSJSONSerialization JSONObjectWithData:POSTData options:NSJSONReadingMutableLeaves error:nil];
}
-(NSDictionary*)searchLyricForSongInfo:(NSDictionary*)Info{
    NSMutableArray* allSongs=[NSMutableArray array];
    for (NSString* Rule in [[Utils sharedManager] SongMatchQueriesFromInfo:Info]){
        NSDictionary* MatchList=[self searchSongInfo:Rule];
        NSArray* Songs=MatchList[@"result"][@"songs"];
        [allSongs addObjectsFromArray:Songs];
        
    }
    
    NSNumber* SongID=allSongs[0][@"id"];
    NSString* LRCURL=[NSString stringWithFormat:@"https://music.163.com/api/song/lyric?os=osx&id=%@&lv=-1&kv=-1&tv=-1",SongID];
    NSDictionary* LRCInfo=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:LRCURL]] options:NSJSONReadingMutableLeaves error:nil];
    NSMutableDictionary* retVal=[NSMutableDictionary dictionary];
    NSString* LRC=LRCInfo[@"lrc"][@"lyric"];
    if(![LRC isEqual:[NSNull null]] && LRC.length>0){
        [retVal setObject:LRC forKey:@"Lyric"];
    }
    NSString* Translated=LRCInfo[@"tlyric"][@"lyric"];
    if(![Translated isEqual:[NSNull null]] && Translated.length>0){
        [retVal setObject:Translated forKey:@"Translated"];
    }
    return retVal;
}
@end
