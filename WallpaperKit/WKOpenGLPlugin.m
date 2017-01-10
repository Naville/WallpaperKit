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
    void (^OpenGLDrawingBlock)(NSOpenGLView* view);
}

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    NSOpenGLPixelFormatAttribute attrs[] =
    {
        NSOpenGLPFADoubleBuffer,
        kCGLPFAOpenGLProfile,
        0
    };
    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    self=[super initWithFrame:frameRect pixelFormat:pixelFormat];
    
    ///self->OpenGLDrawingBlock=[args objectForKey:@"DrawingBlock"];
    //self->OpenGLDrawingBlock(self);
    return self;
}
@end
