//
//  FUBaseModel.m
//  FULive
//
//  Created by 孙慕 on 2018/8/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUBeautyModel.h"
@implementation FUValue
-(id)copyWithZone:(NSZone *)zone{
    FUValue *value = [[FUValue alloc] init];
    value.on = self.on;
    value.value = self.value;
    value.sdkStr = self.sdkStr;
    return value;
}

@end
@implementation FUBeautyModel

+(FUBeautyModel *)GetModelClassTitle:(NSString *)titleStr openImgStr:(NSString *)openImg closeImgStr:closeImg type:(FUBeautyModelType)type sdkStr:(NSString *)sdkStr defaultValue:(float)defaultValue rect:(FUValueRect) rect strArray:(NSArray *)strArray{
    FUBeautyModel *model = [[FUBeautyModel alloc] init];
    model.titleStr = titleStr;
    model.openImageStr = openImg;
    model.closeImageStr = closeImg;
    model.type = type;
    FUValue *valuemodel = [[FUValue alloc] init];
    valuemodel.sdkStr = sdkStr;
    if (type == FUBeautyModelTypeSwitch) {
        valuemodel.on = (BOOL)defaultValue;
    }else if (type == FUBeautyModelTypeRange){
        valuemodel.value = defaultValue;
    }else{
        valuemodel.value = (int)defaultValue;
    }
    model.defaultValue = valuemodel;
    model.currentValue = [valuemodel copy];
    model.valueRect = rect;
    model.valueStrArray = strArray;
    
    return model;
    
}

@end
