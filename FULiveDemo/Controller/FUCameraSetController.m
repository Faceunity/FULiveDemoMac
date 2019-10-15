//
//  FUCameraSetController.m
//  FULive
//
//  Created by 孙慕 on 2018/7/30.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUCameraSetController.h"
#import <AVFoundation/AVFoundation.h>
#import "FUTipPopViewController.h"
#import "FUComboBox.h"
#import "FUHelpDocViewController.h"

@interface FUCameraSetController ()
/* 摄像机选择 */
@property (weak) IBOutlet FUComboBox *mCameraBox;
/* 虚拟摄像机开关 */
@property (weak) IBOutlet NSButton *mCheckBtn;
/* 主界面 */
@property (weak) IBOutlet NSView *mMainView;
/* 帮助按钮 */
@property (weak) IBOutlet NSButton *mHelpBtn;
/* 前往文档按钮 */
@property (weak) IBOutlet NSButton *mOpenDocBtn;
/* 鼠标悬停 */
@property(nonatomic,strong) NSTrackingArea *trackingArea;
/* pop框 */
@property (nonatomic, strong) NSPopover *showPopover;


@property (strong, nonatomic) NSWindow *mDocwindow;
@property (strong, nonatomic) NSWindowController *mDocWindowController;
@end

@implementation FUCameraSetController

#pragma  mark ----  懒加载  -----
- (NSPopover *)showPopover {
    if (!_showPopover) {
        _showPopover = [[NSPopover alloc] init];
        _showPopover.contentViewController = [[FUTipPopViewController alloc] initWithNibName:@"FUTipPopViewController" bundle:nil];
        _showPopover.behavior = NSPopoverBehaviorTransient;
    }
    return _showPopover;
}

- (NSWindow *)mDocwindow{
    if (!_mDocwindow) {
        NSRect frame = CGRectMake(0, 0, 500, 100);
        NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
        _mDocwindow = [[NSWindow alloc] initWithContentRect:frame styleMask:style backing:NSBackingStoreBuffered defer:YES];
        _mDocwindow.title = @"帮助文档";
        _mDocwindow.contentViewController = [FUHelpDocViewController new];
    }
    return _mDocwindow;
}

-(NSWindowController *)mDocWindowController{
    if (!_mDocWindowController) {
        _mDocWindowController = [[NSWindowController alloc] init];
        self.mDocwindow.windowController = _mDocWindowController;
        _mDocWindowController.window = self.mDocwindow;
    }
    return _mDocWindowController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    [self setupUI]; //修改UI
    [self addDeviceNotification]; //摄像机硬件变化监听
    [self openMouseOverflowEvent]; //添加手势
}


#pragma  mark ----  设置UI  -----

-(void)setupUI{
    [self.mMainView setWantsLayer:YES];
    self.mMainView.layer.backgroundColor = FUConstManager.colorForBackground_card.CGColor;
    self.mMainView.layer.cornerRadius = 5.0f;
    [self.mCheckBtn setTitleColor:FUConstManager.colorForBackground_text1 font:[NSFont systemFontOfSize:16]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_mOpenDocBtn.title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:16] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:FUConstManager.colorForBackground_text0 range:strRange];
    [_mOpenDocBtn setAttributedTitle:str];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    NSMutableArray *devicenNameMutArray = [NSMutableArray array];
    NSString *defaultStr = nil;
    AVCaptureDevice *defaultdevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device.localizedName hasPrefix:@"Faceunity"]) {//虚拟摄像机
            continue;
        }
        [devicenNameMutArray addObject:device.localizedName];
        if ([defaultdevice.localizedName isEqualToString:device.localizedName]) {
            defaultStr = device.localizedName;
        }
    }
    [self.mCameraBox addItemsWithObjectValues:devicenNameMutArray];
    [self.mCameraBox selectItemWithObjectValue:defaultStr];
    
}

#pragma  mark ----  设备接入&移除通知  -----

-(void)addDeviceNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidChange:) name:AVCaptureDeviceWasConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidChange:) name:AVCaptureDeviceWasDisconnectedNotification object:nil];
}

-(void)deviceDidChange:(NSNotification *)not{
    NSLog(@"变化");
    [self.mCameraBox removeAllItems];
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];    
    NSMutableArray *devicenNameMutArray = [NSMutableArray array];
    for (AVCaptureDevice *device in devices) {
        if ([device.localizedName hasPrefix:@"Faceunity"]) {//虚拟摄像机
            continue;
        }
        [devicenNameMutArray addObject:device.localizedName];
    }
    [self.mCameraBox addItemsWithObjectValues:devicenNameMutArray];
    [self.mCameraBox selectItemAtIndex:0];
    [self cameraDidChange:self.mCameraBox];
}


#pragma  mark ----  添加鼠标悬停  -----

-(void)openMouseOverflowEvent{
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.mHelpBtn.frame options:options owner:self.view userInfo:nil];
    [self.view addTrackingArea:self.trackingArea];
}

#pragma  mark ----  按钮点击事件  -----
- (IBAction)cameraDidChange:(NSComboBox *)sender {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:FUConstManager.notiCenterForDeviceChange object:sender.selectedCell.title];
}

- (IBAction)cameraDidSwitch:(NSButton *)sender {
    NSLog(@"虚拟摄像机切换转态 ----- %ld",(long)sender.state);
//    if(sender.state){
//        [[FUVirtualCamera shareVirtualCamera] startCamera];
//    }else{
//        [[FUVirtualCamera shareVirtualCamera] stopCamera];
//    }
}

- (IBAction)openDoc:(id)sender {
    NSLog(@"打开文档 ----- ");
     [self.mDocWindowController showWindow:nil];
   
}

#pragma  mark ----  鼠标悬停事件  -----
- (void) mouseEntered:(NSEvent *) theEvent{
    
   if(self.trackingArea != nil){
       NSLog(@"鼠标进入控制器");
       [self.mHelpBtn setImage:[NSImage imageNamed:@"icon_Questionmark_hover"]];
      [self.showPopover showRelativeToRect:_mHelpBtn.bounds ofView:_mHelpBtn preferredEdge:NSRectEdgeMaxY];
   }else{
       [self openMouseOverflowEvent];
   }
}

-(void)mouseExited:(NSEvent*)theEvent{
    
   if(_trackingArea != nil) {
       [self.mHelpBtn setImage:[NSImage imageNamed:@"icon_Questionmark_nor"]];
       [self.showPopover close];
     NSLog(@"鼠标离开控制器");
        
    }else{
            
     [self closeMouseOverflowEvent];
    }
}

- (void)closeMouseOverflowEvent{
    
    [self.view removeTrackingArea:_trackingArea];
    
    _trackingArea=nil;
    
    NSLog(@"关闭鼠标悬停");
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
