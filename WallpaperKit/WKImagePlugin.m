//
//  WKImagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKImagePlugin.h"

@implementation WKImagePlugin{
    NSURL* ImagePath;
}

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    self=[super initWithFrame:frameRect];
    self->ImagePath=[args objectForKey:@"Path"];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self.requiresConsistentAccess=NO;
    return self;
}
-(void)play{
    [self setImage:[[NSImage alloc] initWithContentsOfURL:self->ImagePath]];
}
-(void)pause{
    
}
-(NSString*)description{
    return [@"WKImagePlugin " stringByAppendingString:[self->ImagePath.absoluteString stringByRemovingPercentEncoding]];
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(WKSerializeOption)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKImagePlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[(NSURL*)returnValue[@"Path"] absoluteString];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=[WKImagePlugin class];
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[NSURL URLWithString:[args objectForKey:@"Path"]];
        }
    }
    
    return returnValue;
}
@end
