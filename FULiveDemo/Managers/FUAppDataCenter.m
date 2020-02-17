//
//  FUAppDataCenter.m
//  FULive
//
//  Created by 孙慕 on 2018/8/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUAppDataCenter.h"
#import "FUManager.h"
#import "MJExtension.h"

@interface FUAppDataCenter()
/* 美妆UI */
@property (retain) NSArray <FUPropItemModel *> *makeupArray;
/* 不普通道具 */
@property (retain) NSArray <FUPropItemModel *> *normalArray;
@end

@implementation FUAppDataCenter

static FUAppDataCenter *shareManager = NULL;
+ (FUAppDataCenter *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUAppDataCenter alloc] init];
        
    });
    
    return shareManager;
}

-(instancetype)init{
    if (self = [super init]) {
        /* 初始化数据 */
        [self initializationSkinData];//美肤
        [self initializationBeautyData];//美型
        [self initializationFilterData]; //滤镜
        [self initializationPropItemData];//道具贴图
        [self initializationMakeupData];
        
        _propItemModelArray = _normalArray;
    }
    return self;
}

/* 初始化美肤数据 */
- (void)initializationSkinData{
    FUValueRect rect1 = {0,1};
    FUValueRect rect2 = {0,6};
    NSMutableArray <FUBeautyModel *>*mutArray = [NSMutableArray array];
    /* 精准美肤 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"精准美肤" openImgStr:@"list_icon_skinbeauty_open" closeImgStr:@"list_icon_skinbeauty_Close" type:FUBeautyModelTypeSwitch sdkStr:@"skin_detect" defaultValue:1 rect:rect1 strArray:@[@"开启",@"关闭"]]];
    /* 美肤模式 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"美肤模式" openImgStr:@"list_icon_BeautyMode_open" closeImgStr:@"list_icon_BeautyMode_Close" type:FUBeautyModelTypeSelect sdkStr:@"blur_type" defaultValue:2 rect:rect1 strArray:@[@"精细磨皮",@"清晰磨皮",@"朦胧磨皮"]]];
    /* 磨皮 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"磨皮" openImgStr:@"list_icon_Grindingskin_open" closeImgStr:@"list_icon_Grindingskin_Close" type:FUBeautyModelTypeRange sdkStr:@"blur_level" defaultValue:4.2 rect:rect2 strArray:nil]];
    /* 美白 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"美白" openImgStr:@"list_icon_Skinwhitening_open" closeImgStr:@"list_icon_Skinwhitening_Close" type:FUBeautyModelTypeRange sdkStr:@"color_level" defaultValue:0.5 rect:rect1 strArray:nil]];
    /* 红润 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"红润" openImgStr:@"list_icon_Ruddy_open" closeImgStr:@"list_icon_Ruddy_Close" type:FUBeautyModelTypeRange sdkStr:@"red_level" defaultValue:0.5 rect:rect1 strArray:nil]];
    /* 亮眼 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"亮眼" openImgStr:@"list_icon_Brighteye_open" closeImgStr:@"list_icon_Brighteye_Close" type:FUBeautyModelTypeRange sdkStr:@"eye_bright" defaultValue:0.7 rect:rect1 strArray:nil]];
    /* 美牙 */
    [mutArray addObject:[FUBeautyModel GetModelClassTitle:@"美牙" openImgStr:@"list_iconBeautifulteeth_open" closeImgStr:@"list_iconBeautifulteeth_Close" type:FUBeautyModelTypeRange sdkStr:@"tooth_whiten" defaultValue:0.7 rect:rect1 strArray:nil]];
    
    self.skinModelArray = mutArray;
}

/* 初始化美型数据 */
- (void)initializationBeautyData{
    FUValueRect rect1 = {0,1};
    FUValueRect rect2 = {-0.5,0.5};
    NSMutableArray <FUBeautyModel *>*mutArray1 = [NSMutableArray array];
    NSMutableArray <FUBeautyModel *>*mutArray2 = [NSMutableArray array];
    /* 脸型 */
    FUBeautyModel *model = [FUBeautyModel GetModelClassTitle:@"脸型" openImgStr:@"list_icon_Facetype_open" closeImgStr:nil type:FUBeautyModelTypeSelect sdkStr:@"face_shape" defaultValue:4 rect:rect1 strArray:@[@"自定义",@"默认",@"女神",@"网红",@"自然"]];
    [mutArray1 addObject:model];
    [mutArray2 addObject:model];//共享第一模型内存
    // 瘦脸 */
    [mutArray2 addObject:[FUBeautyModel GetModelClassTitle:@"瘦脸" openImgStr:@"list_icon_Thinface_open" closeImgStr:@"list_icon_Thinface_Close" type:FUBeautyModelTypeRange sdkStr:@"cheek_thinning" defaultValue:0.4 rect:rect1 strArray:nil]];
    /* 大眼 */
    [mutArray2 addObject:[FUBeautyModel GetModelClassTitle:@"大眼" openImgStr:@"list_icon_Bigeye_open" closeImgStr:@"list_icon_Bigeye_Close" type:FUBeautyModelTypeRange sdkStr:@"eye_enlarging" defaultValue:0.4 rect:rect1 strArray:nil]];
    
    
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"瘦脸" openImgStr:@"list_icon_Thinface_open" closeImgStr:@"list_icon_Thinface_Close" type:FUBeautyModelTypeRange sdkStr:@"cheek_thinning" defaultValue:0.4 rect:rect1 strArray:nil]];
    /* V脸 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"V脸" openImgStr:@"list_icon_v_open" closeImgStr:@"list_icon_v_close" type:FUBeautyModelTypeRange sdkStr:@"cheek_v" defaultValue:0.4 rect:rect1 strArray:nil]];
    /* 窄脸 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"窄脸" openImgStr:@"list_icon_narrow_face_open" closeImgStr:@"list_icon_narrow_face_close" type:FUBeautyModelTypeRange sdkStr:@"cheek_narrow" defaultValue:0 rect:rect1 strArray:nil]];
    /* 小脸 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"小脸" openImgStr:@"list_icon_little_face_open" closeImgStr:@"list_icon_little_face_close" type:FUBeautyModelTypeRange sdkStr:@"cheek_small" defaultValue:0 rect:rect1 strArray:nil]];
    
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"大眼" openImgStr:@"list_icon_Bigeye_open" closeImgStr:@"list_icon_Bigeye_Close" type:FUBeautyModelTypeRange sdkStr:@"eye_enlarging" defaultValue:0.4 rect:rect1 strArray:nil]];
    /* 下巴 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"下巴" openImgStr:@"list_icon_chin_open" closeImgStr:@"list_icon_chin_Close" type:FUBeautyModelTypeRange sdkStr:@"intensity_chin" defaultValue:0.3 rect:rect2 strArray:nil]];
    /* 额头 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"额头" openImgStr:@"list_icon_forehead_open" closeImgStr:@"list_icon_forehead_Close" type:FUBeautyModelTypeRange sdkStr:@"intensity_forehead" defaultValue:0.3 rect:rect2 strArray:nil]];
    /* 瘦鼻 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"瘦鼻" openImgStr:@"list_icon_Thinnose_open" closeImgStr:@"list_icon_Thinnose_Close" type:FUBeautyModelTypeRange sdkStr:@"intensity_nose" defaultValue:0.5 rect:rect1 strArray:nil]];
    /* 嘴型 */
    [mutArray1 addObject:[FUBeautyModel GetModelClassTitle:@"嘴型" openImgStr:@"list_icon_Mouthtype_open" closeImgStr:@"list_icon_Mouthtype_Close" type:FUBeautyModelTypeRange sdkStr:@"intensity_mouth" defaultValue:0.4 rect:rect2 strArray:nil]];
    
    self.beautyModelCustomArray = mutArray1;
    self.beautyModeldefaultArray = mutArray2;
    
}


-(void)initializationFilterData{
    NSMutableArray <FUFilterModel *>*mutArray = [NSMutableArray array];
    [mutArray addObject:[FUFilterModel GetModelClassTitle:@"原图" imgStr:@"list_image_origin" sdkStr:@"filter_name" styleStr:@"origin" valueSdkStr:@"filter_level" value:0.0]];
    [mutArray addObject:[FUFilterModel GetModelClassTitle:@"白亮" imgStr:@"list_image_bailiang" sdkStr:@"filter_name" styleStr:@"bailiang1" valueSdkStr:@"filter_level" value:0.7]];
    [mutArray addObject:[FUFilterModel GetModelClassTitle:@"粉嫩" imgStr:@"list_image_fennen" sdkStr:@"filter_name" styleStr:@"fennen1" valueSdkStr:@"filter_level" value:0.7]];
    [mutArray addObject:[FUFilterModel GetModelClassTitle:@"冷色调" imgStr:@"list_image_lengsediao" sdkStr:@"filter_name" styleStr:@"lengsediao1" valueSdkStr:@"filter_level" value:0.7]];
    [mutArray addObject:[FUFilterModel GetModelClassTitle:@"暖色调" imgStr:@"list_image_nuansediao" sdkStr:@"filter_name" styleStr:@"nuansediao1" valueSdkStr:@"filter_level" value:0.7]];
        [mutArray addObject:[FUFilterModel GetModelClassTitle:@"小清晰" imgStr:@"list_image_xiaoqingxin" sdkStr:@"filter_name" styleStr:@"xiaoqingxin1" valueSdkStr:@"filter_level" value:0.7]];
    
    self.filterModelArray = mutArray;
}


-(void)initializationPropItemData{
    //Animoji
    NSArray <FUPropSubItemModel *>*subItems0 = @[
                         [FUPropSubItemModel GetClassSubImageStr:@"qgirl_Animoji" sdkStr:@"qgirl_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"baimao_Animoji" sdkStr:@"baimao_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"douniuquan_Animoji" sdkStr:@"douniuquan_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"frog_Animoji" sdkStr:@"frog_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"hashiqi_Animoji" sdkStr:@"hashiqi_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"hetun_Animoji" sdkStr:@"hetun_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"huangya_Animoji" sdkStr:@"huangya_Animoji"],
                         [FUPropSubItemModel GetClassSubImageStr:@"kulutou_Animoji" sdkStr:@"kulutou_Animoji"]];
                        
                         
    FUPropItemModel *model0 = [FUPropItemModel GetClassTitle:@"Animoji" hoverImageStr:@"list_icon_annimoji_hover" norImageStr:@"list_icon_annimoji_nor" subItems:subItems0 type:FULiveModelTypeAnimoji maxFace:4];
    //道具贴纸
    NSArray <FUPropSubItemModel *>*subItems1 = @[[FUPropSubItemModel GetClassSubImageStr:@"fengya_ztt_fu" sdkStr:@"fengya_ztt_fu"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"hudie_lm_fu" sdkStr:@"hudie_lm_fu"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"touhua_ztt_fu" sdkStr:@"touhua_ztt_fu"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"juanhuzi_lm_fu" sdkStr:@"juanhuzi_lm_fu"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_hat" sdkStr:@"mask_hat"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"yazui" sdkStr:@"yazui"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"yuguan" sdkStr:@"yuguan"]];
    FUPropItemModel *model1 = [FUPropItemModel GetClassTitle:@"道具贴纸" hoverImageStr:@"list_icon_Propmap_hover" norImageStr:@"list_icon_Propmap_nor" subItems:subItems1 type:FULiveModelTypeItems maxFace:4];
    
    //AR面具
    NSArray <FUPropSubItemModel *>*subItems2 = @[
                                               [FUPropSubItemModel GetClassSubImageStr:@"bluebird_180718" sdkStr:@"bluebird_180718"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"lanhudie" sdkStr:@"lanhudie"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"fenhudie" sdkStr:@"fenhudie"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"tiger_huang_180718" sdkStr:@"tiger_huang_180718"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"tiger_bai_180718" sdkStr:@"tiger_bai_180718"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"afd" sdkStr:@"afd"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"baozi" sdkStr:@"baozi"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"tiger" sdkStr:@"tiger"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"xiongmao" sdkStr:@"xiongmao"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"armesh" sdkStr:@"armesh"]];
    FUPropItemModel *model2 = [FUPropItemModel GetClassTitle:@"AR面具" hoverImageStr:@"list_icon_AR_hover" norImageStr:@"list_icon_AR_nor" subItems:subItems2 type:FULiveModelTypeARMarsk maxFace:4];
    
    //换脸
//    NSArray <FUPropSubItemModel *>*subItems3 = @[
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_liudehua" sdkStr:@"mask_liudehua"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_linzhiling" sdkStr:@"mask_linzhiling"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_luhan" sdkStr:@"mask_luhan"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_guocaijie" sdkStr:@"mask_guocaijie"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_huangxiaoming" sdkStr:@"mask_huangxiaoming"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_matianyu" sdkStr:@"mask_matianyu"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"mask_tongliya" sdkStr:@"mask_tongliya"]];
//    FUPropItemModel *model3 = [FUPropItemModel GetClassTitle:@"换脸" hoverImageStr:@"list_icon_Changeface_hover" norImageStr:@"list_icon_Changeface_nor" subItems:subItems3 type:FULiveModelTypeFaceChange maxFace:4];
    
    //表情识别
    NSArray <FUPropSubItemModel *>*subItems4 = @[[FUPropSubItemModel GetClassSubImageStr:@"future_warrior" sdkStr:@"future_warrior" hint:@"张嘴试试"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"jet_mask" sdkStr:@"jet_mask" hint:@"鼓腮帮子"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"sdx2" sdkStr:@"sdx2" hint:@"皱眉触发"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"luhantongkuan_ztt_fu" sdkStr:@"luhantongkuan_ztt_fu" hint:@"眨一眨眼"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"qingqing_ztt_fu" sdkStr:@"qingqing_ztt_fu" hint:@"嘟嘴试试"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"xiaobianzi_zh_fu" sdkStr:@"xiaobianzi_zh_fu" hint:@"微笑触发"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"xiaoxueshen_ztt_fu" sdkStr:@"xiaoxueshen_ztt_fu" hint:@"吹气触发"]];
    FUPropItemModel *model4 = [FUPropItemModel GetClassTitle:@"表情识别" hoverImageStr:@"list_icon_Expressionrecognition_hover" norImageStr:@"list_icon_Expressionrecognition_no" subItems:subItems4 type:FULiveModelTypeExpressionRecognition maxFace:4];
    
    //音乐滤镜
    NSArray <FUPropSubItemModel *>*subItems5 = @[[FUPropSubItemModel GetClassSubImageStr:@"douyin_01" sdkStr:@"douyin_01"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"douyin_02" sdkStr:@"douyin_02"]];
    FUPropItemModel *model5 = [FUPropItemModel GetClassTitle:@"音乐滤镜" hoverImageStr:@"list_icon_Musicfilter_hover" norImageStr:@"list_icon_Musicfilter_nor" subItems:subItems5 type:FULiveModelTypeMusicFilter maxFace:4];
    
    //背景分割
    NSArray <FUPropSubItemModel *>*subItems6 = @[[FUPropSubItemModel GetClassSubImageStr:@"hez_ztt_fu" sdkStr:@"hez_ztt_fu" hint:@"张嘴试试"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"gufeng_zh_fu" sdkStr:@"gufeng_zh_fu"],
//                                                 [FUPropSubItemModel GetClassSubImageStr:@"men_ztt_fu" sdkStr:@"men_ztt_fu"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"xiandai_ztt_fu" sdkStr:@"xiandai_ztt_fu"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"sea_lm_fu" sdkStr:@"sea_lm_fu"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"ice_lm_fu" sdkStr:@"ice_lm_fu"]];
    FUPropItemModel *model6 = [FUPropItemModel GetClassTitle:@"背景分割" hoverImageStr:@"list_icon_Bgsegmentation_hover" norImageStr:@"list_icon_Bgsegmentation_nor" subItems:subItems6 type:FULiveModelTypeBGSegmentation maxFace:1];
    
    //手势识别
    NSArray <FUPropSubItemModel *>*subItems7 = @[[FUPropSubItemModel GetClassSubImageStr:@"fu_lm_koreaheart" sdkStr:@"fu_lm_koreaheart" hint:@"单手手指比心"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"fu_zh_baoquan" sdkStr:@"fu_zh_baoquan" hint:@"双手抱拳"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"fu_zh_hezxiong" sdkStr:@"fu_zh_hezxiong" hint:@"双手合十"],
//                                               [FUPropSubItemModel GetClassSubImageStr:@"fu_ztt_live520" sdkStr:@"fu_ztt_live520" hint:@"双手比心"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"ssd_thread_cute" sdkStr:@"ssd_thread_cute" hint:@"双拳靠近脸颊卖萌"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"ssd_thread_six" sdkStr:@"ssd_thread_six" hint:@"比个六"]
//                                                 ,
//                                               [FUPropSubItemModel GetClassSubImageStr:@"ssd_thread_thumb" sdkStr:@"ssd_thread_thumb" hint:@"竖个拇指"]
                                                 ];
    FUPropItemModel *model7 = [FUPropItemModel GetClassTitle:@"手势识别" hoverImageStr:@"list_icon_gesturerecognition_hover" norImageStr:@"list_icon_gesturerecognition_nor" subItems:subItems7 type:FULiveModelTypeGestureRecognition maxFace:4];
    
    //哈哈镜
    NSArray <FUPropSubItemModel *>*subItems8 = @[[FUPropSubItemModel GetClassSubImageStr:@"facewarp2" sdkStr:@"facewarp2"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"facewarp3" sdkStr:@"facewarp3"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"facewarp4" sdkStr:@"facewarp4"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"facewarp5" sdkStr:@"facewarp5"],
                                               [FUPropSubItemModel GetClassSubImageStr:@"facewarp6" sdkStr:@"facewarp6"]];
    FUPropItemModel *model8 = [FUPropItemModel GetClassTitle:@"哈哈镜" hoverImageStr:@"list_icon_Hahamirror_hover" norImageStr:@"list_icon_Hahamirror_nor" subItems:subItems8 type:FULiveModelTypeHahaMirror maxFace:4];
    
    //人像驱动
    NSArray <FUPropSubItemModel *>*subItems9 = @[[FUPropSubItemModel GetClassSubImageStr:@"picasso_e1" sdkStr:@"picasso_e1"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"picasso_e2" sdkStr:@"picasso_e2"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"picasso_e3" sdkStr:@"picasso_e3"]];
    FUPropItemModel *model9 = [FUPropItemModel GetClassTitle:@"人像驱动" hoverImageStr:@"list_icon_Portraitdrive_hover" norImageStr:@"list_icon_Portraitdrive_nor" subItems:subItems9 type:FULiveModelTypePortraitDrive maxFace:1];
    
    
    _normalArray = @[model0,model1,model2,model4,model5,model6,model7,model8,model9];
}

-(void)initializationMakeupData{
    
    NSArray <FUPropSubItemModel *>*subItems0 = @[[FUPropSubItemModel GetClassSubImageStr:@"demo_combination_sexy" sdkStr:@"01_xinggan"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_sweet" sdkStr:@"02_tianmei"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_neighbor_girl" sdkStr:@"03_linjia"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_occident" sdkStr:@"04_oumei"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_charming" sdkStr:@"05_wumei"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_flower" sdkStr:@"zhuti01"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_tough_guy" sdkStr:@"zhuti05"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_moon" sdkStr:@"zhuti02"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_coral" sdkStr:@"zhuti04"],
                                                 [FUPropSubItemModel GetClassSubImageStr:@"demo_combination_lady" sdkStr:@"zhuti03"]];
    FUPropItemModel *model = [FUPropItemModel GetClassTitle:@"美妆" hoverImageStr:@"list_icon_makeup_hover" norImageStr:@"list_icon_makeup_nor" subItems:subItems0 type:FULiveModelTypePortraitDrive maxFace:1];
    
    
    _makeupArray = @[model];
}




#pragma  mark ----  public接口  -----
/* 更改美颜参数 */
-(void)changeBeautyParams:(NSMutableArray <FUBeautyModel *>*)array{
    if (array == nil) {
        if (_beautyModeldefaultArray.firstObject.currentValue.value == 4) {//自定义
            [self setSDKBeautyParams:_beautyModelCustomArray];
        }else{
            [self setSDKBeautyParams:_beautyModeldefaultArray];
        }
        [self setSDKBeautyParams:_skinModelArray];
    }else{
        [self setSDKBeautyParams:array];
    }

}

-(void)changePropData:(FUPropItemType)type{
    if (type == FUPropItemTypeMakeup) {
        _propItemModelArray = _makeupArray;
    }
    
    if (type == FUPropItemTypeNormal) {
        _propItemModelArray = _normalArray;
    }
}

static int oldHandle = 0;
-(void)setMakeupWithDataIndex:(int)index{
    if (![[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup]) {
        [[FUManager shareManager] loadBundleWithName:@"face_makeup" aboutType:FUNamaHandleTypeMakeup];
        [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
    }
    
    int makeupHandle = [[FUManager shareManager] getHandleAboutType:FUNamaHandleTypeMakeup];
    NSString *path = [[NSBundle mainBundle] pathForResource:_makeupArray[0].subItems[index].subSdkStr ofType:@"bundle"];
    int subHandle =  [FURenderer itemWithContentsOfFile:path];
    
    if (oldHandle) {//存在旧美妆道具，先销毁
         [FURenderer unBindItems:makeupHandle items:&oldHandle itemsCount:1];
         [FURenderer destroyItem:oldHandle];
         oldHandle = 0;
    }
    [FURenderer bindItems:makeupHandle items:&subHandle itemsCount:1];
    oldHandle = subHandle;
    
}

-(void)setSelSubItem:(FUSingleMakeupModel *)modle{
    /* 妆容素材图 */
    [[FUManager  shareManager] changeParamsStr:modle.namaTypeStr index:FUNamaHandleTypeMakeup image:[NSImage imageNamed:modle.namaImgStr]];
    if(modle.makeType == FUMakeupModelTypeEye){//眼影
        [[FUManager  shareManager] changeParamsStr:@"tex_eye2" index:FUNamaHandleTypeMakeup image:[NSImage imageNamed:modle.tex_eye2]];
        [[FUManager  shareManager] changeParamsStr:@"tex_eye2" index:FUNamaHandleTypeMakeup image:[NSImage imageNamed:modle.tex_eye3]];
    }
    
    /* 妆容颜色 */
    if (modle.colorStrV.count) {
        if (modle.makeType == FUMakeupModelTypeLip && modle.is_two_color) {
            [[FUManager shareManager] changeParamsStr:modle.colorStr2 index:FUNamaHandleTypeMakeup valueArr:modle.colorStr2V];
        }
         [[FUManager shareManager] changeParamsStr:modle.colorStr index:FUNamaHandleTypeMakeup valueArr:modle.colorStrV];
    }
    
    /* 值 */
    if(modle.makeType == FUMakeupModelTypeBrow){//眉毛形变开启
        [[FUManager shareManager] changeParamsStr:@"brow_warp" index:FUNamaHandleTypeMakeup value:@(modle.brow_warp)];
        [[FUManager shareManager] changeParamsStr:@"brow_warp_type" index:FUNamaHandleTypeMakeup value:@(modle.brow_warp_type)];
        
    }else if(modle.makeType == FUMakeupModelTypeLip){
        [[FUManager shareManager] changeParamsStr:@"lip_type" index:FUNamaHandleTypeMakeup value:@(modle.lip_type)];
        [[FUManager shareManager] changeParamsStr:@"is_two_color" index:FUNamaHandleTypeMakeup value:@(modle.is_two_color)];
    }
      [[FUManager shareManager] changeParamsStr:modle.namaValueStr index:FUNamaHandleTypeMakeup value:@(modle.value)];
    
    /* 有可选色 */
//    if (modle.colors.count) {
//        /* 选中一个颜色 */
//        [[FUManager shareManager] changeParamsStr:modle.colorStr index:FUNamaHandleTypeMakeup valueArr:modle.colors[modle.defaultColorIndex]];;
//    }
    
}
#pragma  mark ----  private  -----

/**
 调整sdk 美颜参数值

 @param array 美颜数据数组
 */
-(void)setSDKBeautyParams:(NSMutableArray <FUBeautyModel *>*)array{
    for (FUBeautyModel *model in array) {
        if (model.type == FUBeautyModelTypeSwitch) {
            [[FUManager shareManager] changeParamsStr:model.currentValue.sdkStr index:0 value:@(model.currentValue.on)];
            [[FUManager shareManager] changeParamsStr:@"blur_type" index:0 value:@(0)];
        }else if (model.type == FUBeautyModelTypeRange){
            [[FUManager shareManager] changeParamsStr:model.currentValue.sdkStr index:0 value:@(model.currentValue.value)];
        }else{
            [[FUManager shareManager] changeParamsStr:model.currentValue.sdkStr index:0 value:@((int)model.currentValue.value)];
        }

    }
}


@end
