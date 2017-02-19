//
//  Utils.h
//  NCLyrics
//
//  Created by Naville Zhang on 2016/12/30.
//  Copyright © 2016年 Naville Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKUtils.h"
@interface Utils : NSObject
/**
 Generate Search Keywords From Rules

 @param Info NSDictionary. Follows the protocal specified in LyricManager
 @return A List of keywords
 */
-(NSMutableSet*)SongMatchQueriesFromInfo:(NSDictionary*)Info;
+(instancetype)sharedManager;
/**
Collection of SongMatchRules
A Rule is a string consists of %% wrapped Info keys.
 
    Info Keys will be replaced by actual values and used  by search engines as query
    Each rule should either ends with a block or a single space
 */
@property NSMutableArray* SongMatchRules;
/**
Collection of HTML Based View Rendering Templates.
 
Read from BaseURL/ 
 
Percentage Enclosed Tags Will Replaced By Corrensponding Runtime Value
 
The format of the documentation below:
 
    Name(Also used as the key for dictionary):
            FileURL Available Tags
 
@param Lyric BaseURL/Lyric.html 
 
- %LYRIC%
 
@param Title BaseURL/Title.html
 
- %SONGNAME%
- %ARTISTNAME%
- %ALBUMNAME%
 
@param Pronounce BaseURL/Pronounce.html
 
- %PRONOUNCE%
 
@param Translated BaseURL/Translated.html
 
- %TRANSLATED%
 */
@property NSMutableDictionary* ViewRenderTemplates;
@end
