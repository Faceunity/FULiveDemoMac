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
@property (weak) IBOutlet NSCollectionView *mStyleCollectionView;
/* 风格程度滑动 */
@property (weak) IBOutlet NSSlider *mStyleSlider;
/* 风格程度输入 */
@property (weak) IBOutlet NSTextField *mStyleTxf;

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
    
    _mStyleCollectionView.dataSource = self;
    _mStyleCollectionView.delegate = self;
    
    //初始状态
    NSUInteger indexes[2] = {0,0};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.mFilterCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
  //  [self.mStyleCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    _mFilterSlider.intValue = [FUAppDataCenter shareManager].filterModelArray[indexPath.item].value * 100;
    _mFilterTef.stringValue = [NSString stringWithFormat:@"%d",_mFilterSlider.intValue];
    _mStyleSlider.intValue = [FUAppDataCenter shareManager].styleModelArray[indexPath.item].value * 100;
    _mStyleTxf.stringValue = [NSString stringWithFormat:@"%d",_mStyleSlider.intValue];
    
}


-(void)setupUI{
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    self.view.layer.cornerRadius = 5.0f;
    
    [self.mBeautyTabView setWantsLayer:YES];
    self.mBeautyTabView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mFilterCollectionView setWantsLayer:YES];
    self.mFilterCollectionView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mStyleCollectionView setWantsLayer:YES];
    self.mStyleCollectionView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mSkinTableView setWantsLayer:YES];
    self.mSkinTableView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mBeautyTableView setWantsLayer:YES];
    self.mBeautyTableView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
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
    }else if(sender.tag - 101 == 3){//风格
      
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
        
    }else if (sender == _mStyleSlider){
        [_mStyleTxf setStringValue:[NSString stringWithFormat:@"%d",sender.intValue]];
        [FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].value = sender.floatValue/100;
        //调整sdk参数
        [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].value)];
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
        }else if (sender == _mStyleTxf){
            _mStyleSlider.intValue = sender.intValue;
            [FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].value = sender.floatValue/100;
            //调整sdk参数
            [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[_selectStyleIndex].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].styleModelArray[_selectFilterIndex].value)];
        }
    }else{
        if (sender == _mFilterTef) {
            [_mFilterTef setStringValue:[NSString stringWithFormat:@"%d",_mFilterSlider.intValue]];
        }else if (sender == _mStyleTxf){
            [_mStyleTxf setStringValue:[NSString stringWithFormat:@"%d",_mStyleSlider.intValue]];
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
    if (collectionView == _mStyleCollectionView) {
        return [FUAppDataCenter shareManager].styleModelArray.count;
    }else{
         return [FUAppDataCenter shareManager].filterModelArray.count;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    FUFilterViewItem *item = [collectionView makeItemWithIdentifier:@"FUFilterViewItem" forIndexPath:indexPath];
    if (collectionView == _mStyleCollectionView) {
        item.model = [FUAppDataCenter shareManager].styleModelArray[indexPath.item];
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
    if (collectionView == _mStyleCollectionView) {
        [_mFilterCollectionView deselectAll:nil];
        [_mFilterCollectionView reloadData];
        _selectStyleIndex = indexPath.item;
        _mStyleSlider.intValue = [FUAppDataCenter shareManager].styleModelArray[indexPath.item].value * 100;
         [_mStyleTxf setStringValue:[NSString stringWithFormat:@"%d",_mStyleSlider.intValue]];
        
        //原图不显示滑条
        if (indexPath.item == 0) {
            _mStyleSlider.hidden = YES;
            _mStyleTxf.hidden = YES;
        }else{
            _mStyleSlider.hidden = NO;
            _mStyleTxf.hidden = NO;
        }
        
        //调整sdk参数
        [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[indexPath.item].sdkStr index:0 value:[[FUAppDataCenter shareManager].styleModelArray[indexPath.item].styleStr lowercaseString]];
         [[FUManager shareManager] changeParamsStr:[FUAppDataCenter shareManager].styleModelArray[indexPath.item].valueSdkStr index:0 value:@([FUAppDataCenter shareManager].styleModelArray[indexPath.item].value)];
    }else{
        [_mStyleCollectionView deselectAll:nil];
        [_mStyleCollectionView reloadData];
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



@end
