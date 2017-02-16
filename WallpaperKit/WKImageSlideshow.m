//
//  WKImageSlideshow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKImageSlideshow.h"
@implementation WKImageSlideshow{
    NSArray* ImageURLList;
    unsigned int interval;
    BOOL threadShouldQuit;
    NSThread* lastThread;
    NSLock* threadLock;
    NSString* descript;
}
- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self->ImageURLList=[args objectForKey:@"Images"];
    if(self->ImageURLList==nil){
        self->descript=[@"ImagePath: " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  absoluteString]];
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    }
    else{
        self->descript=[self->ImageURLList componentsJoinedByString:@"\n"];
    }
    
    if([args.allKeys containsObject:@"Interval"]){
        self->interval=[[args objectForKey:@"Interval"] unsignedIntValue];
    }
    else{
        self->interval=10;
    }
    self->threadShouldQuit=NO;
    self->threadLock=[NSLock new];
    return self;
}
- (NSThread*)ImageUpdateThread{
   return [[NSThread alloc] initWithBlock:^(){
        __block NSUInteger index=0;
        while(1){
            if(self->threadShouldQuit){
                self->threadShouldQuit=NO;
                break;
            }
            sleep(self->interval);
            dispatch_async(dispatch_get_main_queue(), ^{
                [threadLock lock];
                [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:YES];
                [self setNeedsDisplay];
                index=(index+1)%ImageURLList.count;
                [threadLock unlock];
            });
        }
    }];
}
-(void)play{
    self->lastThread=[self ImageUpdateThread];
    [self->lastThread start];
}
-(void)pause{
    self->threadShouldQuit=YES;
    self->lastThread=nil;
}
-(NSString*)description{
    return [@"WKImageSlideshow " stringByAppendingString:self->descript];
}
@end
