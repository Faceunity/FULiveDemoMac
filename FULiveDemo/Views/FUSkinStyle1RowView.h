//
//  FUSkinStyle1RowView.h
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FUBeautyModel.h"

@interface FUSkinStyle1RowView : NSTableRowView
/* icon */
@property (weak) IBOutlet NSImageView *mImageView;
/* 标题 */
@property (weak) IBOutlet NSTextField *mTitleLabel;
/* 滑杆 */
@property (weak) IBOutlet NSSlider *mSlider;
/* 输入框 */
@property (weak) IBOutlet NSTextField *mTextField;
/* 数据 set为接口 */
@property (retain,nonatomic) FUBeautyModel *model;



@end
