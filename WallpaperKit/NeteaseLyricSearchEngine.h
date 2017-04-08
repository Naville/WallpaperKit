//
//  NeteaseLyricSearchEngine.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractLyricSearchEngine.h"
@interface NeteaseLyricSearchEngine : NSObject<AbstractLyricSearchEngine>{
    NSMutableDictionary* HTTPHeaders;
}
-(NSDictionary*)searchSongInfo:(NSString*)s;
-(NSDictionary*)searchLyricForSongInfo:(NSDictionary*)Info;
-(NSData*)POST:(NSString*)URL Params:(NSDictionary*)Params;
@end
