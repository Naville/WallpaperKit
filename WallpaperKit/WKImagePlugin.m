//
//  WKImagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKImagePlugin.h"

@implementation WKImagePlugin{
    NSString* desc;
    NSURL* ImagePath;
}

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    self=[super initWithFrame:frameRect];
    self->ImagePath=[args objectForKey:@"Path"];
    self->desc=[(NSURL*)[args objectForKey:@"Path"] path];
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
    return [@"WKImagePlugin " stringByAppendingString:self->desc];
}
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(NSUInteger)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKImagePlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[(NSURL*)returnValue[@"Path"] path];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=[WKImagePlugin class];
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
