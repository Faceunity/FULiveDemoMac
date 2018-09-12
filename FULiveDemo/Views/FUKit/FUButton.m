//
//  FUButton.h
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//
//  -----------    为改变Button背景颜色    ----------

#import "FUButton.h"

#define FUTextAlignmentDefault 8
#define FUButtonAlphaValueActive 0.7
#define FUButtonAlphaValueInactive 1.0

@interface FUButton ()
{
    BOOL _mouseDown;
    BOOL _mouseIn;
}

@property (readonly) NSColor * effectBackgroundColor;
@property (retain) NSTrackingArea * trackingArea;
@end

@implementation FUButton
@dynamic displayString;

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (backgroundColor != _backgroundColor) {
        _backgroundColor = backgroundColor;
        self.needsDisplay = YES;
    }
}

-(void)setRadius:(CGFloat)radius{
    if (radius != _radius) {
        _radius = radius;
        self.needsDisplay = YES;
    }
}

- (NSAttributedString *)displayString{
    //NSHeight(self.bounds) - 2*self.textAlignment]
   // [NSFont boldSystemFontOfSize:<#(CGFloat)#>]
    NSMutableAttributedString * attibutedTitle = [[NSMutableAttributedString alloc] initWithString:self.textString attributes:@{NSForegroundColorAttributeName:self.textColor, NSFontAttributeName: [NSFont boldSystemFontOfSize:13]}];
    return attibutedTitle;
}

- (void)setDisplayString:(NSAttributedString *)displayString{
    NSDictionary * dicAttibutes = [displayString attributesAtIndex:0 effectiveRange:NULL];
    self.textString = displayString.string;
    for (NSString * key in dicAttibutes.allKeys) {
        if ([key isEqualToString:NSForegroundColorAttributeName]) {
            self.textColor = dicAttibutes[NSForegroundColorAttributeName];
        }
    }
}

- (NSColor *)effectBackgroundColor{
    NSColor * color = [NSColor clearColor];
    if (_mouseDown && _mouseIn) {
        color = [self.backgroundColor blendedColorWithFraction:0.3 ofColor:[NSColor blackColor]];
    }
    else {
        color = self.backgroundColor;
    }
    
    return color;
}

- (void)setup{
    self.alphaValue = FUButtonAlphaValueInactive;
    
    _mouseDown = NO;
    _mouseIn = NO;
    self.textAlignment = FUTextAlignmentDefault;
    self.backgroundColor = [NSColor redColor];
    self.textColor = [NSColor whiteColor];
    self.textString = @"";
    self.border = YES;
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)setButtonType:(NSButtonType)aType{
    [self setButtonType:NSToggleButton];
}

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    
    NSRect rectFill = NSInsetRect(self.bounds, 3, 3);
    NSBezierPath * bezier = nil;
    if (_radius) {
        bezier = [NSBezierPath bezierPathWithRoundedRect:rectFill xRadius:_radius yRadius:_radius];
    }else{
        bezier = [NSBezierPath bezierPathWithRoundedRect:rectFill xRadius:6 yRadius:6];
    }
    
    [self.effectBackgroundColor setFill];
    [self.textColor setStroke];
    [bezier fill];
    if(_border){
      [bezier stroke];
    }
    
    [self.displayString drawAtPoint:NSMakePoint((NSWidth(self.bounds) - self.displayString.size.width) / 2 + 1, (NSHeight(self.bounds) - self.displayString.size.height) / 2)];
}

- (void)mouseDown:(NSEvent *)theEvent{
    _mouseDown = YES;
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent{
    if (_mouseDown) {
        _mouseDown = NO;
        self.needsDisplay = YES;
        if (_mouseIn && self.target && self.action) {
            [self.target performSelector:self.action withObject:nil afterDelay:0.0];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent{
    _mouseIn = YES;
    self.animator.alphaValue = FUButtonAlphaValueActive;
    
    self.needsDisplay = YES;
}

- (void)mouseExited:(NSEvent *)theEvent{
    _mouseIn = NO;
    self.animator.alphaValue = FUButtonAlphaValueInactive;
    
    self.needsDisplay = YES;
}

- (void)updateTrackingAreas
{
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
}

@end
