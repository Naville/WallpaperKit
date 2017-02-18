//
//  WKWebpagePlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKWebpagePlugin.h"

@implementation WKWebpagePlugin{
    NSURL* webURL;
    NSString* HTMLString;
    NSString* Javascript;
    NSString* description;
}

- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSRect frameRect=window.frame;
    WKWebViewConfiguration * config=[WKWebViewConfiguration new];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    config.userContentController=controller;
    
    
    self=[super initWithFrame:frameRect configuration:config];
    self->webURL=(NSURL*)[args objectForKey:@"Path"];
    self->HTMLString=(NSString*)[args objectForKey:@"HTML"];
    self->Javascript=(NSString*)[args objectForKey:@"Javascript"];
    if(webURL!=nil && HTMLString!=nil){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please Specify Either URL or HTML String." userInfo:args];
    }
    self->description=(webURL!=nil)?webURL.absoluteString:self->HTMLString;
    self.acceptsTouchEvents=YES;
    self.requiresConsistentAccess=NO;
    return self;
}
-(void)play{
    [self evaluateJavaScript:@"document.querySelector('body').innerHTML" completionHandler:^(id result, NSError *error) {
        if (!result || ([result isKindOfClass:[NSString class]] && [((NSString *)result) length] == 0)) {
            if(webURL!=nil){
                [self loadRequest:[NSURLRequest requestWithURL:self->webURL]];
            }
            else{
                [self loadHTMLString:HTMLString baseURL:nil];
            }
            
        }
        }];
    //From http://marcgrabanski.com/simulating-mouse-click-events-in-javascript/
    NSData* mouseHandler=[[NSData alloc] initWithBase64EncodedString:@"ZnVuY3Rpb24gbW91c2VFdmVudCh0eXBlLCBzeCwgc3ksIGN4LCBjeSkgew0KICB2YXIgZXZ0Ow0KICB2YXIgZSA9IHsNCiAgICBidWJibGVzOiB0cnVlLA0KICAgIGNhbmNlbGFibGU6ICh0eXBlICE9ICJtb3VzZW1vdmUiKSwNCiAgICB2aWV3OiB3aW5kb3csDQogICAgZGV0YWlsOiAwLA0KICAgIHNjcmVlblg6IHN4LA0KICAgIHNjcmVlblk6IHN5LA0KICAgIGNsaWVudFg6IGN4LA0KICAgIGNsaWVudFk6IGN5LA0KICAgIGN0cmxLZXk6IGZhbHNlLA0KICAgIGFsdEtleTogZmFsc2UsDQogICAgc2hpZnRLZXk6IGZhbHNlLA0KICAgIG1ldGFLZXk6IGZhbHNlLA0KICAgIGJ1dHRvbjogMCwNCiAgICByZWxhdGVkVGFyZ2V0OiB1bmRlZmluZWQNCiAgfTsNCiAgaWYgKHR5cGVvZiggZG9jdW1lbnQuY3JlYXRlRXZlbnQgKSA9PSAiZnVuY3Rpb24iKSB7DQogICAgZXZ0ID0gZG9jdW1lbnQuY3JlYXRlRXZlbnQoIk1vdXNlRXZlbnRzIik7DQogICAgZXZ0LmluaXRNb3VzZUV2ZW50KHR5cGUsDQogICAgICBlLmJ1YmJsZXMsIGUuY2FuY2VsYWJsZSwgZS52aWV3LCBlLmRldGFpbCwNCiAgICAgIGUuc2NyZWVuWCwgZS5zY3JlZW5ZLCBlLmNsaWVudFgsIGUuY2xpZW50WSwNCiAgICAgIGUuY3RybEtleSwgZS5hbHRLZXksIGUuc2hpZnRLZXksIGUubWV0YUtleSwNCiAgICAgIGUuYnV0dG9uLCBkb2N1bWVudC5ib2R5LnBhcmVudE5vZGUpOw0KICB9IGVsc2UgaWYgKGRvY3VtZW50LmNyZWF0ZUV2ZW50T2JqZWN0KSB7DQogICAgZXZ0ID0gZG9jdW1lbnQuY3JlYXRlRXZlbnRPYmplY3QoKTsNCiAgICBmb3IgKHByb3AgaW4gZSkgew0KICAgIGV2dFtwcm9wXSA9IGVbcHJvcF07DQogIH0NCiAgICBldnQuYnV0dG9uID0geyAwOjEsIDE6NCwgMjoyIH1bZXZ0LmJ1dHRvbl0gfHwgZXZ0LmJ1dHRvbjsNCiAgfQ0KICByZXR1cm4gZXZ0Ow0KfQ0KZnVuY3Rpb24gZGlzcGF0Y2hFdmVudCAoZWwsIGV2dCkgew0KICBpZiAoZWwuZGlzcGF0Y2hFdmVudCkgew0KICAgIGVsLmRpc3BhdGNoRXZlbnQoZXZ0KTsNCiAgfSBlbHNlIGlmIChlbC5maXJlRXZlbnQpIHsNCiAgICBlbC5maXJlRXZlbnQoJ29uJyArIHR5cGUsIGV2dCk7DQogIH0NCiAgcmV0dXJuIGV2dDsNCn0=" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [self evaluateJavaScript:[[NSString alloc] initWithData:mouseHandler encoding:NSUTF8StringEncoding] completionHandler:nil];
    if(self->Javascript!=nil){
        [self evaluateJavaScript:Javascript completionHandler:nil];
    }

   
}
-(void)mouseMoved:(NSEvent *)event{
    NSPoint location=[NSEvent mouseLocation];
    NSString* js=[NSString stringWithFormat:@"dispatchEvent(document,mouseEvent(\"mousemove\",%f,%f,%f,%f))",location.x,location.y,location.x,location.y];
    [super mouseMoved:event];
    [self evaluateJavaScript:js completionHandler:nil];
}
-(void)mouseDown:(NSEvent *)event{
    NSPoint location=[NSEvent mouseLocation];
    NSString* js=[NSString stringWithFormat:@"dispatchEvent(document,mouseEvent(\"mousedown\",%f,%f,%f,%f))",location.x,location.y,location.x,location.y];
    [super mouseDown:event];
    [self evaluateJavaScript:js completionHandler:nil];
}
- (void)mouseUp:(NSEvent *)event{
    NSPoint location=[NSEvent mouseLocation];
    NSString* js=[NSString stringWithFormat:@"dispatchEvent(document,mouseEvent(\"mouseup\",%f,%f,%f,%f))",location.x,location.y,location.x,location.y];
    [super mouseUp:event];
    [self evaluateJavaScript:js completionHandler:nil];
}
-(NSString*)description{
    return [@"WKWebpagePlugin " stringByAppendingString:self->description];
}
-(void)pause{
    
}
@end
