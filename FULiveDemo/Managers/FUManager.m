//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
#import "authpack.h"
#import <sys/utsname.h>
#import "FURenderer+header.h"


@interface FUManager ()
{
    //MARK: Faceunity
    
    /*
     0.美颜
     1.普通道具
     2.考锯齿
     3.美妆
     */
    
    int items[4];
    int frameID;
    
    NSDictionary *hintDic;
    
    NSDictionary *alertDic ;
}

@property (nonatomic) int deviceOrientation;
@property (nonatomic) int faceNum;
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
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
        int ret2 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
        NSLog(@"fuLoadTongueModel %@",ret2 == 0 ? @"failure":@"success" );
        
        NSLog(@"sdk-------%@",[FURenderer getVersion]);
        //
//        
//        // 性能优先关闭
//        self.performance = NO ;
    }
    
    return self;
}


- (void)loadAllItems{    
    /**加载美颜道具*/
    [self loadFilter];
    
    [self loadMakeup];
    /**加载普通道具*/
    [self loadItem:nil];
    
    [self loadAnimojiFaxxBundle];
    
}


/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setMaxFaces:(int)maxFace{
    if (0 >= maxFace || maxFace >8) {
        return;
    }
    if (_faceNum == maxFace) {//相等不设置
        return;
    }
    _faceNum = maxFace;
    [FURenderer setMaxFaces:maxFace];
    
}

/**销毁全部道具*/
- (void)destoryAllItems
{
    [FURenderer destroyAllItems];    
    /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
    for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
        items[i] = 0;
    }    
    /**销毁道具后，清除context缓存*/
    [FURenderer OnDeviceLost];

}

- (void)destoryAnimojiFaxxBundle {    
    /**销毁老的道具句柄*/
    if (items[2] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[2]];
        items[2] = 0 ;
    }
    
}

#pragma -Faceunity Load Data

/**加载美颜道具*/
- (void)loadFilter{
    if (items[0] == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
//        items[0] = [FURenderer itemWithContentsOfFile:path];
        
        NSData *itemData = [[NSData alloc] initWithContentsOfFile:path];
        self -> items[0] = fuCreateItemFromPackage((void *)itemData.bytes, (int)itemData.length);
        [FURenderer itemSetParam:items[0] withName:@"is_opengl_es" value:@(0)];//mac端隐藏设置
    }
}

-(void)loadMakeup{
    NSString *makeBundlePath = [[NSBundle mainBundle] pathForResource:@"light_makeup.bundle" ofType:nil];
    self -> items[3] = [FURenderer itemWithContentsOfFile:makeBundlePath];
    
  //  [self setMakeupItemParamImage:[NSImage imageNamed:@"mu_eyebrow_19"] param:@"tex_brow"];
}

/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName
{
    //    self.selectedItem = itemName ;
    
    int destoryItem = items[1];
    if (itemName != nil && ![itemName isEqual: @"noitem"]) {
        /**先创建道具句柄*/
        
        //        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", itemName]];
        //
        //        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //            path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        //        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
        
        int itemHandle = [FURenderer itemWithContentsOfFile:path];
        
        // 人像驱动 设置 3DFlipH
        BOOL isPortraitDrive = [itemName hasPrefix:@"picasso_e"];
        BOOL isAnimoji = [itemName hasSuffix:@"_Animoji"];
        if (isPortraitDrive) {
            [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(0)];
            [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(0)];

        }
        if (isAnimoji) {
            [FURenderer itemSetParam:itemHandle withName:@"{\"thing\":\"<global>\",\"param\":\"follow\"}" value:@(1)];
            [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(0)];
            [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(0)];
            [FURenderer itemSetParam:itemHandle withName:@"isFlipTrack" value:@(0)];
            [FURenderer itemSetParam:itemHandle withName:@"isFlipLight" value:@(0)];
        }
        
        if ([itemName isEqualToString:@"luhantongkuan_ztt_fu"]) {
            [FURenderer itemSetParam:itemHandle withName:@"flip_action" value:@(1)];
        }
        /**将刚刚创建的句柄存放在items[1]中*/
        items[1] = itemHandle;
    }else{
        /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[1]设为0*/
        items[1] = 0;
    }
    NSLog(@"faceunity: load item");
    
    /**后销毁老道具句柄*/
    if (destoryItem != 0)
    {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:destoryItem];
    }
}



- (void)loadAnimojiFaxxBundle {
    /**先创建道具句柄*/
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa.bundle" ofType:nil];
    int itemHandle = [FURenderer itemWithContentsOfFile:path];
    
    /**销毁老的道具句柄*/
    if (items[2] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[2]];
    }
    
    /**将刚刚创建的句柄存放在items[2]中*/
    items[2] = itemHandle;
}


- (int)changeParamsStr:(NSString *)sdkStr index:(int)index value:(id)value{
    if (!sdkStr || [sdkStr isEqualToString:@""] || index >= sizeof(items)/sizeof(items[0]) ) {
        NSLog(@"-------设置参数有误");
        return 0;
    }
    int r = [FURenderer itemSetParam:items[index] withName:sdkStr value:value];
    if (r != 1) {
        NSLog(@"(%@)(%f)(return - %d)(item - %d) - sdk 设置失败",sdkStr,[value floatValue],r,items[index]);
    }
    return r;
}


/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:NO];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    return buffer;
}

- (void)set3DFlipH {
    
    [FURenderer itemSetParam:items[1] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"isFlipExpr" value:@(1)];
}

- (void)setLoc_xy_flip {
    
    [FURenderer itemSetParam:items[1] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[1] withName:@"loc_y_flip" value:@(1)];
}


- (void)musicFilterSetMusicTimeValue:(id)value {
    
    [FURenderer itemSetParam:items[1] withName:@"music_time" value:value];
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
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
-(void)setMakeupItemParamImage:(NSImage *)image param:(NSString *)paramStr{
        if (!image) {
            NSLog(@"美妆图片为空");
            return;
        }
       [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
      NSData *imageData = [image TIFFRepresentation];
      NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:imageData];
      NSSize size = NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
    unsigned char *aaaa = (unsigned char *)[imageData bytes]; //[self convertSourceImageToBitmapRGBA:image];

      [[FURenderer shareRenderer] setUpCurrentContext];
//      fuItemSetParamd(items[3], "reverse_alpha", 0.0);
      int ret = fuCreateTexForItem(items[3], (char *)[paramStr UTF8String], aaaa, size.width, size.height);
      [[FURenderer shareRenderer] setBackCurrentContext];
    NSLog(@"美妆设置---Parma（%@）  ret : %d",paramStr,ret);
}


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
-(void)setMakeupItemIntensity:(float )value param:(NSString *)paramStr{
    if (!paramStr && paramStr) {
        NSLog(@"参数为nil");
    }
    if (items[3]) {
        int res = fuItemSetParamd(items[3], (char *)[paramStr UTF8String], value);
        if (!res) NSLog(@"美妆设置失败---Parma（%@）---value(%lf)",paramStr,value);
            
        }else{
            NSLog(@"美妆设置--bundle(nil)");
    }
}

-(void)setMakeupItemLipstick:(double *)lipData{
    //nama

    [[FURenderer shareRenderer] setUpCurrentContext];
//    fuItemSetParamd(items[3], "reverse_alpha", 1.0);
    fuItemSetParamdv(items[3], "makeup_lip_color", lipData, 4);
    [[FURenderer shareRenderer] setBackCurrentContext];
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


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}




#pragma  mark -  工具


-(unsigned char *)convertSourceImageToBitmapRGBA:(NSImage *)image{
    //由NSImage创建CGImageRef
    struct CGImageSource* source = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             (id)kCFBooleanFalse, (id)kCGImageSourceShouldCache,
                             (id)kCFBooleanTrue, (id)kCGImageSourceShouldAllowFloat,
                             nil];
    CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)options);
    
    //由CGImageRef创建CGContextRef
    CGContextRef context = [self newBitmapRGBA8ContextFromImage:imageRef];
    if (!context) {
        NSLog(@"picProcessing::convertSourceImageToBitmapRGBA:failed to create a context!");
        return nil;
    }
    
    //获取CGImageRef的宽高，并将CGImageRef画到CGContextRef中，以获取rawdata
    float imageWidth = CGImageGetWidth(imageRef);
    float imageHeight = CGImageGetHeight(imageRef);
    float bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    CGRect imgRect = CGRectMake(0, 0, imageWidth, imageHeight);
    CGContextDrawImage(context, imgRect, imageRef);
    
    //获取CGContextRef中的rawdata的指针
    unsigned char * bitmapData = CGBitmapContextGetData(context);
    
    return bitmapData;
}

-(CGContextRef)newBitmapRGBA8ContextFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesperRow = width * bytesPerPixel;
    size_t bufferLength = bytesperRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    
    if(!bitmapData) {
        NSLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    
    context = CGBitmapContextCreate(bitmapData,
                                    width,
                                    height,
                                    bitsPerComponent,
                                    bytesperRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);    // RGBA
    if(!context) {
        free(bitmapData);
        NSLog(@"picProcessing::newBitmapRGBA8ContextFromImage:Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@end
