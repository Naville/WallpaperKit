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
    [window setLevel:NSStatusWindowLevel-1];
    [window setAcceptsMouseMovedEvents:NO];
    return self;
}
-(void)mouseDragged:(NSEvent *)event{
    NSPoint newLocation=[NSEvent mouseLocation];
    newLocation.x-=self.frame.size.width/2;
    newLocation.y-=self.frame.size.height/2;
    [self setFrameOrigin:newLocation];
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
- (void)mouseUp:(NSEvent *)event
{
    if([event clickCount]==2){
        if(self.window.level==(kCGDesktopIconWindowLevel+1)){
             [self.window setLevel:NSStatusWindowLevel-1];
        }
        else{
            [self.window setLevel:kCGDesktopIconWindowLevel+1];
        }
    }
    else{
        [super mouseUp:event];
    }
}

@end
