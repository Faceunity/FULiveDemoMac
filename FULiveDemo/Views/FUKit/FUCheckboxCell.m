//
//  FUCheckboxCell.m
//  FULive
//
//  Created by 孙慕 on 2018/8/15.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUCheckboxCell.h"
#define     FU_BORDER_COLOR        [NSColor colorWithCalibratedRed:119/255.f green: 135/255.f blue: 1 alpha: 1]
#define     FU_TILE_COLOR          [NSColor whiteColor]

@implementation FUCheckboxCell

#pragma mark - Override Methods

-(instancetype)init{
    self = [super init];
    if (self) {
        [self fu_initializeCheckboxCell];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self fu_initializeCheckboxCell];
}

- (void)setNextState{
    if([self state] == NSOffState){
        [super setNextState];
    }
    [super setNextState];
}

- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView{
    frame.origin.y += _detaY;
    [super drawImage:[self fu_drawStatusImage:frame.size] withFrame:frame inView:controlView];

//
}

//-(NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView{
//
//        NSDictionary *attrButton = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:15], NSFontAttributeName,FUConstManager.colorForBackground_text1, NSForegroundColorAttributeName, nil];
//
//        NSAttributedString * btnString = [[NSAttributedString alloc] initWithString:[self title] attributes:attrButton];
//        [self setAttributedTitle:btnString];
//
//    return [super drawTitle:btnString withFrame:frame inView:controlView];
//}

#pragma mark - Private methods

-(void)fu_initializeCheckboxCell{
    _detaY = 0;
    // paraStyle, NSParagraphStyleAttributeName,

    [self setButtonType:NSSwitchButton];
    [self setAllowsMixedState:YES];
}

-(NSImage *)fu_drawStatusImage:(NSSize)size {
    size.height -= 4;
    size.width -= 4;
    NSImage *image = [[NSImage alloc] initWithSize:size];
    NSRect rctBorder = NSMakeRect(0, 0, image.size.width,image.size.height);
    NSRect rctTile= NSInsetRect(rctBorder, 2.0, 2.0);
    
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rctBorder, 0.5, 0.5)  xRadius:2.0 yRadius:2.0];
    NSBezierPath *tilePath = [NSBezierPath bezierPathWithRoundedRect:rctTile xRadius:2.0 yRadius:2.0];
    NSBezierPath *checkPath = [NSBezierPath bezierPath];
    [checkPath moveToPoint: NSMakePoint(3, 7)];
    [checkPath curveToPoint: NSMakePoint(6, 4) controlPoint1: NSMakePoint(6, 4) controlPoint2: NSMakePoint(6, 4)];
    [checkPath lineToPoint: NSMakePoint(10.5, 10)];
    
    [image lockFocus];
    [NSGraphicsContext saveGraphicsState];
    
    
    

    // [borderPath fill];
    
    int status = [((NSNumber *)self.objectValue) intValue];
    if(0 == status){
       // [FU_BORDER_COLOR setFill];
     //   [tilePath fill];
        [FUColor_HEX(0xb4b5bd) setStroke];
        borderPath.lineWidth = 1;
        borderPath.lineJoinStyle = NSBevelLineJoinStyle;
        [borderPath stroke];
    }else if(1 == status){
        [FU_BORDER_COLOR setStroke];
        borderPath.lineWidth = 1;
        borderPath.lineJoinStyle = NSBevelLineJoinStyle;
        [borderPath stroke];
        [FU_BORDER_COLOR setFill];
        [borderPath fill];
        [FU_TILE_COLOR setStroke];
        [checkPath setLineWidth:2.0];
        checkPath.lineCapStyle = NSRoundLineCapStyle;
        checkPath.lineJoinStyle = NSRoundLineJoinStyle;
        [checkPath stroke];
    }
    
    [NSGraphicsContext restoreGraphicsState];
    [image unlockFocus];
    
    
    return image;
}


@end
