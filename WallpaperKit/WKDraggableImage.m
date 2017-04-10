//
//  WKDraggableImage.m
//  WallpaperKit
//
//  Created by Naville Zhang on 25/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKDraggableImage.h"
@implementation WKDraggableImage
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    self=[super initWithWindow:window andArguments:args];
    [self setImageScaling:NSImageScaleNone];
    [window setBackgroundColor:[NSColor clearColor]];
    [window setAcceptsMouseMovedEvents:NO];
    self.requiresExclusiveBackground=YES;
    return self;
}
-(void)mouseDragged:(NSEvent *)event{
    NSPoint newLocation=[NSEvent mouseLocation];
    newLocation.x-=self.frame.size.width/2;
    newLocation.y-=self.frame.size.height/2;
    [self setFrameOrigin:newLocation];
}
- (void)mouseUp:(NSEvent *)event
{
    if([event clickCount]==2){
        if(self.window.level==(kCGNormalWindowLevel+1)){
            [self.window setLevel:kCGDesktopWindowLevel-1];
        }
        else{
            [self.window setLevel:kCGNormalWindowLevel+1];
        }
    }
    else{
        [super mouseUp:event];
    }
}
+( NSMutableDictionary* _Nonnull )convertArgument:( NSDictionary* _Nonnull )args Operation:(WKSerializeOption)op{
    NSMutableDictionary* orig=[super convertArgument:args Operation:op];
    if(op==TOJSON){
        [orig setObject:@"WKDraggableImage" forKey:@"Render"];
    }
    else{
        [orig setObject:NSClassFromString(@"WKDraggableImage") forKey:@"Render"];
    }
    return orig;
}

@end
