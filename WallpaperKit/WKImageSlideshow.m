//
//  WKImageSlideshow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKImageSlideshow.h"
@implementation WKImageSlideshow{
    NSArray<NSURL*>* ImageURLList;
    unsigned int interval;
    NSString* descript;
    NSOperationQueue* op;
    NSUInteger index;
}
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSError* error;
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setBackgroundColor:[NSColor blackColor]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self->ImageURLList=[args objectForKey:@"Images"];
    if(self->ImageURLList==nil){
        self->descript=[@"ImagePath: " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  path]];
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    }
    if(self->ImageURLList==0){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ImageList is empty" userInfo:args];
    }
    
    if([args.allKeys containsObject:@"Interval"]){
        self->interval=[[args objectForKey:@"Interval"] unsignedIntValue];
    }
    else{
        self->interval=10;
    }
    self->op=[NSOperationQueue new];
    [self->op setMaxConcurrentOperationCount:1];//Single Thread
    if(error!=nil){
        [window setErr:error];
    }
    self.requiresConsistentAccess=NO;
    return self;
}
- (void)ImageUpdate{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    [operation addExecutionBlock: ^ {
        while(true){
            if ([weakOperation isCancelled]) return;
            [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:YES];
            [self setNeedsDisplay];
            sleep(self->interval);
            index=(index+1)%ImageURLList.count;
        }
    }];
    [self->op addOperation:operation];
}
-(void)play{
    [self ImageUpdate];
}
-(void)pause{
    [self->op cancelAllOperations];
}
-(NSString*)description{
    if(self->descript==nil){
        self->descript=self->ImageURLList[0].path;
    }
    return [@"WKImageSlideshow " stringByAppendingString:self->descript];
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(RenderConvertOperation)op{
    @autoreleasepool {
        NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
        if(op==TOJSON){
            returnValue[@"Render"]=@"WKImageSlideshow";
            if([returnValue.allKeys containsObject:@"Images"]){
                NSMutableArray* urllist=[NSMutableArray array];
                for(NSURL* url in [returnValue objectForKey:@"Images"]){
                    [urllist addObject:url.absoluteString];
                }
                [returnValue setObject:urllist forKey:@"Images"];
            }
            else if([returnValue.allKeys containsObject:@"ImagePath"]){
                NSString* ip=[(NSURL*)[returnValue objectForKey:@"ImagePath"] absoluteString];
                [returnValue setObject:ip forKey:@"ImagePath"];
            }
        }
        else if(op==FROMJSON){
            returnValue[@"Render"]=NSClassFromString(@"WKImageSlideshow");
            if([returnValue.allKeys containsObject:@"Images"]){
                NSMutableArray* urllist=[NSMutableArray array];
                for(NSString* url in [returnValue objectForKey:@"Images"]){
                    NSURL* url2=[NSURL URLWithString:url];
                    [urllist addObject:url2];
                }
                [returnValue setObject:urllist forKey:@"Images"];
            }
            else if([returnValue.allKeys containsObject:@"ImagePath"]){
                NSURL* url2=[NSURL URLWithString:[returnValue objectForKey:@"ImagePath"]];
                [returnValue setObject:url2 forKey:@"ImagePath"];
            }
        }
        
        return returnValue;
    }
}

@end
