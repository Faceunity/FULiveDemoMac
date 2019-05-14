//
//  FUFilterViewItem.m
//  FULive
//
//  Created by 孙慕 on 2018/8/2.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUFilterViewItem.h"
#import "FUManager.h"

@interface FUFilterViewItem ()
/* 鼠标悬停 */
@property(nonatomic,strong) NSTrackingArea *trackingArea;
/* icon */
@property (weak) IBOutlet NSImageView *mImageView;
/* 标题 */
@property (weak) IBOutlet NSTextField *mTitleTxf;
/* 选中蒙版视图 */
@property (weak) IBOutlet NSView *mMaskView;
/* 蒙版文字 */
@property (weak) IBOutlet NSTextField *mMaskTxf;


@end

@implementation FUFilterViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self openMouseOverflowEvent];
    self.view.wantsLayer = YES;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 5.0f;
    
    [_mMaskView setWantsLayer:YES];
    _mMaskView.layer.backgroundColor = FUConstManager.colorForBackground_sel.CGColor;
    
    _mMaskTxf.stringValue = _mTitleTxf.stringValue;
}


#pragma  mark ----  private  -----
-(void)setTextFieldBagegoundMouseIn:(BOOL)isMouseIn{
    if (isMouseIn) {
        _mTitleTxf.layer.backgroundColor = FUConstManager.colorForBackground_sel.CGColor;
    }else{
        _mTitleTxf.layer.backgroundColor = FUColor_HEX(0x596078).CGColor;
    }
    
}


#pragma  mark ----  添加鼠标悬停  -----

-(void)openMouseOverflowEvent{
    
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved;
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectMake(0, 0, 106, 106) options:options owner:self.view userInfo:nil];
    
    [self.view addTrackingArea:self.trackingArea];
    
    NSLog(@"开启鼠标悬停");
    
}

#pragma  mark ----  鼠标悬停事件  -----
- (void) mouseEntered:(NSEvent *) theEvent{
    
    if(self.trackingArea != nil){
        NSLog(@"鼠标进入控制器");
        [self setTextFieldBagegoundMouseIn:YES];
    }else{
        [self openMouseOverflowEvent];
    }
}

-(void)mouseExited:(NSEvent*)theEvent{
    
    if(_trackingArea != nil) {
        
        NSLog(@"鼠标离开控制器");
        [self setTextFieldBagegoundMouseIn:NO];
    }else{
        
        [self closeMouseOverflowEvent];
    }
}

- (void)closeMouseOverflowEvent{
    
    [self.view removeTrackingArea:_trackingArea];
    
    _trackingArea=nil;
    
    NSLog(@"关闭鼠标悬停");
    
}

#pragma  mark ----  重写函数  -----

- (void)setSelected:(BOOL)selected{
    NSLog(@"___________set %d",selected);
    [super setSelected:selected];
    //    self.view.layer.backgroundColor = selected ? [NSColor whiteColor].CGColor:[NSColor colorWithWhite:0.0 alpha:0.0].CGColor;
    _mMaskView.hidden = !self.selected;
    _mTitleTxf.hidden = self.selected;

}


#pragma  mark ----  Public接口  -----

-(void)setModel:(FUFilterModel *)model{
    _model = model;
    _mImageView.image = [NSImage imageNamed:model.imageStr];
    _mTitleTxf.stringValue = model.titleStr;
    _mMaskTxf.stringValue = model.titleStr;
}

-(void)setMakeupModel:(FUMakeupModle *)makeupModel{
    _makeupModel = makeupModel;
    
    _mImageView.image = [NSImage imageNamed:makeupModel.imageStr];
    _mTitleTxf.stringValue = makeupModel.titleStr;
    _mMaskTxf.stringValue = makeupModel.titleStr;
}


@end
