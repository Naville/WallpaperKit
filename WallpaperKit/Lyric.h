//
//  Lyric.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.

#import <Foundation/Foundation.h>

/**
 ADT for operating on Lyrics
 */
@interface Lyric : NSObject{
    NSMutableArray* lyrics;
}
/**
 Init From LRC String

 @param LRC Raw LRC NSString
 @return Instance
 */
-(instancetype)initWithLRC:(NSString*)LRC;
/**
 Next Line Since Given Time

 @param position The number in secs
 @return Next Line's Lyric
 */
-(NSString*)nextLinewithTime:(double)position;
@end
