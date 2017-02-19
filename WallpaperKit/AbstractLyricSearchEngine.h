//
//  AbstractLyricSearchEngine.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#ifndef AbstractLyricSearchEngine_h
#define AbstractLyricSearchEngine_h
#import "LyricManager.h"
@protocol AbstractLyricSearchEngine
-(NSDictionary*)searchLyricForSongInfo:(NSDictionary*)Info;
@end
#endif /* AbstractLyricSearchEngine_h */
