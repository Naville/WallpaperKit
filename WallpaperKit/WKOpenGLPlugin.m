//
//  WKOpenGLPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKOpenGLPlugin.h"
#import <OpenGL/gl.h>
@implementation WKOpenGLPlugin {
        void (^OpenGLDrawingBlock)();
}

- (instancetype)initWithWindow:(WKDesktop *)window
                  andArguments:(NSDictionary *)args {
        [window setBackgroundColor:[NSColor blackColor]];
        NSRect frameRect = window.frame;
        NSOpenGLPixelFormatAttribute attrs[] = {NSOpenGLPFADoubleBuffer,
                                                kCGLPFAOpenGLProfile, 0};
        NSOpenGLPixelFormat *pixelFormat =
            [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
        self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
        self->OpenGLDrawingBlock = [args objectForKey:@"OpenGLDrawingBlock"];
        if (self->OpenGLDrawingBlock == nil) {
                __weak typeof(self) weakSelf = self;
                self->OpenGLDrawingBlock = ^(NSView *self) {
                  NSTextView *tv =
                      [[NSTextView alloc] initWithFrame:window.frame];
                  [tv setString:@"WKOpenGLView\nOpenGLDrawingBlock Not "
                                @"Supplied!\nNote That OpenGL Drawing Block is "
                                @"not saved/loaded to/from disk"];
                  [tv alignCenter:nil];
                  [weakSelf addSubview:tv];
                };
        }
        self.requiresConsistentAccess = NO;
        return self;
}
- (void)play {
        [self.openGLContext makeCurrentContext];
        self->OpenGLDrawingBlock(self);
        [self.openGLContext flushBuffer];
}
- (void)pause {
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (NSMutableDictionary *)convertArgument:(NSDictionary *)args
                               Operation:(WKSerializeOption)op {
        if (op == TOJSON) {
                return [NSMutableDictionary
                    dictionaryWithDictionary:@{@"Render" : @"WKOpenGLPlugin"}];
        } else {
                return [NSMutableDictionary dictionaryWithDictionary:@{
                        @"Render" : [WKOpenGLPlugin class]
                }];
        }
}
@end
