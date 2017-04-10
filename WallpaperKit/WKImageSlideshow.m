//
//  WKImageSlideshow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKImageSlideshow.h"
@implementation WKImageSlideshow{
    NSArray<NSURL*>* ImageURLList;
    unsigned int interval;
    NSString* descript;
    NSTimer* tim;
    NSUInteger index;
    NSObject* syncToken;
    dispatch_source_t src;
    int FolderFD;
}
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSError* error;
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setBackgroundColor:[NSColor blackColor]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self->ImageURLList=[args objectForKey:@"Images"];
    
    
    if(self->ImageURLList==nil){
        self->descript=[@"ImagePath: " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  path]];
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:@[NSURLNameKey,NSURLContentModificationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        [self sortFileList];
        
        self->FolderFD=open([[[args objectForKey:@"ImagePath"] path] fileSystemRepresentation],O_EVTONLY);
        self->src = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, FolderFD, DISPATCH_VNODE_WRITE, dispatch_queue_create([[@"WKImageSlideShowFolderQueue " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  path]] UTF8String], 0));
        
        // call the passed block if the source is modified
        dispatch_source_set_event_handler(self->src,^(){
            self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:@[NSURLNameKey,NSURLContentModificationDateKey,NSURLCreationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
            self->index=0;
            
            [self sortFileList];
        });
        
        // close the file descriptor when the dispatch source is cancelled
        dispatch_source_set_cancel_handler(self->src, ^{
            
            close(self->FolderFD);
        });
        
        // at this point the dispatch source is paused, so start watching
        dispatch_resume(self->src);
        
    }
    if(self->ImageURLList==0){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ImageList is empty" userInfo:args];
    }
    
    if([args.allKeys containsObject:@"Interval"]){
        self->interval=[[args objectForKey:@"Interval"] unsignedIntValue];
    }
    else{
        self->interval=5;
    }
    if(error!=nil){
        [window setErr:error];
    }
    self.requiresConsistentAccess=NO;
    self.requiresExclusiveBackground=NO;
    self->syncToken=[NSObject new];
    return self;
}
- (void)ImageUpdate{
    self->tim=[NSTimer timerWithTimeInterval:self->interval target:self selector:@selector(ImageUpdateSlave) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self->tim forMode:NSDefaultRunLoopMode];
}
-(void)play{
    [self ImageUpdate];
}
-(void)pause{
    [self->tim invalidate];
}

-(void)sortFileList{
    self->ImageURLList=[self->ImageURLList sortedArrayUsingComparator:
                        ^(NSURL *file1, NSURL *file2)
                        {
                            // compare
                            NSDate *file1Date;
                            [file1 getResourceValue:&file1Date forKey:NSURLCreationDateKey error:nil];
                            
                            NSDate *file2Date;
                            [file2 getResourceValue:&file2Date forKey:NSURLCreationDateKey error:nil];
                            return [file2Date compare: file1Date];
                        }];
}
-(void)ImageUpdateSlave{
    @synchronized (self->syncToken) {
        [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:NO];
        [self setNeedsDisplay];
        index=(index+1)%ImageURLList.count;
    }

}
-(NSString*)description{
    if(self->descript==nil){
        self->descript=self->ImageURLList[0].path;
    }
    return [@"WKImageSlideshow " stringByAppendingString:self->descript];
}
-(void)mouseDragged:(NSEvent *)event{
    NSPoint newLocation=[NSEvent mouseLocation];
    newLocation.x-=self.frame.size.width/2;
    newLocation.y-=self.frame.size.height/2;
    [self setFrameOrigin:newLocation];
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(WKSerializeOption)op{
    @autoreleasepool {
        NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
        if(op==TOJSON){
            returnValue[@"Render"]=@"WKImageSlideshow";
            if([returnValue.allKeys containsObject:@"Images"]){
                NSMutableArray* urllist=[NSMutableArray array];
                for(NSURL* url in [returnValue objectForKey:@"Images"]){
                    [urllist addObject:url.absoluteString];
                }
                [returnValue setObject:urllist forKey:@"Images"];
            }
            else if([returnValue.allKeys containsObject:@"ImagePath"]){
                NSString* ip=[(NSURL*)[returnValue objectForKey:@"ImagePath"] absoluteString];
                [returnValue setObject:ip forKey:@"ImagePath"];
            }
        }
        else if(op==FROMJSON){
            returnValue[@"Render"]=NSClassFromString(@"WKImageSlideshow");
            if([returnValue.allKeys containsObject:@"Images"]){
                NSMutableArray* urllist=[NSMutableArray array];
                for(NSString* url in [returnValue objectForKey:@"Images"]){
                    NSURL* url2=[NSURL URLWithString:url];
                    [urllist addObject:url2];
                }
                [returnValue setObject:urllist forKey:@"Images"];
            }
            else if([returnValue.allKeys containsObject:@"ImagePath"]){
                NSURL* url2=[NSURL URLWithString:[returnValue objectForKey:@"ImagePath"]];
                [returnValue setObject:url2 forKey:@"ImagePath"];
            }
        }
        
        return returnValue;
    }
}

@end
