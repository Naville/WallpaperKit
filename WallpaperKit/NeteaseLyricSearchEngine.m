//
//  NeteaseLyricSearchEngine.m
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//  Reimplementation of http://www.jianshu.com/p/3269321e0df5

#import "NeteaseLyricSearchEngine.h"
#import <CommonCrypto/CommonCrypto.h>
#import "WKConfigurationManager.h"
#ifdef NETEASE_USE_NEW_API
#import <gmp.h>
#endif
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
    [HTTPHeaders setObject:@"http://music.163.com" forKey:@"Origin"];
    [HTTPHeaders setObject:@"http://music.163.com/search/" forKey:@"Referer"];
    return self;
}
-(NSDictionary*)searchSongInfo:(NSString*)s{
   // NSString* s=[NSString stringWithFormat:@"%@ %@",[Info objectForKey:@"Song"],[Info objectForKey:@"Artist"]];
    NSDictionary* Params=@{@"s":s,
                           @"type":@1,
                           @"offset":@0,
                           @"total":@"true",
                           @"limit":@100
                           };
    NSData* POSTData=[self POST:@"http://music.163.com/api/search/get" Params:Params];
    return [NSJSONSerialization JSONObjectWithData:POSTData options:NSJSONReadingMutableLeaves error:nil];
}
-(nullable NSDictionary*)searchLyricForSongInfo:(nonnull NSDictionary*)Info{
    @autoreleasepool {
        NSMutableArray* allSongs=[NSMutableArray array];
        for (NSString* Rule in [[WKConfigurationManager sharedInstance] GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics" Key:@"SongMatchRules" andConfiguration:[NSArray arrayWithObjects:@"%SONG% %ALBUM%",@"%SONG% %ARTIST%",@"%SONG% %ALBUMARTIST%", nil] type:READWRITE]){
            NSString* S=[Rule stringByReplacingOccurrencesOfString:@"%SONG%" withString:[Info objectForKey:@"Song"]];
            S=[S stringByReplacingOccurrencesOfString:@"%ALBUM%" withString:[Info objectForKey:@"Album"]];
            S=[S stringByReplacingOccurrencesOfString:@"%ARTIST%" withString:[Info objectForKey:@"Artist"]];
            S=[S stringByReplacingOccurrencesOfString:@"%ALBUMARTIST%" withString:[Info objectForKey:@"AlbumArtist"]];
            NSDictionary* MatchList=[self searchSongInfo:S];
            NSArray* Songs=MatchList[@"result"][@"songs"];
            [allSongs addObjectsFromArray:Songs];
            
        }
        //For Each Item
        /*
         
         "id": 412654822,
         "name": "Milky Rally",
         "artists": [{
         "id": 12007416,
         "name": "livetune+",
         "picUrl": null,
         "alias": [],
         "albumSize": 0,
         "picId": 0,
         "img1v1Url": "http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
         "img1v1": 0,
         "trans": null
         }
         */

        NSMutableArray* validSongs=[self validSongs:allSongs Info:Info];
        NSNumber* SongID=validSongs[0][@"id"];
        NSString* LRCURL=[NSString stringWithFormat:@"http://music.163.com/api/song/lyric?os=osx&id=%@&lv=-1&kv=-1&tv=-1",SongID];
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
}
-(NSMutableArray*)validSongs:(NSArray*)allSongs Info:(NSDictionary*)Info{
    @autoreleasepool {
        NSMutableArray* validSongs=[NSMutableArray array];
        id firstObj=[allSongs firstObject];
        for (NSDictionary* item in allSongs){
            BOOL ValidArtist=NO;
            for(NSDictionary* ArtistInfo in item[@"artists"]){
                if([(NSString*)ArtistInfo[@"name"] containsString:Info[@"Artist"]] || [(NSString*)ArtistInfo[@"name"] containsString:Info[@"AlbumArtist"]] || [Info[@"Artist"] containsString:(NSString*)ArtistInfo[@"name"]] || [Info[@"AlbumArtist"] containsString:(NSString*)ArtistInfo[@"name"]] ){
                    ValidArtist=YES;
                    break;
                }
            }
            
            if(([(NSString*)item[@"name"] containsString:[Info objectForKey:@"Song"]] || [(NSString*)[Info objectForKey:@"Song"] containsString:(NSString*)item[@"name"]]) && ValidArtist){
                [validSongs addObject:item];
            }
            
        }
        if(validSongs.count==0){
            [validSongs addObject:firstObj];
        }
        return validSongs;
    }
}

#ifdef NETEASE_USE_NEW_API
-(NSData*)POST:(NSString*)URL Params:(NSDictionary*)Params{
#warning Unimplemented
    NSURL* POSTURL=[NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:POSTURL];
    request.allHTTPHeaderFields=self->HTTPHeaders;
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:Params options:NSJSONWritingPrettyPrinted error:nil]];

    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

}
#else
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
#endif
//Crypto
#ifdef NETEASE_USE_NEW_API
-(NSMutableString*)createSecretKey:(NSUInteger)length{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}
-(NSString*)AESEncrypt:(NSString*)Input Key:(NSString*)key{
    NSMutableString* Text=[Input mutableCopy];
    char pad=16-Text.length%16;
    while (Text.length%16!=0) {
        [Text appendString:[NSString stringWithFormat:@"%c",pad]];
    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    NSData* dat=[Text dataUsingEncoding:NSUTF8StringEncoding];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [@"0102030405060708" getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [dat length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,0,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [dat bytes], [dat length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess){
        NSLog(@"Success");
        return [[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
    
}
-(NSString*)RSAEncrypt:(NSString*)Input{
    NSMutableString *Text = [NSMutableString string];
    NSInteger charIndex = [Input length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [Text appendString:[Input substringWithRange:subStrRange]];
    }//Reverse The String
    
    NSUInteger len = [Text length];
    unichar *chars = malloc(len * sizeof(unichar));
    [Text getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    Text=hexString;//Hexify The String
    mpz_t TextHex,PKeyHex,ModulusHex,ResultHex;
    mpz_set_str (TextHex,Text.UTF8String,16);
    mpz_set_str (PKeyHex,"010001",16);
    mpz_set_str (ModulusHex,"00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7b725152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280104e0312ecbda92557c93870114af6c9d05c4f7f0c3685b7a46bee255932575cce10b424d813cfe4875d3e82047b97ddef52741d546b8e289dc6935b3ece0462db0a22b8e7",16);
    mpz_powm (ResultHex,TextHex,PKeyHex,ModulusHex);
    char* result=mpz_get_str (NULL,16,ResultHex);
    
    
    return [NSString stringWithUTF8String:result];
}
-(NSDictionary*)EncryptParams:(NSDictionary*)Input{
    NSString* JSON=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:Input options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSString* sKey=[self createSecretKey:16];
    NSString* EncryptedText=[self AESEncrypt:JSON Key:@"0CoJUm6Qyw8W8jud"];
    EncryptedText=[self AESEncrypt:EncryptedText Key:sKey];
    NSString* EncryptedSecKey=[self RSAEncrypt:sKey];
    
    return @{@"params":EncryptedText,@"encSecKey":EncryptedSecKey};
}
#endif
@end
