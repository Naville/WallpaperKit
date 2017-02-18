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
+(nullable id)registerGlobalEventMonitorForMask:(NSEventMask)mask withCallback:(void (^)(NSEvent*))block{
    return [NSEvent addGlobalMonitorForEventsMatchingMask:mask    handler:block];
}
+(void)InvalidateEventMonitor:(id)mon{
    [NSEvent removeMonitor:mon];
}
+(BOOL)isTrustedByAccessibility{
    NSDictionary *options = @{(__bridge NSString*)kAXTrustedCheckOptionPrompt: @YES};
    return AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
}
+(double)OcclusionRateForWindow:(NSWindow*)window{
    
    NSMutableArray *windows = (NSMutableArray *)CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenAboveWindow| kCGWindowListExcludeDesktopElements,(int) window.windowNumber));
    unsigned int maxSize=0;
    CGRect UncoveredFrame=window.frame;
    unsigned int windowSize=UncoveredFrame.size.height*UncoveredFrame.size.width;
    bool pixelStatusArray[(int)UncoveredFrame.size.width][(int)UncoveredFrame.size.height];
    
    for (NSDictionary *win in windows) {
        NSLog(@"Iterating PID:%@ Owned By:%@",[win objectForKey:kCGWindowOwnerPID],[win objectForKey:kCGWindowOwnerName]);
        NSDictionary* Bounds=[win objectForKey:kCGWindowBounds];
        CGRect upperWindowFrame;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)Bounds,&upperWindowFrame);
        CGRect intersection = CGRectIntersection(upperWindowFrame,UncoveredFrame);
        if (CGRectIsNull(intersection)) {
            continue;
        }
        for(long x=0;x<intersection.size.width;x++){
            for(long y=0;y<intersection.size.height;y++){
                //Instead of init the array with 1 and set it to 0 . We skip init process and use 1 for invalid pixel
                //To speed to the process by iterating the array only once
                pixelStatusArray[(int)(x+intersection.origin.x)][(int)(y+intersection.origin.y)]=1;
            }
        }
    }
    for(long x=0;x<UncoveredFrame.size.width;x++){
        for(long y=0;y<UncoveredFrame.size.height;y++){
            //Instead of init the array with 1 and set it to 0 . We skip init process and use 1 for invalid pixel
            //To speed to the process by iterating the array only once
            if(pixelStatusArray[x][y]==1){
                maxSize++;
            }
        }
    }
    
    return (double)maxSize/windowSize;
    
}
@end
