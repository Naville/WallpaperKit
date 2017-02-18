//
//  WKUtils.h
//  WallpaperKit
//
//  Created by Naville Zhang on 18/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <AppKit/AppKit.h>
#define ALLKEYBOARDMOUSEEVENTS  NSEventMaskKeyDown|NSEventMaskKeyUp|NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown|\
NSEventMaskLeftMouseUp|NSEventMaskRightMouseUp|NSEventMaskMouseMoved|NSEventMaskLeftMouseDragged|\
NSEventMaskRightMouseDragged|NSEventMaskMouseEntered|NSEventMaskMouseExited|\
NSEventMaskCursorUpdate|NSEventMaskScrollWheel|NSEventMaskOtherMouseDown|NSEventMaskOtherMouseUp|\
NSEventMaskOtherMouseDragged

@interface WKUtils : NSObject
+(id)registerGlobalEventMonitorForMask:(NSEventMask)mask withCallback:(void (^)(NSEvent*))block;
+(void)InvalidateEventMonitor:(id)mon;
+(BOOL)isTrustedByAccessibility;
/**
 Check how much of a NSWindow is covered by another window

 @param window Window for measureing
 @return Covered Percentage
 */
+(double)OcclusionRateForWindow:(NSWindow*)window;
@end
