//
//  FUComBoxTableRowView.m
//  LMComboBox
//
//  Created by 孙慕 on 2018/8/15.
//  Copyright © 2018年 Lemon Mojo. All rights reserved.
//

#import "FUComBoxTableRowView.h"
#define FUColor_HEX(hexValue) [NSColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
@implementation FUComBoxTableRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 0, 0);
        [FUColor_HEX(0x7787E9) setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:0 yRadius:0];
        [selectionPath fill];
    }
}

//
////绘制背景
//-(void)drawBackgroundInRect:(NSRect)dirtyRect{
//    [super drawBackgroundInRect:dirtyRect];
//    [[NSColor greenColor]setFill];
//    NSRectFill(dirtyRect);
//}







@end
