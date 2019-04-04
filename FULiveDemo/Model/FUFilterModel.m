//
//  FUFilterModel.m
//  FULive
//
//  Created by 孙慕 on 2018/8/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUFilterModel.h"

@implementation FUFilterModel
+ (FUFilterModel *)GetModelClassTitle:(NSString *)titleStr imgStr:(NSString *)Img sdkStr:(NSString *)sdkStr styleStr:(NSString *)styleStr valueSdkStr:(NSString *)valueSdkStr value:(float)value{
    FUFilterModel *model = [[FUFilterModel alloc] init];
    model.titleStr = titleStr;
    model.imageStr = Img;
    model.value = value;
    model.sdkStr = sdkStr;
    model.styleStr = styleStr;
    model.valueSdkStr = valueSdkStr;
    return model;
}
@end
