//
//  FUSplitViewController.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/9.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSplitViewController.h"

@interface FUSplitViewController ()

@end

@implementation FUSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.splitViewItems.lastObject.minimumThickness = 250;
    self.splitViewItems.lastObject.maximumThickness = 250;

    NSTabViewController *tabViewController = self.childViewControllers.lastObject;
    tabViewController.view.wantsLayer = YES;
    tabViewController.view.layer.backgroundColor = [NSColor colorWithWhite:0.4 alpha:1].CGColor;

}

@end
