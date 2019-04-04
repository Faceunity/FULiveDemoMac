//
//  AppDelegate.m
//  FULive
//
//  Created by 孙慕 on 2018/7/26.
//  Copyright © 2018年 孙慕. All rights reserved.
//

#import "AppDelegate.h"
#import "FUMasterViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) IBOutlet FUMasterViewController *masterViewController;
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
