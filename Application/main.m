//
//  main.m
//  Application
//
//  Created by Naville Zhang on 2017/1/10.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char *argv[]) {
        int pid_file = open("/tmp/WallpaperKitLock", O_CREAT | O_RDWR, 0666);
        int rc = flock(pid_file, LOCK_EX | LOCK_NB);
        if (rc) {
                if (EWOULDBLOCK == errno) {
                        NSLog(@"Another process is running");
                        exit(0);
                }
        }
        return NSApplicationMain(argc, argv);
}
