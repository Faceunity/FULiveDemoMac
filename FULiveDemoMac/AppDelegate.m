//
//  AppDelegate.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<NSWindowDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    [sender terminate:nil];
    return YES;
}

@end
