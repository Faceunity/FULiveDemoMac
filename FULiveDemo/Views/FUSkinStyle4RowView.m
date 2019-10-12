//
//  FUSkinStyle3RowView.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSkinStyle4RowView.h"
#import "FUButton.h"
#import "FUManager.h"
@interface FUSkinStyle4RowView()
@property (weak) IBOutlet NSImageView *mImageView;
@property (weak) IBOutlet NSTextField *mTitleLabel;
@property (weak) IBOutlet FUButton *mFuBtn1;
@property (weak) IBOutlet FUButton *mFuBtn2;
@property (weak) IBOutlet FUButton *mFuBtn3;
@property (weak) IBOutlet NSView *btnSupView;

@end
@implementation FUSkinStyle4RowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self changeButtonUI:_mFuBtn1];
}

#pragma  mark ----  public  -----

-(void)setModel:(FUBeautyModel *)model{
    _model = model;
    _mFuBtn1.textString = model.valueStrArray[0];
    _mFuBtn2.textString = model.valueStrArray[1];
    _mFuBtn3.textString = model.valueStrArray[2];
    _mImageView.image = [NSImage imageNamed:model.openImageStr];
    _mTitleLabel.stringValue = model.titleStr;
    
    if (model.currentValue.value == 2) {
        [self changeButtonUI:_mFuBtn1];
    }else if (model.currentValue.value == 0) {
        [self changeButtonUI:_mFuBtn2];
    }else if (model.currentValue.value == 1) {
        [self changeButtonUI:_mFuBtn3];
    }
}

#pragma  mark ----  UI点击事件  -----
- (IBAction)btn1Click:(FUButton *)sender {
    [self changeButtonUI:_mFuBtn1];
    [self transferBlock:2];
}

- (IBAction)btn2Click:(FUButton *)sender {
    [self changeButtonUI:_mFuBtn2];
    [self transferBlock:0];
}
- (IBAction)btn3Click:(FUButton *)sender {
    [self changeButtonUI:_mFuBtn3];
    [self transferBlock:1];
}


-(void)transferBlock:(int)type{
    _model.currentValue.value = type;
    [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.value)];
    if (_didClickBlock) {
        _didClickBlock(type);
    }
}

#pragma  mark ----  private  -----

-(void)changeButtonUI:(FUButton *)button{
    for (NSView *view in _btnSupView.subviews) {
        if ([view isKindOfClass:[FUButton class]]) {
            FUButton *btn = (FUButton *)view;
            btn.textColor = FUConstManager.colorForBackground_btnNo;
            btn.backgroundColor = FUConstManager.colorForBackground_card;
        }
    }
    button.textColor = [NSColor whiteColor];
    button.backgroundColor = FUConstManager.colorForBackground_sel;
}

@end
