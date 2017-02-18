//
//  WKOpenGLPlugin.h
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKDesktop.h"
@interface WKOpenGLPlugin : NSOpenGLView<WKRenderProtocal>
@property (nonatomic) BOOL requiresConsistentAccess;
@end
