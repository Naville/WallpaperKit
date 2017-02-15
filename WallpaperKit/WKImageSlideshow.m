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
}
- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self->ImageURLList=[args objectForKey:@"Images"];
    if(self->ImageURLList==nil){
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    }
    
    if([args.allKeys containsObject:@"Interval"]){
        self->interval=[[args objectForKey:@"Interval"] unsignedIntValue];
    }
    else{
        self->interval=10;
    }
    
    return self;
}
- (void)play{
    [NSThread detachNewThreadWithBlock:^(){
        __block NSUInteger index=0;
        NSLock* threadLock=[NSLock new];
        while(1){
            sleep(self->interval);
            dispatch_async(dispatch_get_main_queue(), ^{
                [threadLock lock];
#ifdef DEBUG
                NSLog(@"Changing Image To %lu in set",(unsigned long)index);
#endif
                [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:YES];
                [self setNeedsDisplay];
                index=(index+1)%ImageURLList.count;
                [threadLock unlock];
            });
        }
    }];
}
@end
