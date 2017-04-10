//
//  WKUtils.m
//  WallpaperKit
//
//  Created by Naville Zhang on 18/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKUtils.h"
#import <math.h>

@implementation WKUtils
+(BOOL)isTrustedByAccessibility{
    NSDictionary *options = @{(__bridge NSString*)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
}
+(double)OcclusionRateForWindow:(NSWindow*)window{
    @autoreleasepool {
        NSMutableArray *windows = (NSMutableArray *)CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenAboveWindow| kCGWindowListExcludeDesktopElements,(int) window.windowNumber));
        unsigned int maxSize=0;
        CGRect screenSize=CGDisplayBounds(CGMainDisplayID());
        bool pixelStatusArray[(int)screenSize.size.width+1][(int)screenSize.size.height+1];
        memset(&pixelStatusArray, 0, (int)(screenSize.size.width+1)*(int)(screenSize.size.height+1));
        
        for (NSDictionary *win in windows) {
            NSDictionary* Bounds=[win objectForKey:(id)kCGWindowBounds];
            CGRect upperWindowFrame;
            CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)Bounds,&upperWindowFrame);
            //NSLog(@"Iterating PID:%@ Owned By:%@ Frame:%@",[win objectForKey:kCGWindowOwnerPID],[win objectForKey:kCGWindowOwnerName],NSStringFromRect(upperWindowFrame));
            CGRect intersection = CGRectIntersection(upperWindowFrame,window.frame);
            if (CGRectIsNull(intersection)) {
                continue;
            }
            for(long x=0;x<CGRectGetWidth(intersection);x++){
                for(long y=0;y<CGRectGetHeight(intersection);y++){
                    //Instead of init the array with 1 and set it to 0 . We skip init process and use 1 for invalid pixel
                    //To speed up the process by iterating the bigger array only once
                    pixelStatusArray[x][y]=1;
                }
            }
        }
        for(long x=0;x<(int)screenSize.size.width;x++){
            for(long y=0;y<(int)screenSize.size.height;y++){
                if(pixelStatusArray[x][y]==1){
                    maxSize++;
                }
                
            }
        }
        //NSLog(@"%i/%f is covered",maxSize,screenSize.size.height*screenSize.size.width);
        return (double)maxSize/(screenSize.size.height*screenSize.size.width);
    }
    
}
+(NSTimer*)LoopForHandlingOcclusionStateChangeWithCallback:(void (^)())block OcclusionRate:(float)Threshold Window:(NSWindow*)window timeInterval:(NSInteger)interval{
    return [NSTimer timerWithTimeInterval:interval repeats:YES block:^(NSTimer* timer){
        if([window occlusionState] & NSWindowOcclusionStateVisible){
            block();
            return ;//Avoid expensive pixel calculation at all cost
        }
        if([WKUtils OcclusionRateForWindow:window]>Threshold){
            block();
        }
        
    }];
    
}
+(NSURL*)BaseURL{
    NSURL* retVal= [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"WallpaperKit"] isDirectory:YES];
    BOOL isFolder=NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:retVal.absoluteURL.absoluteString isDirectory:&isFolder]==NO || isFolder==NO){
        [[NSFileManager defaultManager] createDirectoryAtPath:retVal.absoluteURL.absoluteString withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return retVal;
}
@end
