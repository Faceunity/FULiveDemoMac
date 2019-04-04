//
//  FUPropItemModel.m
//  FULive
//
//  Created by 孙慕 on 2018/8/13.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUPropItemModel.h"

@implementation FUPropSubItemModel
+(FUPropSubItemModel *)GetClassSubImageStr:(NSString *)imageStr sdkStr:(NSString *)sdkStr{
    FUPropSubItemModel *model = [[FUPropSubItemModel alloc] init];
    model.subImageStr = imageStr;
    model.subSdkStr = sdkStr;
    return model;
}

+(FUPropSubItemModel *)GetClassSubImageStr:(NSString *)imageStr sdkStr:(NSString *)sdkStr hint:(NSString *)hintStr{
    FUPropSubItemModel *model = [[FUPropSubItemModel alloc] init];
    model.subImageStr = imageStr;
    model.subSdkStr = sdkStr;
    model.hintStr = hintStr;
    return model;
}

@end

@implementation FUPropItemModel
+(FUPropItemModel *)GetClassTitle:(NSString *)titleStr hoverImageStr:(NSString *)hoverImageStr norImageStr:(NSString *)norImageStr subItems:(NSArray <FUPropSubItemModel *> *)subItems type:(FULiveModelType)type maxFace:(int)maxFace{
    FUPropItemModel *model = [[FUPropItemModel alloc] init];
    model.title = titleStr;
    model.hoverImageStr = hoverImageStr;
    model.norImageStr = norImageStr;
    model.subItems = subItems;
    model.propType = type;
    model.maxFace = maxFace;
    return model;
}


@end
