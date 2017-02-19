//
//  NeteaseLyricSearchEngine.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractLyricSearchEngine.h"
#define modulus @"00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7b725152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280104e0312ecbda92557c93870114af6c9d05c4f7f0c3685b7a46bee255932575cce10b424d813cfe4875d3e82047b97ddef52741d546b8e289dc6935b3ece0462db0a22b8e7"
#define nonce @"0CoJUm6Qyw8W8jud"
#define PKey @"010001"
#define RSAIV @"0102030405060708"
@interface NeteaseLyricSearchEngine : NSObject<AbstractLyricSearchEngine>{
    NSMutableDictionary* HTTPHeaders;
}
#ifdef NETEASE_CRYPTO
//In Emergency.brew install gmp and link libGMP
-(NSDictionary*)EncryptParams:(id)Params;
-(NSString*)rsaEncrypt:(NSString*)Text PublicKey:(NSString*)publicKey mod:(NSString*)mod;
-(NSString*)aesEncrypt:(NSString*)Text Key:(NSString*)secKey;
-(NSString*)createSecretKey:(int)size;
#endif
-(NSDictionary*)searchSongInfo:(NSString*)s;
-(NSDictionary*)searchLyricForSongInfo:(NSDictionary*)Info;
@end
