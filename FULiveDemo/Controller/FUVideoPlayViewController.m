//
//  FUVideoPlayViewController.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUVideoPlayViewController.h"
#import "FUOpenGLView.h"
#import "FUCamera.h"
#import "FURenderer.h"
#import "FUButton.h"
#import "FUAppDataCenter.h"
#import "FUManager.h"
#import "FUPropItemModel.h"
#import "FUAppDataCenter.h"
#import "FUPropSubItem.h"
#import "FUPropItem.h"
#import "FUMusicPlayer.h"


#define itemW     80
static NSString * supIndentify = @"FUPropItem";
static NSString * subIndentify = @"subItem";

struct FUPropSelIndexPath {
    int topIndex;
    int bottomIndex;
};

@interface FUVideoPlayViewController ()<FUCameraDelegate,NSCollectionViewDataSource,NSCollectionViewDelegate>
/* 播放视图 */
@property (weak) IBOutlet FUOpenGLView *mOpenGLView;
/* 视频采集 */
@property (nonatomic, strong) FUCamera *mCamera;
/* 参数说明背景View */
@property (weak) IBOutlet NSView *mVerbView;
/* 参数说明tef */
@property (weak) IBOutlet NSTextField *mVerbTF;
/* 关闭显示参数按钮 */
@property (weak) IBOutlet NSButton *mCloseVerbBtn;
/* 打开显示参数按钮 */
@property (weak) IBOutlet FUButton *mOpenVerbBtn;
/* 未连接提示文字 */
@property (weak) IBOutlet NSTextField *notConnectedTxf;
/* 未连接提示图片 */
@property (weak) IBOutlet NSImageView *notConnectedImage;
@property (weak) IBOutlet NSScrollView *mSubScrollView;
/* 道具集合控制器 */
@property (weak) IBOutlet NSCollectionView *mItemCollectionView;
/* 子道具集合控制器 */
@property (weak) IBOutlet NSCollectionView *mSubItemCollectionView;
/* 子道具底下view用于设置背景色 */
@property (weak) IBOutlet NSView *mSubBarSupView;
/* 子视图上一页按钮 */
@property (weak) IBOutlet NSButton *mLeftBtn;
/* 子视图下一页按钮 */
@property (weak) IBOutlet NSButton *mRightBtn;
/* subBar底部约束 */
@property (weak) IBOutlet NSLayoutConstraint *mLayoutConstraintSubBarBottomValue;
/* subCollection 宽度约束 */
@property (weak) IBOutlet NSLayoutConstraint *mLayoutConstraintW;

@property (weak) IBOutlet NSLayoutConstraint *mLayoutConstraintBottonW;

/* 提示背景颜色父View */
@property (weak) IBOutlet NSView *mHintBageView;
/* 提示框*/
@property (weak) IBOutlet NSTextField *mHintTextField;
/* 定时销毁hint */
@property (retain) NSTimer *timer;
/* 选中父节点索引 */
@property (assign) int oldItemIndex;
/* 道具选中 */
@property (assign) struct FUPropSelIndexPath propSel;
/* 模拟分页，背景样式 */
@property (weak) IBOutlet NSView *segementBageView;
@property (weak) IBOutlet NSButton *segBtn1;
@property (weak) IBOutlet NSButton *segBtn2;
@property (weak) IBOutlet NSView *segColorView;
@property (weak) IBOutlet NSLayoutConstraint *mLayoutConstraintLeading;

/* 当前类型 */
@property (assign) FUPropItemType itemtype;

@end

@implementation FUVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.mCamera startCapture]; //开启视频采集
    [self setupUI];  //修改UI
    [self setupSegView];
    [self addNotification]; //添加采集摄像头变化监听
    [self addObserverForHint];//提示字符串改变监听
    [[FUManager shareManager] loadAllItems]; //sdk加载所有道具
    [[FUAppDataCenter shareManager] changeBeautyParams:nil]; //初始化美颜参数
}

-(void)viewDidAppear{
    _mSubItemCollectionView.enclosingScrollView.horizontalScroller.hidden = YES;
}

#pragma  mark ----  懒加载  -----

-(FUCamera *)mCamera{
    if (!_mCamera) {
        _mCamera = [[FUCamera alloc] init];
        _mCamera.delegate = self;
    }    
    return _mCamera;
}

#pragma  mark ----  设置UI  -----

-(void)setupUI{
    [self.view setWantsLayer:YES];
    self.view.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    self.view.layer.cornerRadius = 5.0f;
    
    [self.mVerbView setWantsLayer:YES];
    self.mVerbView.layer.cornerRadius = 3.0f;
    self.mVerbView.layer.backgroundColor = FUColor_HEX(0x596078).CGColor;
    
    [self.mHintBageView setWantsLayer:YES];
    self.mHintBageView.layer.masksToBounds = YES;
    self.mHintBageView.layer.cornerRadius = 5.0f;
    self.mHintBageView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    [self.mCloseVerbBtn setTitleColor:(NSColor *)FUConstManager.colorForBackground_card font:[NSFont systemFontOfSize:13.0f]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_mCloseVerbBtn.title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:13] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:FUConstManager.colorForBackground_card range:strRange];
    [_mCloseVerbBtn setAttributedTitle:str];
    
    self.mOpenVerbBtn.textColor = FUConstManager.colorForBackground_card;

    _mItemCollectionView.delegate = self;
    _mItemCollectionView.dataSource = self;    
    _mSubItemCollectionView.delegate = self;
    _mSubItemCollectionView.dataSource = self;
    [_mItemCollectionView setWantsLayer:YES];
    _mItemCollectionView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    
    
    NSNib *itemOneNib = [[NSNib alloc] initWithNibNamed:@"FUPropItem" bundle:nil];
    [_mItemCollectionView registerNib:itemOneNib forItemWithIdentifier:supIndentify];
    NSNib *itemOneNib2 = [[NSNib alloc] initWithNibNamed:@"FUPropSubItem" bundle:nil];
    [_mSubItemCollectionView registerNib:itemOneNib2 forItemWithIdentifier:subIndentify];
    
    [_mSubBarSupView setWantsLayer:YES];
      _mSubBarSupView.layer.backgroundColor = [NSColor colorWithWhite:1.0 alpha:0.7].CGColor;
    
    _mSubScrollView.backgroundColor = [NSColor clearColor];
    NSArray *colors = @[[NSColor clearColor]];
    _mSubItemCollectionView.backgroundColors = colors;
    _mItemCollectionView.backgroundColors = colors;
    
    
    self.mLayoutConstraintSubBarBottomValue.constant = -90;
    _mLayoutConstraintW.constant = [self updateSubCollectionWidth:[FUAppDataCenter shareManager].propItemModelArray.firstObject.subItems];//设置宽度
    
    if (self.mCamera.cameraInput) {
        self.notConnectedTxf.hidden = YES;
        self.notConnectedImage.hidden = YES;
    }else{
        self.notConnectedTxf.hidden = NO;
        self.notConnectedImage.hidden = NO;
    }
}

-(void)setupSegView{
    [self.segementBageView setWantsLayer:YES];
    self.segementBageView.layer.masksToBounds = YES;
    self.segementBageView.shadow = [[NSShadow alloc] init];
    self.segementBageView.layer.backgroundColor = [NSColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.segementBageView.layer.cornerRadius = 14;
    self.segementBageView.layer.shadowColor = [NSColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.7].CGColor;
    self.segementBageView.layer.shadowOffset = CGSizeMake(0,0);
    self.segementBageView.layer.shadowOpacity = 1;
    self.segementBageView.layer.shadowRadius = 2.5;
    
    [self.segColorView setWantsLayer:YES];
    self.segColorView.layer.backgroundColor = FUConstManager.colorForBackground_sel.CGColor;
    self.segColorView.layer.cornerRadius = 14;
    
    
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn1 attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [_segBtn1 setAttributedTitle:colorTitle];
    
    NSColor *color2 = FUConstManager.colorForBackground_text0;
    NSMutableAttributedString *colorTitle2 = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn2 attributedTitle]];
    NSRange titleRange2 = NSMakeRange(0, [colorTitle2 length]);
    [colorTitle2 addAttribute:NSForegroundColorAttributeName value:color2 range:titleRange2];
    [_segBtn2 setAttributedTitle:colorTitle2];
}


#pragma  mark ----  KVO  -----
-(void)addObserverForHint{
    [_mHintTextField addObserver:self forKeyPath:@"stringValue" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    if ([keyPath isEqualToString:@"stringValue"] && object == _mHintTextField){
        _mHintBageView.hidden = NO;
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(hidenHint) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSDefaultRunLoopMode];
    //    NSLog(@"提示字符串: %@",_mHintTextField.stringValue);
    }
}

#pragma  mark ----  subBar弹出销毁  -----

-(void)showHideSubBar:(BOOL)isShow{
    if (isShow) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [context setDuration:2.5];
            self.mLayoutConstraintSubBarBottomValue.constant = 0;
            [[NSApp mainWindow] layoutIfNeeded];
        } completionHandler:^{
        }];
    }else{
        self.mLayoutConstraintSubBarBottomValue.constant = -90;
    }

}

#pragma  mark ----  按钮点击事件  -----
//关闭提示
- (IBAction)closeParameter:(NSButton *)sender {
    _mVerbView.hidden = YES;
    _mOpenVerbBtn.hidden = NO;
}
//开启提示
- (IBAction)openParameter:(FUButton *)sender {
   _mOpenVerbBtn.hidden = YES;
    _mVerbView.hidden = NO;
}

//返回上一页
- (IBAction)backPageBtnClick:(id)sender {
    [_mSubItemCollectionView.enclosingScrollView.contentView scrollToPoint:NSMakePoint(0, 0)];
    [_mSubItemCollectionView.enclosingScrollView reflectScrolledClipView:[_mSubItemCollectionView.enclosingScrollView contentView]];
    _mRightBtn.hidden = NO;
    _mLeftBtn.hidden = YES;
}

//下一页
- (IBAction)goPageBtnClick:(id)sender {
    [_mSubItemCollectionView.enclosingScrollView.contentView scrollToPoint:NSMakePoint(_mLayoutConstraintW.constant, 0)];
    [_mSubItemCollectionView.enclosingScrollView reflectScrolledClipView:[_mSubItemCollectionView.enclosingScrollView contentView]];
    _mSubItemCollectionView.enclosingScrollView.horizontalScroller.hidden = YES;
    _mRightBtn.hidden = YES;
    _mLeftBtn.hidden = NO;
    
}
- (IBAction)segBtn1Click:(id)sender {
    /* 更改模拟seg UI */
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn1 attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [_segBtn1 setAttributedTitle:colorTitle];
    
    NSColor *color2 = FUConstManager.colorForBackground_text0;
    NSMutableAttributedString *colorTitle2 = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn2 attributedTitle]];
    NSRange titleRange2 = NSMakeRange(0, [colorTitle2 length]);
    [colorTitle2 addAttribute:NSForegroundColorAttributeName value:color2 range:titleRange2];
    [_segBtn2 setAttributedTitle:colorTitle2];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        [context setDuration:2.5];
        self.mLayoutConstraintLeading.constant = 0;
        [[NSApp mainWindow] layoutIfNeeded];
    } completionHandler:^{
    }];
    
    _propSel.bottomIndex = _oldItemIndex;
    _itemtype = FUPropItemTypeNormal;
    [[FUAppDataCenter shareManager] changePropData:FUPropItemTypeNormal];
    //更新宽度
    _mLayoutConstraintW.constant = [self updateSubCollectionWidth:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems];
    _mLayoutConstraintBottonW.constant = 800;
    [_mItemCollectionView reloadData];
    [_mSubItemCollectionView reloadData];
    
    [_mSubItemCollectionView.enclosingScrollView.contentView scrollToPoint:NSMakePoint(0, 0)];
    [_mSubItemCollectionView.enclosingScrollView reflectScrolledClipView:[_mSubItemCollectionView.enclosingScrollView contentView]];
    
    [self loadPorpItem:[FUAppDataCenter shareManager].currentItemSdkStr];
    [self updateDefaultSelectSubItem:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems];
    
    NSUInteger indexes[2] = {0,_propSel.bottomIndex};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.mItemCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    
    [self showHideSubBar:YES];

}

- (IBAction)sefBtn2Click:(id)sender {
    
    /* 更改模拟seg UI */
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn2 attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [_segBtn2 setAttributedTitle:colorTitle];
    
    NSColor *color2 = FUConstManager.colorForBackground_text0;
    NSMutableAttributedString *colorTitle2 = [[NSMutableAttributedString alloc] initWithAttributedString:[_segBtn1 attributedTitle]];
    NSRange titleRange2 = NSMakeRange(0, [colorTitle2 length]);
    [colorTitle2 addAttribute:NSForegroundColorAttributeName value:color2 range:titleRange2];
    [_segBtn1 setAttributedTitle:colorTitle2];

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        [context setDuration:2.5];
        self.mLayoutConstraintLeading.constant = self.segBtn1.frame.size.width;
        [[NSApp mainWindow] layoutIfNeeded];
    } completionHandler:^{
    }];
    
    _propSel.bottomIndex = 0;
     _itemtype = FUPropItemTypeMakeup;
    [[FUManager shareManager] loadItem:nil];
    [[FUAppDataCenter shareManager] changePropData:FUPropItemTypeMakeup];
    //更新宽度
    _mLayoutConstraintW.constant = [self updateSubCollectionWidth:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems];
     _mLayoutConstraintBottonW.constant = itemW;
    [_mItemCollectionView reloadData];
    [_mSubItemCollectionView reloadData];
    
    [_mSubItemCollectionView.enclosingScrollView.contentView scrollToPoint:NSMakePoint(0, 0)];
    [_mSubItemCollectionView.enclosingScrollView reflectScrolledClipView:[_mSubItemCollectionView.enclosingScrollView contentView]];
    
    /* 美妆选中 */
    int index = [FUAppDataCenter shareManager].makeupSelIndex;
    [[FUManager shareManager] setMaxFaces:4];
    [[FUAppDataCenter shareManager] setMakeupWithDataIndex:index];
    [FUAppDataCenter shareManager].makeupSelIndex = index;
    
    [self updateMakeupDefaultSelectSubItem];
    NSUInteger indexes[2] = {0,0};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.mItemCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    
     [self showHideSubBar:YES];
    
     [[FUMusicPlayer sharePlayer] stop];//停止音乐
}

#pragma  mark ----  添加通知监听  -----

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceChangeNotification:) name:FUConstManager.notiCenterForDeviceChange object:nil];
}

-(void)deviceChangeNotification:(NSNotification *)noti{
    [self.mCamera changeCameraPositionWithStr:noti.object];
}

#pragma  mark ----  private私有方法 -----

/**
 更新子集合UI
 @param array 子视图数据
 @return 子视图宽度
 */
-(float)updateSubCollectionWidth:(NSArray <FUPropSubItemModel *> *)array{
    float width = 0;
    if (array.count <= 8) {//最大9个
        _mLeftBtn.hidden = YES;
        _mRightBtn.hidden = YES;
        width = [FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems.count * (itemW + 10) - 10;//10:item间隔
    }else{
        width = 8 * (itemW + 10) - 10;
        _mLeftBtn.hidden = YES;
        _mRightBtn.hidden = NO;
    }
    return width;
    
}

//默认选中中间
-(void)updateDefaultSelectSubItem:(NSArray <FUPropSubItemModel *> *)array{
    for ( int row = 0; row < array.count; row++) {
        if ([array[row].subSdkStr isEqualToString:[FUAppDataCenter shareManager].currentItemSdkStr]) {
            NSUInteger indexes[2] = {0,row};
            NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
            [self.mSubItemCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
            break;
        }
    }
    

//    [[FUManager shareManager] loadItem:array[row].subSdkStr];
//    if ([FUAppDataCenter shareManager].propItemModelArray[_selItemIndex].propType == FULiveModelTypeMusicFilter) {//音乐滤镜
//        [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
//    }
//    if ([FUAppDataCenter shareManager].propItemModelArray[_selItemIndex].propType == FULiveModelTypeExpressionRecognition){//表情识别
//        _mHintTextField.stringValue = [FUAppDataCenter shareManager].propItemModelArray[_selItemIndex].subItems[indexPath.item].hintStr;
//    }
}

-(void)updateMakeupDefaultSelectSubItem{
    int  row = [FUAppDataCenter shareManager].makeupSelIndex;
    NSUInteger indexes[2] = {0,row};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.mSubItemCollectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
}

//定时消失
-(void)hidenHint{
    _mHintBageView.hidden = YES;
}


-(void)setMakeupZeroIndex{
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_lip" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_eyeBrow" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_blusher" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_eye" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_eyelash" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_shadow" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_pupil" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_foundation" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_highlight" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"makeup_intensity_eyeLiner" index:FUNamaHandleTypeMakeup value:@(0)];
    [[FUManager shareManager] changeParamsStr:@"brow_warp" index:FUNamaHandleTypeMakeup value:@(0)];
    

    
    //    [self setMakeupItemIntensity:1.0 param:@"is_makeup_on" index:index];
    
}

#pragma  mark ----  NSCollectionViewDatasource  -----

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _mItemCollectionView){
       return [FUAppDataCenter shareManager].propItemModelArray.count;
    }else{
       return [FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems.count;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView
     itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    if (_mItemCollectionView == collectionView) {
        FUPropItem *item = [collectionView makeItemWithIdentifier:supIndentify forIndexPath:indexPath];
        item.model = [FUAppDataCenter shareManager].propItemModelArray[indexPath.item];
        item.didClick = ^(BOOL isSel) {// 再次点击，取消所有选中回调
            [selfWeak showHideSubBar:isSel];
//            [selfWeak.mItemCollectionView deselectAll:nil];
     //       [[FUManager shareManager] destoryAllItems];
            self->_propSel.topIndex = 0;
            [selfWeak.mItemCollectionView reloadData];
            
        };
//        if (_propSel.bottomIndex == (int)indexPath.item) {
//            item.selected = YES;
//        }
        
         return item;
    }else if(_mSubItemCollectionView == collectionView){
        FUPropSubItem *item = [collectionView makeItemWithIdentifier:subIndentify forIndexPath:indexPath];// [collectionView makeItemWithIdentifier:@"FUPropSubItem" forIndexPath:indexPath];
        item.subModel = [FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item];
        item.didClick = ^(BOOL isSel) {
//            [selfWeak.mSubItemCollectionView deselectAll:nil];
            self->_propSel.topIndex = 0;
            [selfWeak.mSubItemCollectionView reloadData];
            /* 美妆的取消逻辑 */
            if (self.itemtype == FUPropItemTypeMakeup) {
                [FUAppDataCenter shareManager].makeupSelIndex = -1;
                [self setMakeupZeroIndex];
                return;
            }
            [FUAppDataCenter shareManager].currentItemSdkStr = nil;
            [[FUManager shareManager] loadItem:nil];
            if ([FUMusicPlayer sharePlayer].playProgress != 0 || [FUMusicPlayer sharePlayer].playProgress != 1) {//再播放状态,关闭
                [[FUMusicPlayer sharePlayer] stop];
            }

        };
//        if (_propSel.topIndex == (int)indexPath.item) {
//            item.selected = YES;
//        }
        
         return item;
    }
    return nil;
}



#pragma mark ---- NSCollectionViewDelegate ----
- (NSSize)collectionView:(NSCollectionView *)collectionView
                  layout:(NSCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSSize size = NSMakeSize(itemW, itemW);

    return size;

}

-(void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    NSIndexPath *indexPath = indexPaths.anyObject;
    if(collectionView == _mItemCollectionView){
        if (self.itemtype == FUPropItemTypeNormal) {
            _oldItemIndex = (int)indexPath.item;
        }
        if (_propSel.bottomIndex != (int)indexPath.item) {
            _propSel.bottomIndex = (int)indexPath.item;
            //更新宽度
            _mLayoutConstraintW.constant = [self updateSubCollectionWidth:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems];
            [_mSubItemCollectionView reloadData];
        }
        //弹出sub选择栏
        [self showHideSubBar:YES];
        //设置默认选中
        [self updateDefaultSelectSubItem:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems];
        
    }else if (collectionView == _mSubItemCollectionView){
        _propSel.topIndex = (int)indexPath.item;
        /* 美妆的选中逻辑 */
        if (self.itemtype == FUPropItemTypeMakeup) {
            [[FUManager shareManager] setMaxFaces:4];
            [[FUAppDataCenter shareManager] setMakeupWithDataIndex:(int)indexPath.item];
            [FUAppDataCenter shareManager].makeupSelIndex = (int)indexPath.item;
            if ([FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item].hintStr){
                _mHintTextField.stringValue = [FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item].hintStr;
            }

            return;
        }
        
        //调整当前最大识别人脸数量
        [[FUManager shareManager] setMaxFaces:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].maxFace];
        if ([FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item].hintStr){
            _mHintTextField.stringValue = [FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item].hintStr;
        }
        [self loadPorpItem:[FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].subItems[indexPath.item].subSdkStr];
        
    }
}

-(void)loadPorpItem:(NSString *)porpStr{
    /* 美妆类型 bundle  会让人脸识别新的2D算法，新算法只做美妆，所以切换回贴图，必须先销毁这个bundle*/
    [[FUManager shareManager] destoryItemAboutType:FUNamaHandleTypeMakeup];
    
    [[FUManager  shareManager] loadItem:porpStr];
    [[FUMusicPlayer sharePlayer] stop];//停止音乐
    
    if ([FUAppDataCenter shareManager].propItemModelArray[_propSel.bottomIndex].propType == FULiveModelTypeMusicFilter && porpStr) {
        [[FUMusicPlayer sharePlayer] playMusic:@"douyin.mp3"];
    }
    //存储当前选中的item
    [FUAppDataCenter shareManager].currentItemSdkStr = porpStr;
}


#pragma  mark ----  FUCameraDelegate  -----
static int rate = 0;
static NSTimeInterval totalRenderTime = 0;
static  NSTimeInterval oldTime = 0;
static  bool isWriter = YES;
- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    if ([FUMusicPlayer sharePlayer].audioPlayer.isPlaying) {
        [[FUManager shareManager] changeParamsStr:@"music_time" index:1 value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];
    }    
    rate++;
    NSTimeInterval startTime =  [[NSDate date] timeIntervalSince1970];
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self updateVideoParametersText:startTime bufferRef:pixelBuffer];
    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    totalRenderTime += [[NSDate date] timeIntervalSince1970] - startTime;
    CVPixelBufferRetain(pixelBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_itemtype == FUPropItemTypeMakeup) {
//            float newLandmarks[418] = {0};
//            fuGetFaceInfo(0, "landmarks_new", newLandmarks, 418);
//            [self.mOpenGLView displayPixelBuffer:pixelBuffer withLandmarks:newLandmarks count:209 MAX:NO];
//        }else{
//            float newLandmarks[150] = {0};
//            fuGetFaceInfo(0, "landmarks", newLandmarks, 150);
//            [self.mOpenGLView displayPixelBuffer:pixelBuffer withLandmarks:newLandmarks count:75 MAX:NO];
//        }
        
        
        [self.mOpenGLView displayPixelBuffer:pixelBuffer];
        CVPixelBufferRelease(pixelBuffer);
    });

    if(![FUManager shareManager].isTracking){//和reader线程同步
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mHintTextField.stringValue = @"未检测到人脸";
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.mHintTextField.stringValue isEqualToString:@"未检测到人脸"]) {
                    self.mHintBageView.hidden = YES;
            }
        });
    }
}

// 更新视频参数栏
-(void)updateVideoParametersText:(NSTimeInterval)startTime bufferRef:(CVPixelBufferRef)pixelBuffer{
    if (startTime - oldTime >= 1) {
        oldTime = startTime;
        int diaplayRate = rate;
        NSTimeInterval diaplayRenderTime = totalRenderTime;
        
        float w = CVPixelBufferGetWidth(pixelBuffer);
        float h = CVPixelBufferGetHeight(pixelBuffer);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mVerbTF.stringValue = [NSString stringWithFormat:@"FPS:  %d\nResolution:%0.f*%0.f\nRenderTime: %0.fms",diaplayRate,w,h,diaplayRenderTime * 1000 / diaplayRate];
        });
        totalRenderTime = 0;
        rate = 0;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mHintTextField removeObserver:self forKeyPath:@"stringValue"];
}

@end
