//
//  FUFilterItemsViewItem.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUFilterItemsViewItem.h"

@interface FUFilterItemsViewItem ()

@end

@implementation FUFilterItemsViewItem

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    //    self.view.layer.backgroundColor = selected ? [NSColor whiteColor].CGColor:[NSColor colorWithWhite:0.0 alpha:0.0].CGColor;
    self.imageView.layer.borderWidth = selected ? 3.0:0.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.0].CGColor;
    [self.view setNeedsDisplay:YES];
    
    self.imageView.wantsLayer = YES;
    self.imageView.layer.borderWidth = 0.0;
    self.imageView.layer.borderColor = [NSColor colorWithRed:72 / 255.0 green:148 / 255.0 blue:252 / 249.0 alpha:1.0].CGColor;
    [self.imageView setNeedsDisplay:YES];
}

@end
