//
//  NSButton+FUExtension.m
//  FULive
//
//  Created by 孙慕 on 2018/7/30.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "NSButton+FUExtension.h"

@implementation NSButton (FUExtension)
- (void)setTitleColor:(NSColor*)color font:(NSFont *)font{
    if(color == nil) {
        color = [NSColor redColor];
    }
    if (font == nil) {
        font = self.font;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    
    [paraStyle setAlignment:NSTextAlignmentCenter];
    
   //[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    NSDictionary *attrButton = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,color, NSForegroundColorAttributeName, paraStyle, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString * btnString = [[NSAttributedString alloc] initWithString:[self title] attributes:attrButton];
    
    [self setAttributedTitle:btnString];
    
}

@end
