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
}
-(instancetype)initWithWindow:(WKDesktop *)window andArguments:(NSDictionary *)args{
    self=[super initWithFrame:window.frame];
    self->VMP=[[VLCMediaPlayer alloc] initWithVideoView:self];
    [self->VMP setMedia:[VLCMedia mediaWithURL:[args objectForKey:@"Path"]]];
    self.requiresConsistentAccess=YES;
    return self;
}
-(void)play{
    [self->VMP play];
}
-(void)pause{
    [self->VMP pause];
}
+(NSDictionary*)convertArgument:(NSDictionary *)args Operation:(NSUInteger)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKVideoPlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[(NSURL*)returnValue[@"Path"] path];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=NSClassFromString(@"WKVideoPlugin");
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
