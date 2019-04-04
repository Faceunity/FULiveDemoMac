//
//  FUPropItemModel.h
//  FULive
//
//  Created by 孙慕 on 2018/8/13.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, FULiveModelType) {
    FULiveModelTypeBeautifyFace             = 0, /* 美颜 */
    FULiveModelTypeMakeUp,   /* 美妆 */
    FULiveModelTypeItems,   /* 贴纸 */
    FULiveModelTypeAnimoji,  /* Animoji */
    FULiveModelTypeARMarsk,  /* AR面具 */
    FULiveModelTypeFaceChange,  /* 换脸 */
    FULiveModelTypeExpressionRecognition,  /* 表情识别 */
    FULiveModelTypeMusicFilter,  /* 音乐滤镜 */
    FULiveModelTypeBGSegmentation,  /* 背景分割 */
    FULiveModelTypeGestureRecognition,  /* 手势识别 */
    FULiveModelTypeHahaMirror,  /* 哈哈镜 */
    FULiveModelTypePortraitLighting,  /* 人像 */
    FULiveModelTypePortraitDrive,  /* 人脸驱动 */
};

@interface FUPropSubItemModel : NSObject
/* 图片 */
@property (retain) NSString *subImageStr;
/* sdk键值 */
@property (retain) NSString *subSdkStr;
/* 提示字符串 */
@property (retain) NSString *hintStr;

+(FUPropSubItemModel *)GetClassSubImageStr:(NSString *)imageStr sdkStr:(NSString *)sdkStr;

+(FUPropSubItemModel *)GetClassSubImageStr:(NSString *)imageStr sdkStr:(NSString *)sdkStr hint:(NSString *)hintStr;
@end


@interface FUPropItemModel : NSObject
/* 标题 */
@property (retain) NSString *title;
/* 图片 */
@property (retain) NSString *hoverImageStr;
/* 图片 */
@property (retain) NSString *norImageStr;
/* 子items */
@property (retain) NSArray <FUPropSubItemModel *> *subItems;
/* 类型 */
@property (nonatomic, assign) FULiveModelType propType;
/* 最大人脸数 */
@property (nonatomic, assign) int maxFace;

+(FUPropItemModel *)GetClassTitle:(NSString *)titleStr hoverImageStr:(NSString *)hoverImageStr norImageStr:(NSString *)norImageStr subItems:(NSArray <FUPropSubItemModel *> *)subItems type:(FULiveModelType)type maxFace:(int)maxFace;
@end
