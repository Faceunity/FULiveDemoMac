//
//  FUSliderCell.m
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSliderCell.h"

@implementation FUSliderCell


- (void)drawBarInside:(NSRect)rect flipped:(BOOL)flipped {
    
    //  [super drawBarInside:rect flipped:flipped];
    
    rect.size.height = 5.0;
    // Bar radius
    CGFloat barRadius = 2.5;
    CGFloat value = ([self doubleValue]  - [self minValue]) / ([self maxValue] - [self minValue]);
    CGFloat finalWidth = value * ([[self controlView] frame].size.width - 8);
    
    NSRect leftRect = rect;
    leftRect.size.width = finalWidth;

    //NSLog(@"- Current Rect:%@ \n- Value:%f \n- Final Width:%f", NSStringFromRect(rect), value, finalWidth);
    NSBezierPath* bg = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: barRadius yRadius: barRadius];
    [FUConstManager.colorForBackground_slideNo setFill];
    [bg fill];
    if (_cellType == FUSliderCellType01) {
            NSBezierPath* active = [NSBezierPath bezierPathWithRoundedRect: leftRect xRadius: barRadius yRadius: barRadius];
            [FUConstManager.colorForBackground_sel setFill];
            [active fill];
    }else{
        NSRect centBg = rect;
        centBg.size.width = 4;
        centBg.size.height = 12;
        centBg.origin.x  = (rect.size.width - 4)/2 + rect.origin.x;
        centBg.origin.y  = rect.origin.x + barRadius + 6;
        
        float centerX = rect.size.width / 2;
        NSRect reRect = rect;
        
        if (centerX - finalWidth < 0) {
            
            reRect.origin.x = centerX + rect.origin.x;
            reRect.size.width = finalWidth - centerX - rect.origin.x;
        }else{
            reRect.origin.x = finalWidth + rect.origin.x;
            reRect.size.width = centerX - finalWidth - rect.origin.x + 2;
        }
        NSBezierPath* active = [NSBezierPath bezierPathWithRoundedRect: reRect xRadius: barRadius yRadius: barRadius];
        [FUConstManager.colorForBackground_sel setFill];
        [active fill];
        
        NSBezierPath *centPath = [NSBezierPath bezierPathWithRect:centBg];
        [FUColor_HEX(0xFCFDFF) setFill];
        [centPath fill];
        [FUColor_HEX(0xE0E3EE) setStroke];
        [centPath stroke];
    }
    
}


-(void)setCellType:(FUSliderCellType)cellType{
    _cellType = cellType;
    [self drawKnob];
}


@end
