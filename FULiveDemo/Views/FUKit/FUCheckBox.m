//
//  FUCheckBox.m
//  FULive
//
//  Created by 孙慕 on 2018/8/15.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUCheckBox.h"
#import "FUCheckboxCell.h"

@implementation FUCheckBox{
    NSColor             *_titleColor;
    NSFont              *_font;
    NSInteger   _detaY;
    NSAttributedString  *_attributedTitle;
    struct {
        unsigned int isNormalStringValue:1;
        unsigned int isUnderLined:1;
    } _buttonFlags;
}

#pragma mark - Override Methods

+(Class)cellClass{
    return [FUCheckboxCell class];
}

-(instancetype)init{
    if (self = [super init]) {
        [self fu_initializeCheckbox];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self fu_initializeCheckbox];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self fu_initializeCheckbox];
}

#pragma mark - Public Methods

-(NSInteger)detaY{
    FUCheckboxCell *cell = [self cell];
    return [cell detaY];
}

-(void)setDetaY:(NSInteger)nValue{
    FUCheckboxCell *cell = [self cell];
    [cell setDetaY:nValue];
    [self setNeedsDisplay:YES];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    _buttonFlags.isNormalStringValue = YES;
    _attributedTitle = nil;
    [self fu_updateLookup];
}

-(NSString *)title{
    return [super title];
}

-(void)setTitleColor:(NSColor *)titleColor{
    _titleColor = titleColor;
    _buttonFlags.isNormalStringValue = YES;
    [self fu_updateLookup];
}

-(NSColor *)titleColor{
    return _titleColor;
}

-(void)setFont:(NSFont *)font{
    _font = font;
    _buttonFlags.isNormalStringValue = YES;
    [self fu_updateLookup];
}

-(NSFont *)font{
    return _font;
}

-(void)setUnderLined:(BOOL)underLined{
    _buttonFlags.isUnderLined = underLined;
    _buttonFlags.isNormalStringValue = YES;
    [self fu_updateLookup];
}

-(BOOL)isUnderLined{
    return _buttonFlags.isUnderLined;
}

//-(void)setAttributedTitle:(NSAttributedString *)attributedTitle{
//    _attributedTitle = attributedTitle;
//    _buttonFlags.isNormalStringValue = NO;
//    [super setTitle:@""];
//    [self fu_updateLookup];
//}

//-(NSAttributedString *)attributedTitle{
//    return [super attributedTitle];
//}

#pragma mark - Private Methods

-(void)fu_initializeCheckbox{
    _buttonFlags.isNormalStringValue = YES;
    _buttonFlags.isUnderLined = NO;
    _titleColor = FUColor_HEX(0x2F3658);
    _detaY = 3;
    _font = [NSFont systemFontOfSize:16];
}

-(void)fu_updateLookup{
    if (_buttonFlags.isNormalStringValue) {
        [super setAttributedTitle:[self fu_createLookUpAttributeString]];
    }else{
        [super setAttributedTitle:_attributedTitle];
    }
    [self setNeedsDisplay];
}

-(NSAttributedString *)fu_createLookUpAttributeString{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: super.title];
    [attrString beginEditing];
    
    NSUInteger nLen = [attrString length];
    NSColor *stringColor = _titleColor;
    [attrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, nLen)];
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, nLen)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:self.cell.lineBreakMode];
    [paragraphStyle setAlignment:self.alignment];
    if (nil != paragraphStyle) {
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,nLen)];
    }
    
    
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:(_buttonFlags.isUnderLined  ? NSUnderlineStyleSingle : NSUnderlineStyleNone)] range:NSMakeRange(0, nLen)];
    
    [attrString endEditing];
    return attrString;
}

@end
