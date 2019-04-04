//
//  FUCheckBox.h
//  FULive
//
//  Created by 孙慕 on 2018/8/15.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FUCheckBox : NSButton

/* 勾勾Y偏移 */
@property (nonatomic,assign)                            NSInteger   detaY;
/* 文本颜色 */
@property (nonatomic,copy)                              NSColor     *titleColor;
/* 字体 */
@property (nonatomic,copy)                              NSFont      *font;
/* 下划线 */
@property (nonatomic,assign,getter=isUnerLined)         BOOL        underLined;


@end
