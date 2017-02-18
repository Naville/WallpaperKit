//
//  WKOpenGLPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKOpenGLPlugin.h"
#import <OpenGL/gl.h>
@implementation WKOpenGLPlugin{
    void (^OpenGLDrawingBlock)();
}

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    NSOpenGLPixelFormatAttribute attrs[] =
    {
        NSOpenGLPFADoubleBuffer,
        kCGLPFAOpenGLProfile,
        0
    };
    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    self=[super initWithFrame:frameRect pixelFormat:pixelFormat];
    self->OpenGLDrawingBlock=[args objectForKey:@"OpenGLDrawingBlock"];
    self.requiresConsistentAccess=NO;
    return self;
}
-(void)play{
    [self.openGLContext makeCurrentContext];
    self->OpenGLDrawingBlock();
    [self.openGLContext flushBuffer];
}
-(void)pause{
    
}
@end
