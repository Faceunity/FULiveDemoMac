//
//  FUSliderCell.h
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//
//  -----------    为改变slider颜色自定义    ----------

#import <Cocoa/Cocoa.h>
typedef NS_ENUM(NSUInteger, FUSliderCellType) {
    FUSliderCellType01,  /* 正常滑杆 */
    FUSliderCellType101, /* ±50 滑杆 */
};

@interface FUSliderCell : NSSliderCell
/* 滑杆类型 */
@property (assign,nonatomic) FUSliderCellType cellType;

@end
