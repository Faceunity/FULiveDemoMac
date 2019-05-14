//
//  FUNavBarView.m
//  FULive
//
//  Created by 孙慕 on 2018/7/27.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUNavBarView.h"

#import "FUConstManager.h"

@implementation FUNavBarView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{
    [self setWantsLayer:YES];
    self.layer.backgroundColor = FUConstManager.colorForBackground_nav.CGColor;
}

@end
