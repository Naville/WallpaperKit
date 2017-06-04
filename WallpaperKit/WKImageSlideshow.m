//
//  WKImageSlideshow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKImageSlideshow.h"
#import <dlfcn.h>
@implementation WKImageSlideshow{
    NSArray<NSURL*>* ImageURLList;
    unsigned int interval;
    NSString* descript;
    NSTimer* tim;
    NSUInteger index;
    NSObject* syncToken;
    dispatch_source_t src;
    int FolderFD;
    BOOL isPlaying;
    NSURLResourceKey SortKey;
}
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    srand(time(NULL));
    NSError* error;
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setBackgroundColor:[NSColor blackColor]];
    self->SortKey=[args objectForKey:@"SortingKey"];
    if([args.allKeys containsObject:@"ImageScaling"]){
        [self setImageScaling:[(NSNumber*)[args objectForKey:@"ImageScaling"] unsignedIntegerValue]];
    }
    else{
        [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    }
    self->ImageURLList=[args objectForKey:@"Images"];
    
    
    if(self->ImageURLList==nil){
        self->descript=[@"ImagePath: " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  path]];
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:@[self->SortKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        [self sortFileList];
        
        self->FolderFD=open([[[args objectForKey:@"ImagePath"] path] fileSystemRepresentation],O_EVTONLY);
        self->src = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, FolderFD, DISPATCH_VNODE_WRITE, dispatch_queue_create([[@"WKImageSlideShowFolderQueue " stringByAppendingString:[(NSURL*)[args objectForKey:@"ImagePath"]  path]] UTF8String], 0));
        
        // call the passed block if the source is modified
        dispatch_source_set_event_handler(self->src,^(){
            self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:@[self->SortKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
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
    self->isPlaying=NO;
    self.requiresConsistentAccess=NO;
    self.requiresExclusiveBackground=YES;
    return self;
}
-(void)play{
    if(self->isPlaying==YES){
        return;
    }
    self->isPlaying=YES;
    self->tim=[NSTimer scheduledTimerWithTimeInterval:self->interval repeats:YES block:^(NSTimer* tim){
        if(self->tim.isValid==NO){
            return ;
        }
        if([self->SortKey isEqualToString:@"Random"]){
            [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[arc4random() % [ImageURLList count]]] waitUntilDone:YES];
            [self setNeedsDisplay];
        }else{
            [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:YES];
            [self setNeedsDisplay];
            index=(index+1)%ImageURLList.count;
        }
    }];
}
-(void)pause{
    if(self->isPlaying==NO){
        return ;
    }
    self->isPlaying=NO;
    [self->tim invalidate];
}

-(void)sortFileList{
    @autoreleasepool {
        if(self->SortKey==nil||[self->SortKey isEqualToString:@"Random"]){
            //Leave Randomize in Loading Subroutine for maximum performance
            return;
        }

        self->ImageURLList=[self->ImageURLList sortedArrayUsingComparator:
                                ^(NSURL *file1, NSURL *file2)
                                {
                                    // compare
                                    id val1,val2;
                                    [file1 getResourceValue:&val1 forKey:self->SortKey error:nil];
                                    [file2 getResourceValue:&val2 forKey:self->SortKey error:nil];
                                    return [val1 compare: val2];
                                }];
    }
}
-(NSString*)description{
    if(self->descript==nil){
        self->descript=self->ImageURLList[0].path;
    }
    return [@"WKImageSlideshow " stringByAppendingString:self->descript];
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
