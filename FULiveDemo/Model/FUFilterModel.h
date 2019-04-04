//
//  FUFilterModel.h
//  FULive
//
//  Created by 孙慕 on 2018/8/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FUFilterModel : NSObject

/* 图片 */
@property (retain) NSString *imageStr;
/* 标题 */
@property (retain) NSString *titleStr;
/* sdk模式键值 */
@property (retain) NSString *sdkStr;
/* 滤镜模式 */
@property (retain) NSString *styleStr;
/* sdk程度值键值 */
@property (retain) NSString *valueSdkStr;
/* 程度值 */
@property (assign) float     value;

+ (FUFilterModel *)GetModelClassTitle:(NSString *)titleStr imgStr:(NSString *)Img sdkStr:(NSString *)sdkStr styleStr:(NSString *)styleStr valueSdkStr:(NSString *)valueSdkStr value:(float)value;
@end
