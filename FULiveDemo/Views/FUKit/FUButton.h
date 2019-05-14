//
//  FUButton.h
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//
//  -----------    为改变Button背景颜色    ----------

#import <Cocoa/Cocoa.h>

IB_DESIGNABLE
@interface FUButton : NSControl

/* 背景色 */
@property (nonatomic, retain) IBInspectable NSColor * backgroundColor;
/* 文字 */
@property (nonatomic, copy) IBInspectable NSString * textString;
/* 文字色 */
@property (nonatomic, retain) IBInspectable NSColor * textColor;
/* 排版 */
@property (nonatomic) IBInspectable CGFloat textAlignment;
/* 圆角 */
@property (nonatomic) IBInspectable CGFloat radius;
/* 边框 */
@property (nonatomic) IBInspectable BOOL border ;
@property (nonatomic) NSAttributedString * displayString;



@end
