//
//  FUSkinStyle2RowView.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSkinStyle2RowView.h"
#import "FUButton.h"
#import "FUManager.h"
@interface FUSkinStyle2RowView()
@property (weak) IBOutlet NSImageView *mImageView;
@property (weak) IBOutlet NSTextField *mTitleLabel;
@property (weak) IBOutlet FUButton *mFuBtn1;
@property (weak) IBOutlet FUButton *mFuBtn2;


@end

@implementation FUSkinStyle2RowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _mFuBtn1.textString = @"开启";
    _mFuBtn2.textString = @"关闭";
    [self button1Click:_mFuBtn1];

}


#pragma  mark ----  UI点击事件  -----
- (IBAction)button1Click:(FUButton *)sender {
    _mFuBtn1.backgroundColor = FUConstManager.colorForBackground_sel;
    _mFuBtn2.backgroundColor = FUConstManager.colorForBackground_card;
    _mFuBtn1.textColor = [NSColor whiteColor];
    _mFuBtn2.textColor = FUConstManager.colorForBackground_btnNo;
    
    if(!_model) return;
    if ( _model.type == FUBeautyModelTypeSwitch){//开关类型
        _model.currentValue.on = YES;
        [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.on)];
        _mImageView.image = [NSImage imageNamed:_model.openImageStr];
    
    }else{
        _model.currentValue.value = 0;
         [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.value)];
    }
   
}

- (IBAction)button2Click:(FUButton *)sender {
    _mFuBtn2.backgroundColor = FUConstManager.colorForBackground_sel;
    _mFuBtn1.backgroundColor = FUConstManager.colorForBackground_card;
    _mFuBtn2.textColor = [NSColor whiteColor];
    _mFuBtn1.textColor = FUConstManager.colorForBackground_btnNo;
    /* 磨皮默认类型设置为0 */
    [[FUManager shareManager] changeParamsStr:@"blur_type" index:0 value:@(0)];
 
    if(!_model) return;
    if ( _model.type == FUBeautyModelTypeSwitch){//开关类型
        _model.currentValue.on = NO;
        _mImageView.image = [NSImage imageNamed:_model.closeImageStr];
         [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.on)];
    }else{
        _model.currentValue.value = 1;
        [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.value)];
    }
}

#pragma  mark ----  public接口  -----
-(void)setModel:(FUBeautyModel *)model{
    _model = model;
    _mImageView.image = [NSImage imageNamed:model.openImageStr];
    _mTitleLabel.stringValue = model.titleStr;
    _mFuBtn1.textString = model.valueStrArray.firstObject;
    _mFuBtn2.textString = model.valueStrArray.lastObject;
    if ((model.currentValue.value == 1 && model.type == FUBeautyModelTypeSelect) || (!model.currentValue.on && model.type == FUBeautyModelTypeSwitch)){//两种样式公用
        [self button2Click:_mFuBtn2];
    }else{
        [self button1Click:_mFuBtn1];
    }
    
}



@end
