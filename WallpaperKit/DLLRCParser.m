//
//  DLLRCParser.m
//  LrcParser
//
//  Created by Naville.Zhang,Based On Lee's Original DLLRCParser
//  Copyright (c) 2015 Naville.Zhang. All rights reserved.
//

#import "DLLRCParser.h"

@implementation DLLRCParser


-(id)init{
    
    self=[super init];
    
    if (self) {
        
        _lrcArrayList=[[NSMutableArray alloc]initWithCapacity:10];
        
        tmpArray=[[NSMutableArray alloc]initWithCapacity:10];
        
    }
    
    return self;
}

-(NSMutableArray *)parseLRC:(NSString *)lrcStr{
    
    NSArray * arr=[lrcStr componentsSeparatedByString:@"\n"];
    
    [_lrcArrayList removeAllObjects];
    
    [tmpArray removeAllObjects];
    
    for (NSString * str in arr) {
        
        [self parseLrcLine:str];
        
        [self parseTempArray:tmpArray];
        
    }
    
    [self sortAllItem:self.lrcArrayList];
    
    
    return self.lrcArrayList;
    
}


-(NSString*) parseLrcLine:(NSString *)sourceLineText
{
    if (!sourceLineText || sourceLineText.length <= 0)
        
        return nil;
    
    NSRange range = [sourceLineText rangeOfString:@"]"];
    
    if (range.length > 0)
    {
        
        NSString * time = [sourceLineText substringToIndex:range.location + 1];
        
        NSString * other = [sourceLineText substringFromIndex:range.location + 1];
        
        if (time && time.length > 0)
            
            [tmpArray addObject:time];
        
        if (other.length>1){
            
            [self parseLrcLine:other];
            
        }
        
        
        
    }else
    {
        [tmpArray addObject:sourceLineText];
    }
    
    
    return nil;
    
}



-(void) parseTempArray:(NSMutableArray *) tempArray
{
    unsigned long count;
    
    if (!tempArray || tempArray.count <= 0)
        return;
    NSString *value = [tempArray lastObject];
    if ([value hasPrefix:@"["])
    {
        
        if ([value hasPrefix:@"[ti:"]||[value hasPrefix:@"[ar:"]||[value hasPrefix:@"[al:"]) {
            
            NSRange  range;
            
            range.location=4;
            
            range.length=value.length-1-4;
            
            value=[value substringWithRange:range];
            
        }else{
            
            value=@"";
        }
        
    }
    if (tempArray.count==1) {
        count=1;
    }else{
        
        count=tempArray.count-1;
    }
    
    for (int i = 0; i < count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString * key = [tempArray objectAtIndex:(NSUInteger)i];
        NSString *secondKey = [self timeToSecond:key]; // 转换成以秒为单位的时间计数器
        [dic setObject:key forKey:@"LRCTIME"];
        [dic setObject:value forKey:@"LRC"];
        [dic setObject:secondKey forKey:@"TIME"];
        [self.lrcArrayList addObject:dic];
    }
    [tempArray removeAllObjects];
}
-(NSString *)timeToSecond:(NSString *)formatTime {
    if (!formatTime || formatTime.length <= 0){
        return @"0";
    }
    
    if ([formatTime rangeOfString:@"["].length <= 0 && [formatTime rangeOfString:@"]"].length <= 0){
        return @"0";
    }
    NSString * minutes = [formatTime substringWithRange:NSMakeRange(1, 2)];
    
    NSString *  second =@"0";
    
    if (formatTime.length==10) {
        
        NSUInteger length;
        
        NSUInteger position=4;
        
        length=formatTime.length-6;
        
        second  = [formatTime substringWithRange:NSMakeRange(position, length)];
        
    }
    
    float finishSecond = minutes.intValue * 60 + second.floatValue;
    
    return [NSString stringWithFormat:@"%f",finishSecond];
}

-(void)sortAllItem:(NSMutableArray *)array {
    
    if (!array || array.count <= 0)
        
        return;
    
    for (int i = 0; i < array.count - 1; i++)
    {
        
        for (int j = i + 1; j < array.count; j++)
        {
            
            id firstDic = [array objectAtIndex:(NSUInteger )i];
            
            id secondDic = [array objectAtIndex:(NSUInteger)j];
            
            if (firstDic && [firstDic isKindOfClass:[NSDictionary class]] && secondDic && [secondDic isKindOfClass:[NSDictionary class]])
            {
                
                NSString *firstTime = [[firstDic allKeys] objectAtIndex:0];
                
                NSString *secondTime = [[secondDic allKeys] objectAtIndex:0];
                
                BOOL b = firstTime.floatValue > secondTime.floatValue;
                
                if (b) // 第一句时间大于第二句，就要进行交换
                {
                    
                    [array replaceObjectAtIndex:(NSUInteger )i withObject:secondDic];
                    
                    [array replaceObjectAtIndex:(NSUInteger )j withObject:firstDic];
                    
                }
            }
        }
    }
}
-(NSString*)Combiner:(NSMutableArray*)array1{
    NSDictionary* nulldict=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LRCTIME",@"",@"LRC",@"0",@"TIME",nil];
    NSArray* arraytmp=[array1 sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1,id obj2){
        
        if([[obj1 objectForKey:@"TIME"] floatValue] ==[[obj2 objectForKey:@"TIME"] floatValue]){
            return NSOrderedSame;
        }
        if([[obj1 objectForKey:@"TIME"] floatValue] <[[obj2 objectForKey:@"TIME"] floatValue]){
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
        
        
    }];
    
    
    array1=[NSMutableArray arrayWithArray:arraytmp];
    // NSLog(@"Sorted:%@",array1);
    //   [array1 writeToFile:@"/Users/Naville/Desktop/Sorted.txt" atomically:YES];
    
    NSMutableString* finallrc=[NSMutableString string];
    for(int i=0;i<array1.count;i++){
        //  [finallrc appendString:@"\n"];
        //             NSLog(@"%i",i);
        id nextObject;
        id preObject;
        id currobject;
        if(i==0||i>=array1.count-1){
            if(i==0){
                nextObject=[array1 objectAtIndex:i+1];
                preObject=[array1 objectAtIndex:i];
                currobject=[array1 objectAtIndex:i];
            }
            else{
                nextObject=[array1 objectAtIndex:i];
                preObject=[array1 objectAtIndex:i-1];
                currobject=[array1 objectAtIndex:i];
            }
        }
        else{
            
            nextObject=[array1 objectAtIndex:i+1];
            preObject=[array1 objectAtIndex:i-1];
            currobject=[array1 objectAtIndex:i];
            
        }
        
        //      NSLog(@"%@:%@",[currobject objectForKey:@"LRCTIME"],[currobject objectForKey:@"LRC"]);
        
        float nexttime=[[nextObject objectForKey:@"TIME"] floatValue];
        float pretime=[[preObject objectForKey:@"TIME"] floatValue];
        float currtime=[[currobject objectForKey:@"TIME"] floatValue];
        
        float timediff1=nexttime-currtime;
        float timediff2=currtime-pretime;
        if(timediff2<=0.000005&&i!=0&&i!=array1.count-1){
            if([finallrc containsString:[currobject objectForKey:@"LRCTIME"]]){
                
            }
            else{
                NSString* tmpstr=[NSString stringWithFormat:@"%@%@%@",[currobject objectForKey:@"LRCTIME"],[currobject objectForKey:@"LRC"],[preObject objectForKey:@"LRC"]];
                ///   [array1 removeObject:preObject];
                //    [array1 removeObject:currobject];
                [array1 setObject:nulldict atIndexedSubscript:i-1];
                [array1 setObject:nulldict atIndexedSubscript:i];
                [finallrc appendString:tmpstr];
                //   [finallrc appendString:@"\n"];
            }
            
        }
        if(timediff1<=0.000005&&i!=0&&i!=array1.count-1){
            if([finallrc containsString:[currobject objectForKey:@"LRCTIME"]]){
                
            }
            else{
                NSString* tmpstr=[NSString stringWithFormat:@"%@%@%@",[currobject objectForKey:@"LRCTIME"],[currobject objectForKey:@"LRC"],[nextObject objectForKey:@"LRC"]];
                [array1 setObject:nulldict atIndexedSubscript:i+1];
                [array1 setObject:nulldict atIndexedSubscript:i];
                
                
                //  [array1 removeObject:nextObject];
                //  [array1 removeObject:currobject];
                [finallrc appendString:tmpstr];
                //  [finallrc appendString:@"\n"];
            }
            
        }
        else{
            // NSMutableString* rstring=[NSMutableString string];
            if([finallrc containsString:[currobject objectForKey:@"LRCTIME"]]){
                
            }
            else{
                NSString* tmpstr=[NSString stringWithFormat:@"%@%@",[currobject objectForKey:@"LRCTIME"],[currobject objectForKey:@"LRC"]];
                //       [array1 removeObject:currobject];
                [array1 setObject:nulldict atIndexedSubscript:i];
                [finallrc appendString:tmpstr];
                //  [finallrc appendString:@"\n"];
            }
            
        }
    }
    finallrc=[NSMutableString stringWithString:[finallrc stringByReplacingOccurrencesOfString:@"\x0A" withString:@""]];
    finallrc=[NSMutableString stringWithString:[finallrc stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    // NSLog(@"%@",finallrc);
    finallrc=[NSMutableString stringWithString:[finallrc stringByReplacingOccurrencesOfString:@"[" withString:@"\n["]];
    
    return finallrc;
}





@end
