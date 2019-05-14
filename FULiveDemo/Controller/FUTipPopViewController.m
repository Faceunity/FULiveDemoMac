//
//  FUTipPopViewController.m
//  FULive
//
//  Created by 孙慕 on 2018/8/6.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUTipPopViewController.h"

@interface FUTipPopViewController ()
@property (weak) IBOutlet NSTextField *titleTextField;

@end

@implementation FUTipPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
}

@end
