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

-(void)loadMakeup;

/**销毁全部道具*/
- (void)destoryAllItems;

/**加载普通道具*/
- (void)loadItem:(NSString *)itemName;

/**抗锯齿*/
- (void)loadAnimojiFaxxBundle ;

/* animoji套头设置 */
-(void)setAnimojiSleeveHead;

- (void)destoryAnimojiFaxxBundle ;

/**
 修改sdk参数

 @param sdkStr sdk设置键值
 @param index 设置对于句柄的参数
 index ： 0 - 美颜 ；1 - 贴纸 ；2 - 抗锯齿
 reture : 0 - 失败 ； 1 - 成功
 */
-(int)changeParamsStr:(NSString *)sdkStr index:(int)index value:(id)value;


#pragma mark -  美妆
/*
 tex_brow 眉毛
 tex_eye 眼影
 tex_pupil 美瞳
 tex_eyeLash 睫毛
 tex_lip 口红
 tex_highlight 口红高光
 //jiemao
 //meimao
 tex_eyeLiner 眼线
 tex_blusher腮红
 */
-(void)setMakeupItemParamImage:(NSImage *)image param:(NSString *)paramStr;

/*
 is_makeup_on: 1, //美妆开关
 makeup_intensity:1.0, //美妆程度 //下面是每个妆容单独的参数，intensity设置为0即为关闭这种妆效 makeup_intensity_lip:1.0, //kouhong makeup_intensity_pupil:1.0, //meitong
 makeup_intensity_eye:1.0,
 makeup_intensity_eyeLiner:1.0,
 makeup_intensity_eyelash:1.0,
 makeup_intensity_eyeBrow:1.0,
 makeup_intensity_blusher:1.0, //saihong
 makeup_lip_color:[0,0,0,0] //长度为4的数组，rgba颜色值
 makeup_lip_mask:0.0 //嘴唇优化效果开关，1.0为开 0为关
 */
-(void)setMakeupItemIntensity:(float )value param:(NSString *)paramStr;

-(void)setMakeupItemLipstick:(double *)lipData;


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
