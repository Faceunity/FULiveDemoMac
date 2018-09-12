//
//  FUManager.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FUManager : NSObject
// 是否性能优先
@property (nonatomic, assign) BOOL performance ;

+ (FUManager *)shareManager;

/**初始化Faceunity,加载道具*/
- (void)loadAllItems;

/**加载美颜道具*/
- (void)loadFilter ;

/**销毁全部道具*/
- (void)destoryAllItems;

/**加载普通道具*/
- (void)loadItem:(NSString *)itemName;

/**抗锯齿*/
- (void)loadAnimojiFaxxBundle ;

- (void)destoryAnimojiFaxxBundle ;

/**
 修改sdk参数

 @param sdkStr sdk设置键值
 @param index 设置对于句柄的参数
 index ： 0 - 美颜 ；1 - 贴纸 ；2 - 抗锯齿
 reture : 0 - 失败 ； 1 - 成功
 */
-(int)changeParamsStr:(NSString *)sdkStr index:(int)index value:(id)value;


/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)set3DFlipH ;

- (void)setLoc_xy_flip ;

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks;
/**
 获取图像中人脸中心点位置

 @param frameSize 图像的尺寸，该尺寸要与视频处理接口或人脸信息跟踪接口中传入的图像宽高相一致
 @return 返回一个以图像左上角为原点的中心点
 */
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize;

 /**设置人脸识别个数，默认为单人模式*/
- (void)setMaxFaces:(int)maxFace;

/**判断是否检测到人脸*/
- (BOOL)isTracking;

/**切换摄像头要调用此函数*/
- (void)onCameraChange;

/**获取错误信息*/
- (NSString *)getError;

/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK ;



@end
