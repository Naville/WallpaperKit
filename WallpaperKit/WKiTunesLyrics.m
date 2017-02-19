//
//  WCiTunesLyrics.m
//  WallpaperKit
//
//  Created by Naville Zhang on 19/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKiTunesLyrics.h"
#import <CoreImage/CoreImage.h>
@implementation WKiTunesLyrics{
    NSTextView *titleView;
    NSTextView *translatedView;
    NSTextView *pronounceView;
    NSTextView *ID3View;
    iTunesApplication *iTunes;
    LyricManager *LM;
    double currentPosition;
    Lyric *lrcADT;
    Lyric *translatedADT;
    Lyric *proADT;
    iTunesTrack *lyricBasedSong;
    NSImageView *coverView;
}
-(instancetype)initWithWindow:(WKDesktop *)window andArguments:(NSDictionary *)args{
    self=[super initWithFrame:window.frame];
    CGFloat width=window.frame.size.width/3;
    CGFloat height=window.frame.size.height/8;
    CGFloat originX=window.frame.size.width/3;
    self->pronounceView=[[NSTextView alloc] initWithFrame:NSMakeRect(originX, height, width, height)];
    self->translatedView=[[NSTextView alloc] initWithFrame:NSMakeRect(originX, 2.5*height, width, height)];
    self->ID3View=[[NSTextView alloc] initWithFrame:NSMakeRect(originX, 4*height, width, height)];
    self->titleView=[[NSTextView alloc] initWithFrame:NSMakeRect(originX, 5.5*height, width, height)];
    for(NSTextView* tv in @[self->titleView,self->translatedView,self->pronounceView,self->ID3View]){
        [tv setBackgroundColor:[NSColor clearColor]];
        [self addSubview:tv];
    }
    self.requiresConsistentAccess=NO;
    self->LM=[LyricManager sharedManager];
    self->currentPosition=0;
    self->iTunes=[SBApplication applicationWithBundleIdentifier:@"com.apple.itunes"];
    [window setBackgroundColor:[NSColor clearColor]];
    [self.layer setBackgroundColor:[NSColor clearColor].CGColor];
    return self;
}
-(void)play{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(watchiTunes:) name:@"com.apple.iTunes.playerInfo" object:@"com.apple.iTunes.player"];
    [self updateInfo];
    [self refreshLyrics];
    [self foo];
}
-(void)pause{
    
}
-(void)refreshLyrics{
    @autoreleasepool {
        iTunesTrack* track=iTunes.currentTrack;
        currentPosition=iTunes.playerPosition;
        NSDictionary* queryDict=[[LyricManager sharedManager] exportLyric:@{@"Artist":track.artist,@"Song":track.name,@"Album":track.album,@"AlbumArtist":track.albumArtist}];
        if(![lyricBasedSong isEqualTo:iTunes.currentTrack]){//NewSong. Update Cached Lyrics ADT
            lrcADT=[[Lyric alloc] initWithLRC:[queryDict objectForKey:@"Lyric"]];
            translatedADT=[[Lyric alloc] initWithLRC:[queryDict objectForKey:@"Translated"]];
            proADT=[[Lyric alloc] initWithLRC:[queryDict objectForKey:@"Pronounce"]];
        }
        NSString* LRCTemplate=[[Utils sharedManager].ViewRenderTemplates  objectForKey:@"Lyric"];
        NSString* TranslatedTemplate=[[Utils sharedManager].ViewRenderTemplates  objectForKey:@"Translated"];
        NSString* PronounceTemplate=[[Utils sharedManager].ViewRenderTemplates  objectForKey:@"Pronounce"];
        LRCTemplate=[LRCTemplate stringByReplacingOccurrencesOfString:@"%LYRIC%" withString:[lrcADT nextLinewithTime:iTunes.playerPosition]];
        TranslatedTemplate=[TranslatedTemplate stringByReplacingOccurrencesOfString:@"%TRANSLATED%" withString:[translatedADT nextLinewithTime:iTunes.playerPosition]];
        PronounceTemplate=[PronounceTemplate stringByReplacingOccurrencesOfString:@"%PRONOUNCE%" withString:[proADT nextLinewithTime:iTunes.playerPosition]];
        
        NSMutableAttributedString* LRCAString=[[NSMutableAttributedString alloc]
                                               initWithData:[LRCTemplate dataUsingEncoding:NSUTF8StringEncoding]
                                               options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                               documentAttributes:nil error:nil];
        NSMutableAttributedString* PROAString=[[NSMutableAttributedString alloc] initWithHTML:[PronounceTemplate dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        NSMutableAttributedString* TransAString=[[NSMutableAttributedString alloc] initWithHTML:[TranslatedTemplate dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        for(NSMutableAttributedString* AS in @[LRCAString,PROAString,TransAString]){
            [AS setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, AS.length)];
        }
        
        [self->pronounceView.textStorage setAttributedString:PROAString];
        [self->ID3View.textStorage setAttributedString:LRCAString];
        [self->translatedView.textStorage setAttributedString:TransAString];
    }
    
    
}
-(void)handleCoverChange{
    @autoreleasepool {
        NSData* coverImage=[(iTunesArtwork *)[[iTunes.currentTrack artworks] objectAtIndex:0] rawData];
        NSImage* blurredImage=[self coreBlurImage:coverImage withBlurNumber:0 andSize:CGSizeMake(1200, 1200)];
        [self->coverView removeFromSuperview];
        self->coverView=nil;
        self->coverView=[NSImageView imageViewWithImage:blurredImage];
        [self->coverView setFrame:NSMakeRect(0, 0, blurredImage.size.width, blurredImage.size.height)];
        [self->coverView setFrameOrigin:NSMakePoint((NSWidth([self bounds]) - NSWidth([self->coverView frame])) / 2,
                                                    (NSHeight([self bounds]) - NSHeight([self->coverView frame])) / 2
                                                    )];
        [self addSubview:self->coverView positioned:NSWindowBelow relativeTo:self->titleView];
        [self needsLayout];
    }
}

-(NSImage *)coreBlurImage:(NSData *)imagedata withBlurNumber:(CGFloat)blur andSize:(CGSize)size
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithData:imagedata];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    NSImage *blurImage=[[NSImage alloc] initWithCGImage:outImage size:[result extent].size];
    CGImageRelease(outImage);
    return blurImage;
}
-(NSMutableAttributedString*)generateSongTitle{
    NSString* TitleTemplate=[[Utils sharedManager].ViewRenderTemplates objectForKey:@"Title"];
    TitleTemplate=[TitleTemplate stringByReplacingOccurrencesOfString:@"%SONGNAME%" withString:iTunes.currentTrack.name];
    TitleTemplate=[TitleTemplate stringByReplacingOccurrencesOfString:@"%ALBUMNAME%" withString:iTunes.currentTrack.album];
    TitleTemplate=[TitleTemplate stringByReplacingOccurrencesOfString:@"%ARTISTNAME%" withString:iTunes.currentTrack.artist];
    
    NSMutableAttributedString* title=[[NSMutableAttributedString alloc] initWithHTML:[TitleTemplate dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    [title addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    return title;
}
-(void)handleSongTitle{
    NSMutableAttributedString* title=[self generateSongTitle];
    [self->titleView.textStorage setAttributedString:title];
}
-(void)foo{
    [NSThread detachNewThreadWithBlock:^(){
        while(true){
            sleep(1);
            [self performSelectorOnMainThread:@selector(refreshLyrics) withObject:nil waitUntilDone:YES];
        }
    }];
}
-(void)updateInfo{
    [self performSelectorOnMainThread:@selector(handleCoverChange) withObject:nil waitUntilDone:YES];
    //[self performSelectorOnMainThread:@selector(refreshLyrics) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(handleSongTitle) withObject:nil waitUntilDone:YES];
}
-(void)watchiTunes:(NSNotification*)notif{
    
    [self performSelectorOnMainThread:@selector(updateInfo) withObject:nil waitUntilDone:YES];
    
}
-(NSString*)description{
    return @"WKiTunesLyrics";
}
@end
