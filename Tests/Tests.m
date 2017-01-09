//
//  Tests.m
//  Tests
//
//  Created by Naville Zhang on 2017/1/8.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WKDesktop.h"
#import "WKWindow.h"
#import "WKDesktopManager.h"
#import "WKVideoPlugin.h"
#import "WKWebpagePlugin.h"
@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*-(void)testVideo{
    [[WKDesktop new] renderWithEngine:[WKVideoPlugin class] withArguments:@{@"Path":@"/Users/Naville/Desktop/BackGroundVideos/1.mp4"}];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    NSLog(@"Displaying Video");
}*/
/*- (void)testStatic{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [[WKDesktop sharedInstance] setStaticImage:@"/Users/Naville/WallPaper/119a5e4828facc5f55a992cb27d4a4b25dd57241.jpg"];
     [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
     NSLog(@"Displaying Image");
}*/
/*-(void)testWebpage{
    [[WKDesktop new] renderWithEngine:[WKWebpagePlugin class] withArguments:@{@"Path":@"https://www.akb48.co.jp"}];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
}*/
/*-(void)testManager{
    [[WKWindow newFullScreenWindow] display];
    WKDesktopManager* wkm=[WKDesktopManager sharedInstance];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];

}*/
@end
