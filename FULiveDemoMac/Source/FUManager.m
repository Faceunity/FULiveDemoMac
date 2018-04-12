//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
//#import "funama.h"
#import "authpack.h"
#import <AppKit/AppKit.h>
#import <GLKit/GLKit.h>

@interface FUManager ()
{
    //MARK: Faceunity
    int items[3];
    int frameID;
    
    NSDictionary *hintDic;
    NSOpenGLContext *glContext;
    
    dispatch_queue_t loadItemQueue;
}
@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        /*设置默认参数*/
        self.itemsDataSource = @[@"noitem", @"EatRabbi", @"bg_seg", @"fu_zh_duzui", @"yazui", @"mask_matianyu", @"houzi", @"gradient", @"yuguan"];
        
        self.filtersDataSource = @[@"origin", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    
        self.beautyFiltersDataSource = @[@"ziran", @"danya", @"fennen", @"qingxin", @"hongrun"];
        self.filtersCHName = @{@"ziran":@"自然", @"danya":@"淡雅", @"fennen":@"粉嫩", @"qingxin":@"清新", @"hongrun":@"红润"};
        [self setDefaultParameters];
        
//        NSLog(@"faceunitySDK version:%@",[FURenderer getVersion]);
        
        hintDic = @{@"fu_zh_duzui":@"做嘟嘴动作",@"Mood":@"嘴角向上或嘴角向下"};
        
        loadItemQueue = dispatch_queue_create("load item queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

/*设置默认参数*/
- (void)setDefaultParameters {
    
    self.selectedItem = self.itemsDataSource[1]; //贴纸道具
    
    self.selectedFilter = self.beautyFiltersDataSource[0]; //美颜滤镜效果
    
    self.selectedFilterLevel = 1.0;
    
    self.selectedBlur = 6; //磨皮程度
    
    self.skinDetectEnable = YES; //是否开启皮肤检测
    
    self.beautyLevel = 0.2; //美白程度
    
    self.redLevel = 0.5; //红润程度
    
    self.thinningLevel = 1.0; //瘦脸程度
    
    self.enlargingLevel = 0.5; //大眼程度
    
    self.faceShapeLevel = 0.5; //美型程度
    
    self.faceShape = 3; //美型类型
    
    self.enableGesture = NO;
    self.enableMaxFaces = NO;
    
    self.filtersLevel = [[NSMutableDictionary alloc] init];
    
    for (NSString *filter in self.filtersDataSource) {
        self.filtersLevel[filter] = @1.0;
    }
    
    for (NSString *filter in self.beautyFiltersDataSource) {
        self.filtersLevel[filter] = @1.0;
    }
}

- (double)selectedFilterLevel{
    if (self.selectedFilter) {
        _selectedFilterLevel = self.filtersLevel[self.selectedFilter].doubleValue;
    }
    
    return _selectedFilterLevel;
}

- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem];
    
    /**加载美颜道具*/
    [self loadFilter];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[2] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            [FURenderer destroyItem:items[2]];
            
            items[2] = 0;
        }
    }
}

/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setEnableMaxFaces:(BOOL)enableMaxFaces
{
    _enableMaxFaces = enableMaxFaces;
    
    [FURenderer setMaxFaces:enableMaxFaces?4:1];
}

/**销毁全部道具*/
- (void)destoryItems
{
    [FURenderer destroyAllItems];
    /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }
    
    /**销毁道具后，重置默认参数*/
    [self setDefaultParameters];
}

/**
 获取item的提示语

 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return hintDic[item];
}

#pragma -Faceunity Load Data
/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
{
    dispatch_async(loadItemQueue, ^{
        BOOL isAnimoji = [itemName isEqualToString:@"houzi"];
        // 开启优化表情校准功能
        fuSetExpressionCalibration(isAnimoji ? 1:0);
        
        /**如果取消了道具的选择，直接销毁道具*/
        if ([itemName isEqual: @"noitem"] || itemName == nil)
        {
            if (items[1] != 0) {
                
                NSLog(@"faceunity: destroy item");
                [FURenderer destroyItem:items[1]];
                
                /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[1]设为0*/
                items[1] = 0;
            }
            if ([self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
                [self.delegate didSelectedItem:itemName];
            }
            return;
        }
        
        /**先创建道具句柄*/
        NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        
        int itemHandle = [FURenderer itemWithContentsOfFile:path];
        
        /**销毁老的道具句柄*/
        if (items[1] != 0) {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:items[1]];
        }
        
        /**将刚刚创建的句柄存放在items[1]中*/
        items[1] = itemHandle;
        
        NSLog(@"faceunity: load item");
        
        if ([self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
            [self.delegate didSelectedItem:itemName];
        }
    });
    
}

/**加载美颜道具*/
- (void)loadFilter
{
    dispatch_async(loadItemQueue, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
        NSData *itemData = [[NSData alloc] initWithContentsOfFile:path];
        items[0] = fuCreateItemFromPackage((void *)itemData.bytes, (int)itemData.length);
        [FURenderer itemSetParam:items[0] withName:@"facewarp_version" value:@(0)]; //老版美颜
        [FURenderer itemSetParam:items[0] withName:@"eye_bright" value:@(0)]; // 亮眼
        [FURenderer itemSetParam:items[0] withName:@"tooth_whiten" value:@(0)];// 美牙
    });
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    if (items[2] != 0) {
        NSLog(@"faceunity: destroy gesture");
        [FURenderer destroyItem:items[2]];
        
        items[2] = 0;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
    items[2] = [FURenderer itemWithContentsOfFile:path];
}

/**设置美颜参数*/
- (void)setBeautyParams
{
    /*设置美颜效果（滤镜、磨皮、美白、红润、瘦脸、大眼....）*/
    [FURenderer itemSetParam:items[0] withName:@"filter_name" value:self.selectedFilter]; //滤镜名称
    [FURenderer itemSetParam:items[0] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
    [FURenderer itemSetParam:items[0] withName:@"blur_level" value:@(self.selectedBlur)]; //磨皮 (0、1、2、3、4、5、6)
    [FURenderer itemSetParam:items[0] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[0] withName:@"color_level" value:@(self.beautyLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3) 默认：3，女神：0，网红：1，自然：2
    [FURenderer itemSetParam:items[0] withName:@"face_shape_level" value:@(self.faceShapeLevel)]; //美型等级 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"eye_enlarging" value:@(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:items[0] withName:@"cheek_thinning" value:@(self.thinningLevel)]; //瘦脸 (0~1)
    
}

/**将道具绘制到pixelBuffer*/
- (void)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    /**设置美颜参数*/
    [self setBeautyParams];
    
    [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:3 flipx:NO];
    
    frameID += 1;
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.5, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = frameSize.width - centerX;
    centerX = centerX / frameSize.width;
    
    centerY = frameSize.height - centerY;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks
{
    int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange
{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}
    
- (BOOL)isCalibrating{
    float is_calibrating[1] = {0.0};
    
    [FURenderer getFaceInfo:0 name:@"is_calibrating" pret:is_calibrating number:1];
    
    return is_calibrating[0] == 1.0;
}

@end
