//
//  FUPropSubItem.m
//  FULive
//
//  Created by 孙慕 on 2018/8/3.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUPropSubItem.h"
#import "FUManager.h"

@interface FUPropSubItem ()
@property(nonatomic,strong) NSTrackingArea *trackingArea;
@property (weak) IBOutlet NSImageView *mImageView;
@property (weak) IBOutlet NSView *mMouseInBAGView;

@end

@implementation FUPropSubItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.mImageView setWantsLayer:YES];
    self.mImageView.layer.cornerRadius = self.mImageView.frame.size.height / 2;

    
    [self.mMouseInBAGView setWantsLayer:YES];
    self.mMouseInBAGView.layer.cornerRadius = self.mMouseInBAGView.frame.size.height / 2;
    self.mMouseInBAGView.layer.borderWidth = 0.0;
    self.mMouseInBAGView.layer.borderColor = FUConstManager.colorForBackground_sel.CGColor;

 //  [self openMouseOverflowEvent];
}
#pragma  mark ----  添加鼠标悬停  -----

-(void)openMouseOverflowEvent{
    
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved;
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.frame options:options owner:self.view userInfo:nil];
    
    [self.view addTrackingArea:self.trackingArea];
    
    NSLog(@"开启鼠标悬停");
    
}

#pragma  mark ----  鼠标悬停事件  -----
- (void) mouseEntered:(NSEvent *) theEvent{
    
    if(self.trackingArea != nil){
        NSLog(@"鼠标进入控制器");
        [self.view setWantsLayer:YES];
        self.mMouseInBAGView.layer.backgroundColor =   FUConstManager.colorForBackground_sel.CGColor;//[[NSColor whiteColor] colorWithAlphaComponent:1.0].CGColor;// FUConstManager.colorForBackground_card.CGColor;
    }else{
        [self openMouseOverflowEvent];
    }
}

-(void)mouseExited:(NSEvent*)theEvent{
    
    if(_trackingArea != nil) {
        
        NSLog(@"鼠标离开控制器");
       self.mMouseInBAGView.layer.backgroundColor = [NSColor clearColor].CGColor;
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
-(void)mouseDown:(NSEvent *)event{
    if (_didClick && self.isSelected) {
        _didClick(NO);
    }
    [super mouseDown:event];
    
}
//重载去除鼠标滑动事件
-(void)scrollWheel:(NSEvent *)event{
//    [super scrollWheel:event];

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    //    self.view.layer.backgroundColor = selected ? [NSColor whiteColor].CGColor:[NSColor colorWithWhite:0.0 alpha:0.0].CGColor;
    self.mMouseInBAGView.layer.borderWidth = selected ? 3.0:0.0;

}

#pragma  mark ----  public接口  -----

-(void)setSubModel:(FUPropSubItemModel *)subModel{
    _subModel = subModel;
    _mImageView.image = [NSImage imageNamed:subModel.subImageStr];
}

@end
