//
//  FUBaseModel.h
//  FULive
//
//  Created by 孙慕 on 2018/8/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 数值范围
 */

typedef struct _FUValueRect {
    CGFloat minNum;        /* 最小值*/
    CGFloat maxNum;        /* 最大值 */
} FUValueRect;

NS_INLINE FUValueRect FUMakeRect(CGFloat min, CGFloat max) {
    FUValueRect s;
    s.minNum = min;
    s.maxNum = max;
    return s;
}

/**
 模型数据类型

 - FUBaseModelTypeSwitch: 开关
 - FUBaseModelTypeRange: 刻度值
 - FUBaseModelTypeSelect: 类型值
 */
typedef NS_ENUM(NSUInteger, FUBeautyModelType) {
    FUBeautyModelTypeSwitch = 0,
    FUBeautyModelTypeRange = 1,
    FUBeautyModelTypeSelect = 2,
};

/* 值类型model */
@interface FUValue : NSObject<NSCopying>
@property (retain) NSString *sdkStr;
@property (assign) float     value;
@property (assign) BOOL on;
@end

@interface FUBeautyModel : NSObject
/* icon1 */
@property (retain) NSString *openImageStr;
/* icon2 */
@property (retain) NSString *closeImageStr;
/* 项目名称 */
@property (retain) NSString *titleStr;
/* 类型 */
@property (assign) FUBeautyModelType type;
/* 调节值 */
@property (retain) FUValue *currentValue;
/* 默认值 */
@property (retain) FUValue *defaultValue;
/* 调节范围 */
@property (assign) FUValueRect valueRect;
/* 选择字符串 */
@property (retain) NSArray *valueStrArray;

+(FUBeautyModel *)GetModelClassTitle:(NSString *)titleStr openImgStr:(NSString *)openImg closeImgStr:closeImg type:(FUBeautyModelType)type sdkStr:(NSString *)sdkStr defaultValue:(float)defaultValue rect:(FUValueRect) rect strArray:(NSArray *)strArray;


@end
