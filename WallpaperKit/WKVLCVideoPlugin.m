//
//  WKVLCVideoPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKVLCVideoPlugin.h"
@implementation WKVLCVideoPlugin{
    VLCMediaPlayer* player;
}

- (instancetype)initWithWindow:(NSWindow*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    player=[[VLCMediaPlayer alloc] initWithVideoView:self];
    [player setMedia:[VLCMedia mediaWithURL:[args objectForKey:@"Path"]]];
    [player play];
    return self;
}
-(void)pause{
    [player pause];
}
-(void)play{
    [player play];
}
@end
