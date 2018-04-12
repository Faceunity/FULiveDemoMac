//
//  FUHeaderView.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUHeaderView.h"

@implementation FUHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        self.wantsLayer = YES;
//        self.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.3].CGColor;
//        [self setNeedsDisplay:YES];
        
    }
    return self;
}

- (void)viewDidMoveToWindow{
    [super viewDidMoveToWindow];
    
    self.nameLabel.textColor = [NSColor whiteColor];
}
@end
