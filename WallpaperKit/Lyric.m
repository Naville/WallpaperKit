//
//  Lyric.m
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import "Lyric.h"
#import "DLLRCParser.h"
@implementation Lyric
- (instancetype)initWithLRC:(NSString *)LRC {
        self = [super init];
        if (LRC == nil) {
                self->lyrics = [NSMutableArray array];
        } else {
                self->lyrics = [[[DLLRCParser alloc] init] parseLRC:LRC];
        }
        return self;
}
- (NSString *)nextLinewithTime:(double)position {
        if (lyrics.count == 0) {
                return @"";
        }
        for (int i = 0; i < lyrics.count; i++) {
                if (i == lyrics.count - 1) {
                        return [[lyrics objectAtIndex:lyrics.count - 1]
                            objectForKey:@"LRC"];
                }
                float timeDiffer = [[[lyrics objectAtIndex:i]
                                       objectForKey:@"TIME"] floatValue] -
                                   position;
                float timeDifferNext = [[[lyrics objectAtIndex:i + 1]
                                           objectForKey:@"TIME"] floatValue] -
                                       position;
                if (timeDifferNext > 0 && timeDiffer < timeDifferNext) {
                        return [[lyrics objectAtIndex:i] objectForKey:@"LRC"];
                }
        }

        return @"This Shouldn't Appear";
}
@end
