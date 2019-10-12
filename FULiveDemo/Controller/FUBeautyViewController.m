//
//  FUBeautyViewController.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUBeautyViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FUAppDataCenter.h"
#import "FUSkinTableView.h"
#import "FUBeautyTableView.h"
#import "FUFilterViewItem.h"
#import "FUManager.h"

@interface FUBeautyViewController ()<NSCollectionViewDataSource,NSCollectionViewDelegate>
/* 美颜切换栏 */
@property (weak) IBOutlet NSView *mItemBarView;
/* tabView */
@property (weak) IBOutlet NSTabView *mBeautyTabView;
/* tab0 美肤 */
@property (weak) IBOutlet FUSkinTableView *mSkinTableView;
/* tab0 美型 */
@property (weak) IBOutlet FUBeautyTableView *mBeautyTableView;
/* 滤镜集合控制器 */
@property (weak) IBOutlet NSCollectionView *mFilterCollectionView;
/* 滤镜程度输入 */
@property (weak) IBOutlet NSTextField *mFilterTef;
/* 滤镜程度滑动 */
@property (weak) IBOutlet NSSlider *mFilterSlider;
/* 风格集合控制器 */
@property (weak) IBOutlet NSCollectionView *mMakeupCollectionView;
/* 风格程度滑动 */
@property (weak) IBOutlet NSSlider *mMakeupSlider;
/* 风格程度输入 */
@property (weak) IBOutlet NSTextField *mMakeupTxf;

/* 选中的索引 */
@property (assign) NSInteger selectFilterIndex;
@property (assign) NSInteger selectStyleIndex;

@property (retain) NSButton *selBtn;
@end

@implementation FUBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupUI];
    _mFilterCollectionView.delegate = self;
    _mFilterCollectionView.dataSource = self;
    
    _mMakeupCollectionView.dataSource = self;
    _mMakeupCollectionView.delegate = self;
    
    //初始状态
    NSUInteger indexes[2] = {0,0};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.mFilterCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
  //  [self.mStyleCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    _mFilterSlider.intValue = [FUAppDataCenter shareManager].filterModelArray[indexPath.item].value * 100;
    _mFilterTef.stringValue = [NSString stringWithFormat:@"%d",_mFilterSlider.intValue];
    _mMakeupSlider.intValue = [FUAppDataCenter shareManager].makeupModelArray[indexPath.item].value * 100;
    _mMakeupSlider.stringValue = [NSString stringWithFormat:@"%d",_mMakeupSlider.intValue];
    
}


-(void)setupUI{
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    self.view.layer.cornerRadius = 5.0f;
    
    self.mBeautyTableView.backgroundColor = FUConstManager.colorForBackground_card;
    self.mSkinTableView.backgroundColor = FUConstManager.colorForBackground_card;
//    self.mFilterCollectionView.backgroundColor = FUConstManager.colorForBackground_card;
    [_mFilterCollectionView enclosingScrollView].backgroundColor = FUConstManager.colorForBackground_card;
    NSArray *colors = @[FUConstManager.colorForBackground_card];
    _mFilterCollectionView.backgroundColors = colors;
    
    [self.mFilterCollectionView setWantsLayer:YES];
    self.mFilterCollectionView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mMakeupCollectionView setWantsLayer:YES];
    self.mMakeupCollectionView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
        
    [self.mItemBarView setWantsLayer:YES];
    self.mItemBarView.layer.backgroundColor = FUConstManager.colorForBackground_page.CGColor;
    
    for (NSView *subView in _mItemBarView.subviews) {
        if ([subView isKindOfClass:[NSButton class]]) {
            [subView setWantsLayer:YES];
            [(NSButton *)subView setTitleColor:FUConstManager.colorForBackground_btnNo font:[NSFont systemFontOfSize:16]];
            if (subView.tag == 101) {//起始选中第一个按钮
                [self chageStyleItem:(NSButton *)subView];
                subView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;

           }
        }
    }
}



-(void)setupSelBtn:(NSButton *)btn{
    for (NSView *subView in _mItemBarView.subviews) {
        if ([subView isKindOfClass:[NSButton class]]) {
            [subView setWantsLayer:YES];
            subView.layer.backgroundColor = [NSColor clearColor].CGColor;
        }
    }
    [btn setWantsLayer:YES];
    btn.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    [btn setTitleColor:FUConstManager.colorForBackground_btnNo font:[NSFont systemFontOfSize:16]];

}

#pragma  mark ----  private方法  -----

// 校验是否为纯数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

#pragma  mark ----  按钮点击事件  -----

- (IBAction)chageStyleItem:(NSButton *)sender {
    if (sender != _selBtn) {
        _selBtn = sender;
        [self setupSelBtn:sender];
    }
    NSLog(@"选中 ----- %ld",sender.tag);
    [self.mBeautyTabView selectTabViewItemAtIndex:sender.tag - 101];
    if (sender.tag - 101 == 2) {//滤镜
    //调整sdk参数
//    [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].value)];
//    [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].sdkStr index:0 value:[[FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].styleStr lowercaseString]];
    }else if(sender.tag - 101 == 3){//质感美妆
      
    //调整sdk参数
//    [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].styleModelArray[_selectFilterIndex].value)];
//    [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].sdkStr index:0 value:[[FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].styleStr lowercaseString]];
    }
 
}
//美肤重置
- (IBAction)resetSkin:(id)sender {
    //数据还原
    for (FUBeautyModel *model in [FUAppDataCenter shareManager].skinModelArray) {
        model.currentValue = [model.defaultValue copy];
    }
    //修改同意修改sdk参数值
    [[FUAppDataCenter shareManager] changeBeautyParams:nil];
    [_mSkinTableView reloadData];
    

}

//美颜重置
- (IBAction)resetBeautySeting:(id)sender {
    int selIndex = [FUAppDataCenter shareManager].beautyModelCustomArray[0].currentValue.value;//保存第一栏，选中位数
    if ([FUAppDataCenter shareManager].beautyModelCustomArray[0].currentValue.value != 4) {//非自定义
        for (FUBeautyModel *model in [FUAppDataCenter shareManager].beautyModeldefaultArray) {
            _mBeautyTableView.dataArray = [FUAppDataCenter shareManager].beautyModeldefaultArray;
            model.currentValue = [model.defaultValue copy];
        }
    }else{
        for (FUBeautyModel *model in [FUAppDataCenter shareManager].beautyModelCustomArray) {
            _mBeautyTableView.dataArray = [FUAppDataCenter shareManager].beautyModelCustomArray;
            model.currentValue = [model.defaultValue copy];
        }
    }
    [FUAppDataCenter shareManager].beautyModelCustomArray[0].currentValue.value = selIndex;
    [[FUAppDataCenter shareManager] changeBeautyParams:nil];
    [_mBeautyTableView reloadData];
}


- (IBAction)sliderDidChange:(NSSlider *)sender {
    NSLog(@"slideValu ----- %ld",(long)sender.integerValue);
    if (sender == _mFilterSlider) {
        [_mFilterTef setStringValue:[NSString stringWithFormat:@"%d",sender.intValue]];
        [FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].value = sender.floatValue/100;
        //调整sdk参数
        [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].value)];
        
    }else if (sender == _mMakeupSlider){
        [_mMakeupTxf setStringValue:[NSString stringWithFormat:@"%d",sender.intValue]];
        FUMakeupModle *model = [FUAppDataCenter shareManager].makeupModelArray[_selectStyleIndex];
        
        model.value = sender.floatValue/100;
        model.selectedFilterLevel = sender.floatValue/100;
        //调整sdk参数
        for (int i = 0; i < model.makeups.count; i ++) {
            if (!model.makeups[i].namaValueStr || [model.makeups[i].namaValueStr isEqualToString:@""]) {
                return;
            }
            [[FUManager shareManager] setMakeupItemIntensity:model.value * model.makeups[i].value param:model.makeups[i].namaValueStr];
        }
        [[FUManager shareManager] changeParamsStr:@"filter_level" index:0 value:@(model.selectedFilterLevel)];
    }
}

- (IBAction)textFieldDidChange:(NSTextField *)sender {
    NSLog(@"input ----- %ld",sender.integerValue);
    if ([self isNum:sender.stringValue] && sender.intValue >= 0 && sender.intValue <= 100) {//输入符合要求
        if (sender == _mFilterTef) {
            _mFilterSlider.intValue = sender.intValue;
            [FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].value = sender.floatValue/100;
            //调整sdk参数
            [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].filterModelArray[_selectFilterIndex].value)];
        }else if (sender == _mMakeupTxf){
            _mMakeupSlider.intValue = sender.intValue;
            FUMakeupModle *model = [FUAppDataCenter shareManager].makeupModelArray[_selectStyleIndex];
            
            model.value = sender.floatValue/100;
            model.selectedFilterLevel = sender.floatValue/100;
            //调整sdk参数
            for (int i = 0; i < model.makeups.count; i ++) {
                if (!model.makeups[i].namaValueStr || [model.makeups[i].namaValueStr isEqualToString:@""]) {
                    return;
                }
                [[FUManager shareManager] setMakeupItemIntensity:model.value * model.makeups[i].value param:model.makeups[i].namaValueStr];
            }
            [[FUManager shareManager] changeParamsStr:@"filter_level" index:0 value:@(model.selectedFilterLevel)];
            
        }
    }else{
        if (sender == _mFilterTef) {
            [_mFilterTef setStringValue:[NSString stringWithFormat:@"%d",_mFilterSlider.intValue]];
        }else if (sender == _mMakeupTxf){
            [_mMakeupTxf setStringValue:[NSString stringWithFormat:@"%d",_mMakeupSlider.intValue]];
        }
    }
    //取消选中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender abortEditing];
    });
    
}




#pragma mark - NSCollectionViewDatasource -

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _mMakeupCollectionView) {
        return [FUAppDataCenter shareManager].makeupModelArray.count;
    }else{
         return [FUAppDataCenter shareManager].filterModelArray.count;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFilterViewItem *item = [collectionView makeItemWithIdentifier:@"FUFilterViewItem" forIndexPath:indexPath];
    if (collectionView == _mMakeupCollectionView) {
        item.makeupModel = [FUAppDataCenter shareManager].makeupModelArray[indexPath.item];
    }else{
        item.model = [FUAppDataCenter shareManager].filterModelArray[indexPath.item];
    }
    
    return item;
}
- (NSSize)collectionView:(NSCollectionView *)collectionView
                  layout:(NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSize size = NSMakeSize(106, 106);
    
    return size;
    
    
}

#pragma mark - NSCollectionViewDelegate -

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
     NSIndexPath *indexPath = indexPaths.anyObject;
    if (collectionView == _mMakeupCollectionView) {
        [_mFilterCollectionView deselectAll:nil];
        [_mFilterCollectionView reloadData];
        _selectStyleIndex = indexPath.item;
        
        FUMakeupModle *modle = [FUAppDataCenter shareManager].makeupModelArray[indexPath.item];
        _mMakeupSlider.intValue = modle.value * 100;
         [_mMakeupTxf setStringValue:[NSString stringWithFormat:@"%d",_mMakeupSlider.intValue]];
        
        //原图不显示滑条
        if (indexPath.item == 0) {
            _mMakeupSlider.hidden = YES;
            _mMakeupTxf.hidden = YES;
        }else{
            _mMakeupSlider.hidden = NO;
            _mMakeupTxf.hidden = NO;
            
            [[FUManager shareManager] changeParamsStr:@"filter_name" index:0 value:modle.selectedFilter];
            [[FUManager shareManager] changeParamsStr:@"filter_level" index:0 value:@(modle.selectedFilterLevel)];
        }
        
        //调整sdk参数
        for (int i = 0; i < modle.makeups.count; i ++) {
            FUSingleMakeupModel *sModel = modle.makeups[i];
            
            if (i == 0) {
                NSArray *rgba = [self jsonToLipRgbaArrayResName:sModel.namaImgStr];
                double lip[4] = {[rgba[0] doubleValue],[rgba[1] doubleValue],[rgba[2] doubleValue],[rgba[3] doubleValue]};
                [[FUManager shareManager] setMakeupItemLipstick:lip];
            }else{
                [[FUManager shareManager] setMakeupItemIntensity:sModel.value * modle.value param:sModel.namaValueStr];
                NSImage *namaImage = [NSImage imageNamed:sModel.namaImgStr];
                if (!namaImage) {
                    continue;
                }
                [[FUManager shareManager] setMakeupItemParamImage:namaImage param:sModel.namaTypeStr];
            }
        }
        
    }else{
        [_mMakeupCollectionView deselectAll:nil];
        [_mMakeupCollectionView reloadData];
        //原图不显示滑条
        if (indexPath.item == 0) {
            _mFilterSlider.hidden = YES;
            _mFilterTef.hidden = YES;
        }else{
            _mFilterSlider.hidden = NO;
            _mFilterTef.hidden = NO;
        }
        
        _selectFilterIndex= indexPath.item;
        _mFilterSlider.intValue = [FUAppDataCenter shareManager].filterModelArray[indexPath.item].value * 100;
         [_mFilterTef setStringValue:[NSString stringWithFormat:@"%d",_mFilterSlider.intValue]];
        //调整sdk参数
       [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[indexPath.item].sdkStr index:0 value:[[FUAppDataCenter shareManager].filterModelArray[indexPath.item].styleStr lowercaseString]];
       [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].filterModelArray[indexPath.item].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].filterModelArray[indexPath.item].value)];
    }

}

#pragma  mark -  工具函数

-(NSArray *)jsonToLipRgbaArrayResName:(NSString *)resName{
    NSString *path=[[NSBundle mainBundle] pathForResource:resName ofType:@"json"];
    NSData *data=[[NSData alloc] initWithContentsOfFile:path];
    //解析成字典
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *rgba = [dic objectForKey:@"rgba"];
    
    if (rgba.count != 4) {
        NSLog(@"颜色json不合法");
    }
    return rgba;
}


@end
