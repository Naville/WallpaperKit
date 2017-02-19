//
//  DLLRCParser.h
//  LrcParser
//
//  Created by Naville.Zhang,Based On Lee's Original DLLRCParser
//  Copyright (c) 2015 Naville.Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLLRCParser : NSObject{
    
    NSMutableArray * tmpArray;
    
    
}

@property(nonatomic,retain)NSMutableArray * lrcArrayList;

-(id)init;

-(NSMutableArray *)parseLRC:(NSString *)lrcStr;
-(NSString*)Combiner:(NSMutableArray*)array1;
@end
