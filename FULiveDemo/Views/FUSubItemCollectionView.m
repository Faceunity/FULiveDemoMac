//
//  FUSubItemCollectionView.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/8/23.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSubItemCollectionView.h"

@implementation FUSubItemCollectionView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)keyDown:(NSEvent *)event{
    NSLog(@"键盘事件1");
}

- (void)keyUp:(NSEvent *)event{
    NSLog(@"键盘事件2");
}

@end
