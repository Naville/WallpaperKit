//
//  WKOpenGLPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKOpenGLPlugin.h"

@implementation WKOpenGLPlugin{
     void (^OpenGLDrawingBlock)(NSOpenGLView* view);
}

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    self->OpenGLDrawingBlock=[args objectForKey:@"DrawingBlock"];
    return self;
}

@end
