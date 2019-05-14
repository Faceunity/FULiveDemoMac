//
//  FUPropItem.m
//  FULive
//
//  Created by 孙慕 on 2018/8/2.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUPropItem.h"

@interface FUPropItem ()

@property (weak) IBOutlet NSTextField *mCollapseTxf;
@property (weak) IBOutlet NSTextField *mTitleTxf;
/* item Icon */
@property (weak) IBOutlet NSImageView *mImageView;
/* item标题 */
@property (weak) IBOutlet NSTextField *mItemTxf;

@property(nonatomic,strong) NSTrackingArea *trackingArea;

@end

@implementation FUPropItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    [self openMouseOverflowEvent];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [_mCollapseTxf setWantsLayer:YES];
    _mCollapseTxf.layer.cornerRadius = _mCollapseTxf.bounds.size.width / 2;
}



#pragma  mark ----  添加鼠标悬停  -----

-(void)openMouseOverflowEvent{
    
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved;
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectMake(0, 0, 90, 90) options:options owner:self.view userInfo:nil];
    [self.view addTrackingArea:self.trackingArea];
    
    NSLog(@"开启鼠标悬停");
    
}

#pragma  mark ----  鼠标悬停事件  -----
- (void) mouseEntered:(NSEvent *) theEvent{
    
    if(self.trackingArea != nil){
        NSLog(@"鼠标进入控制器");
        _mImageView.image = [NSImage imageNamed:_model.hoverImageStr];
    }else{
        [self openMouseOverflowEvent];
    }
}

-(void)mouseExited:(NSEvent*)theEvent{
    
    if(_trackingArea != nil) {
        NSLog(@"鼠标离开控制器");
       _mImageView.image = [NSImage imageNamed:_model.norImageStr];
    }else{
        
        [self closeMouseOverflowEvent];
    }
}

- (void)closeMouseOverflowEvent{
    
    [self.view removeTrackingArea:_trackingArea];
    _mImageView.image = [NSImage imageNamed:_model.norImageStr];
    _trackingArea=nil;
    
    NSLog(@"关闭鼠标悬停");
    
}

#pragma  mark ----  重写函数  -----
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _mCollapseTxf.hidden = !selected;
    _mTitleTxf.hidden = !selected;
    self.mItemTxf.textColor = selected?FUConstManager.colorForBackground_sel:FUConstManager.colorForBackground_text0;
}

-(void)mouseUp:(NSEvent *)event{
    if (_didClick && self.isSelected) {
        _didClick(NO);
    }
      [super mouseUp:event];
}

#pragma  mark ----  public接口  -----

-(void)setModel:(FUPropItemModel *)model{
    _model = model;
    _mImageView.image = [NSImage imageNamed:model.norImageStr];
    _mItemTxf.stringValue = model.title;
    
    
}


@end
