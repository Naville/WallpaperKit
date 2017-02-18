//
//  WKVideoPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKVideoPlugin.h"
@implementation WKVideoPlugin{
    AVPlayer* player;
    NSURL* URL;
}
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    self->URL=[args objectForKey:@"Path"];
    self.showsSharingServiceButton=NO;
    self.showsFrameSteppingButtons=NO;
    self.showsFullScreenToggleButton=NO;
    self.controlsStyle=AVPlayerViewControlsStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observer:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
    self.requiresConsistentAccess=YES;
    return self;
}
-(void)observer:(NSNotification *)notif{
    if([notif.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]){
        AVPlayerItem *p = [notif object];
        [p seekToTime:kCMTimeZero];
    }
    
}
-(void)pause{
    [player pause];
}
-(void)play{
    if(player==nil){
        player=[AVPlayer playerWithURL:self->URL];
        player.actionAtItemEnd=AVPlayerActionAtItemEndNone;
    }
    [player play];
}
-(NSString*)description{
    return [@"WKVideoPlugin " stringByAppendingString:[self->URL.absoluteString stringByRemovingPercentEncoding]];
}
@end
