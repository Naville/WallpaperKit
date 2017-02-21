//
//  WKVLCVideoPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 20/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKVLCVideoPlugin.h"

@implementation WKVLCVideoPlugin{
    VLCMediaPlayer* VMP;
    NSURL* URL;
}
-(instancetype)initWithWindow:(WKDesktop *)window andArguments:(NSDictionary *)args{
    self=[super initWithFrame:window.frame];
    self->VMP=[[VLCMediaPlayer alloc] initWithVideoView:self];
    self->URL=[args objectForKey:@"Path"];
    [self->VMP setMedia:[VLCMedia mediaWithURL:self->URL]];
    self.requiresConsistentAccess=YES;
    self->VMP.delegate=self;
    return self;
}
-(void)play{
    [self->VMP play];
}
-(void)pause{
    [self->VMP pause];
}
-(void)dealloc{
    self->VMP=nil;
}
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    if([self->VMP state]==VLCMediaPlayerStateEnded){
        //Seek to start
        self->VMP.time=[VLCTime nullTime];
    }
}
-(NSString*)description{
    return [@"WKVideoPlugin " stringByAppendingString:self->URL.path];
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(RenderConvertOperation)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKVLCVideoPlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[(NSURL*)returnValue[@"Path"] path];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=NSClassFromString(@"WKVLCVideoPlugin");
        if([returnValue.allKeys containsObject:@"Path"]){
            NSMutableString* url=[[args objectForKey:@"Path"] mutableCopy];
            if([url hasPrefix:@"/"]){
                [url insertString:@"file://" atIndex:0];
            }
            returnValue[@"Path"]=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return returnValue;
}
@end
