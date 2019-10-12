//
//  FUSkinStyle1RowView.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSkinStyle1RowView.h"
#import "FUSliderCell.h"
#import "FUManager.h"

@interface FUSkinStyle1RowView()

@end

@implementation FUSkinStyle1RowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)awakeFromNib{
    [super awakeFromNib];
}


#pragma  mark ----  public接口  -----
-(void)setModel:(FUBeautyModel *)model{
    _model = model;
    _mImageView.image = [NSImage imageNamed:model.openImageStr];
    _mTitleLabel.stringValue = model.titleStr;
    
    int type = (int)(model.valueRect.maxNum - model.valueRect.minNum);
    if (model.valueRect.minNum < 0) { //中间为0样式
        FUSliderCell *cell =  (FUSliderCell *)_mSlider.cell;
        [cell setCellType:FUSliderCellType101];
        _mSlider.minValue = -50;
        _mSlider.maxValue = 50;
    }else{
        FUSliderCell *cell =  (FUSliderCell *)_mSlider.cell;
        [cell setCellType:FUSliderCellType01];
        _mSlider.minValue = 0;
        _mSlider.maxValue = 100;
    }
    
    [_mSlider setIntValue:(model.currentValue.value + model.valueRect.minNum)/(model.valueRect.maxNum - model.valueRect.minNum) * 100];
    [_mTextField setStringValue:[NSString stringWithFormat:@"%.0f",(model.currentValue.value + model.valueRect.minNum) * 100/type]];
    
    if (_model.currentValue.value + _model.valueRect.minNum == 0) {
        [_mImageView setImage:[NSImage imageNamed:_model.closeImageStr]];
    }else{
        [_mImageView setImage:[NSImage imageNamed:_model.openImageStr]];
    }

}


-(void)setMiniMum:(int)minValue maximum:(int)maxValue{
    
    [_mSlider setMaxValue:maxValue];
    [_mSlider setMinValue:minValue];

}

#pragma  mark ----  private方法  -----
// 校验是否为纯数字
- (BOOL)isNum:(NSString *)checkedNumString {
    if ([checkedNumString hasPrefix:@"-"]) {
       checkedNumString =  [checkedNumString substringFromIndex:1];
    }
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


#pragma  mark ----  UI事件  -----
- (IBAction)sliderDidChange:(NSSlider *)sender {
    
    NSLog(@"slideValu ----- %ld",(long)sender.integerValue);
    int type = (int)(_model.valueRect.maxNum - _model.valueRect.minNum);
    
    [_mTextField setStringValue:[NSString stringWithFormat:@"%d",_mSlider.intValue]];
    _model.currentValue.value = (_mSlider.intValue - _mSlider.minValue) * 1.0 / 100 * type;
    if (_model.currentValue.value + _model.valueRect.minNum == 0) {
        [_mImageView setImage:[NSImage imageNamed:_model.closeImageStr]];
    }else{
        [_mImageView setImage:[NSImage imageNamed:_model.openImageStr]];
    }
    
    /* 修改参数 */
    [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.value)];
}

- (IBAction)inputValueDidChange:(NSTextField *)sender {
     NSLog(@"input ----- %ld",sender.integerValue);
    if ([self isNum:sender.stringValue] && sender.intValue >= _mSlider.minValue && sender.intValue <= _mSlider.maxValue) {//输入符合要求
        _mSlider.intValue = sender.intValue;
        sender.stringValue = [NSString stringWithFormat:@"%d",sender.intValue];
        if (sender.intValue == 0) {//防止出现输入框-00，00，0000 这中情况
            sender.intValue = 0;
        }
            int type = (int)(_model.valueRect.maxNum - _model.valueRect.minNum);
        _model.currentValue.value = (_mSlider.intValue - _mSlider.minValue) * 1.0 / 100 * type;
        if (_model.currentValue.value + _model.valueRect.minNum == 0) {
            [_mImageView setImage:[NSImage imageNamed:_model.closeImageStr]];
        }else{
            [_mImageView setImage:[NSImage imageNamed:_model.openImageStr]];
        }
        /* 修改参数 */
        [[FUManager shareManager] changeParamsStr:_model.currentValue.sdkStr index:0 value:@(_model.currentValue.value)];
        
    }else{
#pragma TODO: 播放提示音
        [_mTextField setStringValue:[NSString stringWithFormat:@"%d",_mSlider.intValue]];
    }    
    //取消选中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender abortEditing];
    });
}


@end
