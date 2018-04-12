//
//  FUFooterView.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/13.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUFooterView.h"

@interface FUFooterView ()
@property (nonatomic, weak) IBOutlet NSView *lineView;
@end

@implementation FUFooterView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        self.wantsLayer = YES;
//        self.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:1.0].CGColor;
//        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)setLineView:(NSView *)lineView{
    _lineView = lineView;
    lineView.wantsLayer = YES;
    lineView.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:1.0].CGColor;
    [lineView setNeedsDisplay:YES];
}
@end
