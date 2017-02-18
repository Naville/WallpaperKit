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
 Check how much of a NSWindow is covered by another window.
 Relatively High Cost. Implement in Plugins to avoid overkill

 @param window Window for measureing
 @return Covered Percentage
 */
+(double)OcclusionRateForWindow:(NSWindow*)window;
/**
 Create a wrapper to execute the block if OcclusionState of specified window is larger than threshold
 Uses OcclusionRateForWindow: so also resource intensive
 @warning Most OcclusionRate Events Are Already Handled By WKDesktop .  

This is for events like window resizing took place in other processes
 @param block Block to execute
 @param Threshold Maximum OcclusionRate Allowed
 @param window Window for OcclusionState Checking
 @param interval Timeinterval to sleep before loop is repeated
 @return NSTimer Dispatching The Block
 */
+(NSTimer*)LoopForHandlingOcclusionStateChangeWithCallback:(void (^)())block OcclusionRate:(float)Threshold Window:(NSWindow*)window timeInterval:(NSInteger)interval;
@end
