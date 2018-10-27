//
//  WCiTunesLyrics.m
//  WallpaperKit
//
//  Created by Naville Zhang on 19/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKiTunesLyrics.h"
#import "SLColorArt.h"
#import "WKOcclusionStateWindow.h"
#import <CoreImage/CoreImage.h>
@implementation WKiTunesLyrics {
        NSTextView *titleView;
        NSTextView *translatedView;
        NSTextView *pronounceView;
        NSTextView *ID3View;
        iTunesApplication *iTunes;
        LyricManager *LM;
        Lyric *lrcADT;
        Lyric *translatedADT;
        Lyric *proADT;
        NSImageView *coverView;
        NSThread *refreshLRCThread;
        NSObject *synchroToken2;
        WKConfigurationManager *WKCM;
        NSString *TitleTemplate;
        NSString *LRCTemplate;
        NSString *TranslatedTemplate;
        NSString *PronounceTemplate;
        SLColorArt *SLCA;
        CGFloat coverBlurNumber;
        BOOL UseHTMLTemplate;
        BOOL FitCoverImageToScreen;
}
- (instancetype)initWithWindow:(WKDesktop *)window
                  andArguments:(NSDictionary *)args {
        NSRect frame = window.contentView.frame;
        self = [super initWithFrame:frame];
        CGFloat width = frame.size.width / 3;
        CGFloat height = frame.size.height / 8;
        CGFloat originX = frame.size.width / 3;
        self->pronounceView = [[NSTextView alloc]
            initWithFrame:NSMakeRect(originX, height, width, height)];
        self->translatedView = [[NSTextView alloc]
            initWithFrame:NSMakeRect(originX, 2.5 * height, width, height)];
        self->ID3View = [[NSTextView alloc]
            initWithFrame:NSMakeRect(originX, 4 * height, width, height)];
        self->titleView = [[NSTextView alloc]
            initWithFrame:NSMakeRect(originX, 5.5 * height, width, height)];
        for (NSTextView *tv in @[
                     self->titleView, self->translatedView, self->pronounceView,
                     self->ID3View
             ]) {
                [tv setBackgroundColor:[NSColor clearColor]];
                [self addSubview:tv];
        }
        self->coverView = [[NSImageView alloc] initWithFrame:window.frame];
        self->coverView.imageScaling = NSImageScaleProportionallyDown;
        [self addSubview:self->coverView
              positioned:NSWindowBelow
              relativeTo:self->titleView];
        self.requiresConsistentAccess = NO;
        self->LM = [LyricManager sharedManager];
        self->WKCM = [WKConfigurationManager sharedInstance];
        self->iTunes =
            [SBApplication applicationWithBundleIdentifier:@"com.apple.itunes"];

        // Init Sync Tokens
        self->synchroToken2 = [NSObject new];
        // Load From Configuration
        [self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"SongMatchRules"
                                    andConfiguration:
                                        [NSArray arrayWithObjects:
                                                     @"%SONG% %ALBUM%",
                                                     @"%SONG% %ARTIST%",
                                                     @"%SONG% %ALBUMARTIST%",
                                                     nil]
                                                type:READWRITE]; // Set rules up
                                                                 // for Search
                                                                 // Plugins
        self->UseHTMLTemplate = [[self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"UseHTMLTemplate"
                                    andConfiguration:[NSNumber
                                                         numberWithBool:NO]
                                                type:READWRITE] boolValue];
        self->LRCTemplate = [self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"LRCTemplate"
                                    andConfiguration:
                                        [[NSString alloc]
                                            initWithData:
                                                [[NSData alloc]
                                                    initWithBase64EncodedString:
                                                        @"PCFET0NUWVBFIGh0bWw+"
                                                        @"DQo8aHRtbCBsYW5nPSJlb"
                                                        @"iI+DQoJPGhlYWQ+"
                                                        @"DQoJCTxtZXRhIGNoYXJzZ"
                                                        @"XQ9IlVURi04IiAvPg0KCT"
                                                        @"wvaGVhZD4NCgk8Ym9keT4"
                                                        @"NCiAgICA8cCBzdHlsZT0i"
                                                        @"Y29sb3I6cmVkIj4lTFlSS"
                                                        @"UMlPC9wPg0KCTwvYm9keT"
                                                        @"4NCjwvaHRtbD4NCg=="
                                                                        options:
                                                                            NSDataBase64DecodingIgnoreUnknownCharacters]
                                                encoding:NSUTF8StringEncoding]
                                                type:READWRITE];
        self->TranslatedTemplate = [self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"TranslatedTemplate"
                                    andConfiguration:
                                        [[NSString alloc]
                                            initWithData:
                                                [[NSData alloc]
                                                    initWithBase64EncodedString:
                                                        @"PCFET0NUWVBFIGh0bWw+"
                                                        @"DQo8aHRtbCBsYW5nPSJlb"
                                                        @"iIgY2xhc3M9Im5vLWpzIj"
                                                        @"4NCgk8aGVhZD4NCgkJPG1"
                                                        @"ldGEgY2hhcnNldD0iVVRG"
                                                        @"LTgiIC8+"
                                                        @"DQogICAgPHN0eWxlPg0KI"
                                                        @"CAgICAgICAjQ29udGV4dC"
                                                        @"B7DQogICAgICAgICAgICB"
                                                        @"jb2xvcjogYmx1ZTsNCiAg"
                                                        @"ICAgICAgfQ0KICAgIDwvc"
                                                        @"3R5bGU+"
                                                        @"DQoJPC9oZWFkPg0KCTxib"
                                                        @"2R5Pg0KICA8ZGl2IGlkPS"
                                                        @"JDb250ZXh0Ij4NCiAgICA"
                                                        @"8c3Ryb25nPiVUUkFOU0xB"
                                                        @"VEVEJTwvc3Ryb25nPg0KI"
                                                        @"CA8L2Rpdj4NCg0KCTwvYm"
                                                        @"9keT4NCjwvaHRtbD4NCg="
                                                        @"="
                                                                        options:
                                                                            NSDataBase64DecodingIgnoreUnknownCharacters]
                                                encoding:NSUTF8StringEncoding]
                                                type:READWRITE];

        self->PronounceTemplate = [self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"PronounceTemplate"
                                    andConfiguration:
                                        [[NSString alloc]
                                            initWithData:
                                                [[NSData alloc]
                                                    initWithBase64EncodedString:
                                                        @"PCFET0NUWVBFIGh0bWw+"
                                                        @"DQo8aHRtbCBsYW5nPSJlb"
                                                        @"iIgY2xhc3M9Im5vLWpzIj"
                                                        @"4NCgk8aGVhZD4NCgkJPG1"
                                                        @"ldGEgY2hhcnNldD0iVVRG"
                                                        @"LTgiIC8+"
                                                        @"DQogICAgPHN0eWxlPg0KI"
                                                        @"CAgICAgICAjQ29udGV4dC"
                                                        @"B7DQogICAgICAgICAgICB"
                                                        @"jb2xvcjogYmx1ZTsNCiAg"
                                                        @"ICAgICAgfQ0KICAgIDwvc"
                                                        @"3R5bGU+"
                                                        @"DQoJPC9oZWFkPg0KCTxib"
                                                        @"2R5Pg0KICA8ZGl2IGlkPS"
                                                        @"JDb250ZXh0Ij4NCiAgICA"
                                                        @"8c3Ryb25nPiVQUk9OT1VO"
                                                        @"Q0UlPC9zdHJvbmc+"
                                                        @"DQogIDwvZGl2Pg0KDQoJP"
                                                        @"C9ib2R5Pg0KPC9odG1sPg"
                                                        @"0K"
                                                                        options:
                                                                            NSDataBase64DecodingIgnoreUnknownCharacters]
                                                encoding:NSUTF8StringEncoding]
                                                type:READWRITE];
        self->TitleTemplate = [self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"TitleTemplate"
                                    andConfiguration:
                                        [[NSString alloc]
                                            initWithData:
                                                [[NSData alloc]
                                                    initWithBase64EncodedString:
                                                        @"PCFET0NUWVBFIGh0bWw+"
                                                        @"DQo8aHRtbCBsYW5nPSJlb"
                                                        @"iIgY2xhc3M9Im5vLWpzIj"
                                                        @"4NCgk8aGVhZD4NCgkJPG1"
                                                        @"ldGEgY2hhcnNldD0iVVRG"
                                                        @"LTgiIC8+"
                                                        @"DQogICAgPHN0eWxlPg0KI"
                                                        @"CAgICAgICAjQ29udGV4dC"
                                                        @"B7DQogICAgICAgICAgICB"
                                                        @"jb2xvcjogYmx1ZTsNCiAg"
                                                        @"ICAgICAgfQ0KICAgIDwvc"
                                                        @"3R5bGU+"
                                                        @"DQoJPC9oZWFkPg0KCTxib"
                                                        @"2R5Pg0KICA8ZGl2IGlkPS"
                                                        @"JDb250ZXh0Ij4NCiAgICA"
                                                        @"8cCBzdHlsZT0iY29sb3I6"
                                                        @"cmVkIj48c3Ryb25nPiVTT"
                                                        @"05HTkFNRSU8L3N0cm9uZz"
                                                        @"48L3A+"
                                                        @"DQogICAgPHAgc3R5bGU9I"
                                                        @"mNvbG9yOnJlZCI+"
                                                        @"PHN0cm9uZz4lQVJUSVNUT"
                                                        @"kFNRSU8L3N0cm9uZz48L3"
                                                        @"A+"
                                                        @"DQogICAgPHAgc3R5bGU9I"
                                                        @"mNvbG9yOnJlZCI+"
                                                        @"PHN0cm9uZz4lQUxCVU1OQ"
                                                        @"U1FJTwvc3Ryb25nPjwvcD"
                                                        @"4NCiAgPC9kaXY+"
                                                        @"DQoNCgk8L2JvZHk+"
                                                        @"DQo8L2h0bWw+DQo="
                                                                        options:
                                                                            NSDataBase64DecodingIgnoreUnknownCharacters]
                                                encoding:NSUTF8StringEncoding]
                                                type:READWRITE];
        self->coverBlurNumber = [[self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"CoverBlurNumber"
                                    andConfiguration:[NSNumber
                                                         numberWithFloat:4]
                                                type:READWRITE] floatValue];
        self->FitCoverImageToScreen = [[self->WKCM
            GetOrSetPersistentConfigurationForRender:@"WKiTunesLyrics"
                                                 Key:@"FitCoverImageToScreen"
                                    andConfiguration:[NSNumber
                                                         numberWithBool:YES]
                                                type:READWRITE] boolValue];
        self.requiresExclusiveBackground = NO;
        self.requiresConsistentAccess = NO;
        self.arg=args;
    if (@available(macOS 10.14, *)) {
            NSAppleEventDescriptor *targetAppEventDescriptor=[NSAppleEventDescriptor descriptorWithBundleIdentifier:@"com.apple.iTunes"];
        OSStatus status=AEDeterminePermissionToAutomateTarget(targetAppEventDescriptor.aeDesc,typeWildCard, typeWildCard, true);
        if(status!=0){
            @throw [NSException exceptionWithName:@"PermissionDeniedException" reason:[NSString stringWithFormat:@"AppleEventStatusCode:%i",status] userInfo:nil];
        }
    } 
    
        return self;
}

- (void)play {
        [self updateInfo];
        [[NSDistributedNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(watchiTunes:)
                   name:@"com.apple.iTunes.playerInfo"
                 object:@"com.apple.iTunes.player"];
        self->refreshLRCThread =
            [[NSThread alloc] initWithTarget:self
                                    selector:@selector(refreshLyrics)
                                      object:nil];
        [self->refreshLRCThread start];
}
- (void)pause {
        [self->refreshLRCThread cancel];
        [[NSDistributedNotificationCenter defaultCenter]
            removeObserver:self
                      name:@"com.apple.iTunes.playerInfo"
                    object:@"com.apple.iTunes.player"];
}
- (void)dealloc {
        [self pause];
}
- (void)refreshLyrics {
        while ([NSThread currentThread].isCancelled == NO) {
                [NSThread
                    sleepForTimeInterval:
                        [[self->WKCM
                            GetOrSetPersistentConfigurationForRender:
                                @"WKiTunesLyrics"
                                                                 Key:@"iTunesPo"
                                                                     @"llingInt"
                                                                     @"erval"
                                                    andConfiguration:
                                                        [NSNumber
                                                            numberWithFloat:0.5]
                                                                type:READWRITE]
                            floatValue]];
                        if (lrcADT == nil && translatedADT == nil &&
                            proADT == nil) {
                                [self updateLyricADT];
                        }
                        if (self->UseHTMLTemplate) {
                                [self refreshLyricsWithHTML];
                        } else {
                                [self refreshLyricsWithSCLA];
                        }

        }
}
- (void)refreshLyricsWithSCLA {
        @autoreleasepool {
                double location=iTunes.playerPosition;
                NSMutableAttributedString *TranslatedString = [
                    [NSMutableAttributedString alloc]
                    initWithString:[translatedADT
                                       nextLinewithTime:location]];
                NSMutableAttributedString *ProString = [
                    [NSMutableAttributedString alloc]
                    initWithString:[proADT
                                       nextLinewithTime:location]];
                NSMutableAttributedString *ID3String = [
                    [NSMutableAttributedString alloc]
                    initWithString:[lrcADT
                                       nextLinewithTime:location]];

                // Reuse Other Colors To Avoid Using Default Black Color
                NSMutableArray *ColorArray =
                    [NSMutableArray arrayWithCapacity:3];
                NSArray *NameStringArray =
                    @[ TranslatedString, ProString, ID3String ];
                for (NSColor *col in @[
                             self->SLCA.primaryColor, self->SLCA.secondaryColor,
                             self->SLCA.detailColor
                     ]) {
                        if (![col isEqualTo:[NSColor blackColor]]) {
                                [ColorArray addObject:col];
                        }
                }
                for (int i = 0; i < NameStringArray.count; i++) {
                        NSMutableAttributedString *attriStr =
                            [NameStringArray objectAtIndex:i];
                        NSColor *col = ColorArray[i % ColorArray.count];
                        [attriStr addAttribute:NSForegroundColorAttributeName
                                         value:col
                                         range:NSMakeRange(0, attriStr.length)];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self->pronounceView.textStorage
                      setAttributedString:ProString];
                  [self->translatedView.textStorage
                      setAttributedString:TranslatedString];
                  [self->ID3View.textStorage setAttributedString:ID3String];
                });
        }
}
- (void)refreshLyricsWithHTML {
        double location=iTunes.playerPosition;
        NSString *LRCHTML = [self->LRCTemplate
            stringByReplacingOccurrencesOfString:@"%LYRIC%"
                                      withString:[lrcADT
                                                     nextLinewithTime:
                                                         location]];
        NSString *TranslatedHTML = [TranslatedTemplate
            stringByReplacingOccurrencesOfString:@"%TRANSLATED%"
                                      withString:[translatedADT
                                                     nextLinewithTime:
                                                         location]];
        NSString *PronounceHTML = [PronounceTemplate
            stringByReplacingOccurrencesOfString:@"%PRONOUNCE%"
                                      withString:[proADT
                                                     nextLinewithTime:
                                                         location]];

        NSMutableAttributedString *LRCAString = [
            [NSMutableAttributedString alloc]
                  initWithData:[LRCHTML dataUsingEncoding:NSUTF8StringEncoding]
                       options:@{
                               NSDocumentTypeDocumentAttribute :
                                   NSHTMLTextDocumentType
                       }
            documentAttributes:nil
                         error:nil];
        NSMutableAttributedString *PROAString =
            [[NSMutableAttributedString alloc]
                      initWithHTML:[PronounceHTML
                                       dataUsingEncoding:NSUTF8StringEncoding]
                documentAttributes:nil];
        NSMutableAttributedString *TransAString =
            [[NSMutableAttributedString alloc]
                      initWithHTML:[TranslatedHTML
                                       dataUsingEncoding:NSUTF8StringEncoding]
                documentAttributes:nil];
        for (NSMutableAttributedString *AS in
             @[ LRCAString, PROAString, TransAString ]) {
                [AS setAlignment:NSTextAlignmentCenter
                           range:NSMakeRange(0, AS.length)];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
          [self->pronounceView.textStorage setAttributedString:PROAString];
          [self->ID3View.textStorage setAttributedString:LRCAString];
          [self->translatedView.textStorage setAttributedString:TransAString];
        });
}
- (void)handleCoverChange {
        @autoreleasepool {

                  NSData *coverImage = [(iTunesArtwork *)[
                      [iTunes.currentTrack artworks] objectAtIndex:0] rawData];
                  NSImage *blurredImage =
                      [self coreBlurImage:coverImage
                           withBlurNumber:self->coverBlurNumber];
                  self->SLCA = [SLColorArt colorArtWithImage:blurredImage
                                                  scaledSize:NSZeroSize];
                  if (self->SLCA.backgroundColor != nil) {
                          [self.window
                              setBackgroundColor:self->SLCA.backgroundColor];
                  } else {
                          [self.window setBackgroundColor:[NSColor clearColor]];
                  }
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [self->coverView setImage:blurredImage];
                    NSRect currentRect = self->coverView.frame;
                    if (self->FitCoverImageToScreen) {
                            currentRect = self.window.frame;
                    } else {
                            currentRect.size =
                                blurredImage.size; // Stretch to full screen
                    }
                    [self->coverView setFrame:currentRect];

                    [self->coverView
                        setFrameOrigin:NSMakePoint(
                                           (NSWidth([self bounds]) -
                                            NSWidth([self->coverView frame])) /
                                               2,
                                           (NSHeight([self bounds]) -
                                            NSHeight([self->coverView frame])) /
                                               2)];
                  });
        }
}
- (void)updateLyricADT {
        @autoreleasepool {
                iTunesTrack *track = iTunes.currentTrack;
                NSDictionary *queryDict =
                    [[LyricManager sharedManager] exportLyric:@{
                            @"Artist" : track.artist,
                            @"Song" : track.name,
                            @"Album" : track.album,
                            @"AlbumArtist" : track.albumArtist
                    }];
                lrcADT = [[Lyric alloc]
                    initWithLRC:[queryDict objectForKey:@"Lyric"]];
                translatedADT = [[Lyric alloc]
                    initWithLRC:[queryDict objectForKey:@"Translated"]];
                proADT = [[Lyric alloc]
                    initWithLRC:[queryDict objectForKey:@"Pronounce"]];
        }
}

- (NSImage *)coreBlurImage:(NSData *)imagedata withBlurNumber:(CGFloat)blur {
        if (blur <= 0) {

                NSImage *img = [[NSImage alloc] initWithData:imagedata];
                CGImageRef cgImage =
                    [img CGImageForProposedRect:nil context:nil hints:nil];
                img.size = NSMakeSize(CGImageGetWidth(cgImage),
                                      CGImageGetHeight(cgImage));
                return img;
        }
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithData:imagedata];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:@(blur) forKey:@"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef outImage =
            [context createCGImage:result fromRect:[result extent]];
        NSImage *blurImage =
            [[NSImage alloc] initWithCGImage:outImage
                                        size:[result extent].size];
        CGImageRelease(outImage);
        return blurImage;
}
- (NSMutableAttributedString *)generateSongTitle {
        @autoreleasepool {
                if (self->UseHTMLTemplate) {
                        NSString *TitleTemplateHTML = [TitleTemplate
                            stringByReplacingOccurrencesOfString:@"%SONGNAME%"
                                                      withString:
                                                          iTunes.currentTrack
                                                              .name];
                        TitleTemplateHTML = [TitleTemplateHTML
                            stringByReplacingOccurrencesOfString:@"%ALBUMNAME%"
                                                      withString:
                                                          iTunes.currentTrack
                                                              .album];
                        TitleTemplateHTML = [TitleTemplateHTML
                            stringByReplacingOccurrencesOfString:@"%ARTISTNAME%"
                                                      withString:
                                                          iTunes.currentTrack
                                                              .artist];

                        NSMutableAttributedString *title =
                            [[NSMutableAttributedString alloc]
                                      initWithHTML:[TitleTemplateHTML
                                                       dataUsingEncoding:
                                                           NSUTF8StringEncoding]
                                documentAttributes:nil];
                        NSMutableParagraphStyle *paragraphStyle =
                            NSMutableParagraphStyle.new;
                        paragraphStyle.alignment = NSTextAlignmentCenter;
                        [title addAttribute:NSParagraphStyleAttributeName
                                      value:paragraphStyle
                                      range:NSMakeRange(0, title.length)];
                        return title;
                } else {

                        NSMutableAttributedString *SongName = [
                            [NSMutableAttributedString alloc]
                            initWithString:
                                [NSString
                                    stringWithFormat:@"%@\n",
                                                     iTunes.currentTrack.name]];
                        NSMutableAttributedString *AlbumName = [
                            [NSMutableAttributedString alloc]
                            initWithString:[NSString
                                               stringWithFormat:
                                                   @"%@\n",
                                                   iTunes.currentTrack.album]];
                        NSMutableAttributedString *ArtistName = [
                            [NSMutableAttributedString alloc]
                            initWithString:[NSString
                                               stringWithFormat:
                                                   @"%@\n",
                                                   iTunes.currentTrack.artist]];

                        // Reuse Other Colors To Avoid Using Default Black Color
                        NSMutableArray *ColorArray =
                            [NSMutableArray arrayWithCapacity:3];
                        NSArray *NameStringArray =
                            @[ SongName, AlbumName, ArtistName ];
                        for (NSColor *col in @[
                                     self->SLCA.primaryColor,
                                     self->SLCA.secondaryColor,
                                     self->SLCA.detailColor
                             ]) {
                                if (![col isEqualTo:[NSColor blackColor]]) {
                                        [ColorArray addObject:col];
                                }
                        }
                        for (int i = 0; i < NameStringArray.count; i++) {
                                NSMutableAttributedString *attriStr =
                                    [NameStringArray objectAtIndex:i];
                                NSColor *col = ColorArray[i % ColorArray.count];
                                [attriStr
                                    addAttribute:NSForegroundColorAttributeName
                                           value:col
                                           range:NSMakeRange(0,
                                                             attriStr.length)];
                        }

                        NSMutableAttributedString *retVal =
                            [[NSMutableAttributedString alloc]
                                initWithString:@""];
                        [retVal appendAttributedString:SongName];
                        [retVal appendAttributedString:AlbumName];
                        [retVal appendAttributedString:ArtistName];
                        return retVal;
                }
        }
}
- (void)handleSongTitle {
        @autoreleasepool {
                NSMutableAttributedString *title = [self generateSongTitle];
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self->titleView.textStorage setAttributedString:title];
                });
        }
}
- (void)updateInfo {
        [NSThread detachNewThreadWithBlock:^() {
            if(self->iTunes.isRunning){
                @synchronized(synchroToken2) {
                    @try{
                        [self handleCoverChange];
                        [self updateLyricADT];
                        [self handleSongTitle];
                    }
                    @catch(NSException* exp){
                        return;
                    }
                }
            }
        }];
}
- (void)watchiTunes:(NSNotification *)notif {

        [self performSelectorOnMainThread:@selector(updateInfo)
                               withObject:nil
                            waitUntilDone:NO];
}
- (BOOL)acceptsFirstResponder {
        return YES;
}
- (NSString *)description {
        return @"WKiTunesLyrics";
}
+ (NSMutableDictionary *)convertArgument:(NSDictionary *)args
                               Operation:(WKSerializeOption)op {
        if (op == TOJSON) {
                return [NSMutableDictionary
                    dictionaryWithDictionary:@{@"Render" : @"WKiTunesLyrics"}];
        } else {
                return [NSMutableDictionary dictionaryWithDictionary:@{
                        @"Render" : [WKiTunesLyrics class]
                }];
        }
}
@end
