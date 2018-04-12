//
//  ViewController.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "ViewController.h"
#import "FUCamera.h"
#import "FUMetalView.h"
#import <AVFoundation/AVFoundation.h>
#import "FUManager.h"

@interface ViewController ()<FUCameraDelegate,NSWindowDelegate,FUManagerDelegate>
@property (nonatomic, strong) FUCamera *camera;
@property (weak) IBOutlet FUMetalView *metalView;
@property (weak) IBOutlet NSTextField *noTrackView;
@property (weak) IBOutlet NSTextField *tipLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [FUManager shareManager].delegate = self;
    [[FUManager shareManager] loadItems];
    
    //显示道具的提示语
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [[FUManager shareManager] hintForItem:[FUManager shareManager].selectedItem];
        self.tipLabel.hidden = hint == nil;
        self.tipLabel.stringValue = hint?hint:@"";
        
        [ViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:3 ];
    });
    
    [self.camera startCapture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching) name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (void)didSelectedItem:(NSString *)item{
    //显示道具的提示语
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *hint = [[FUManager shareManager] hintForItem:item];
        self.tipLabel.hidden = hint == nil;
        self.tipLabel.stringValue = hint?hint:@"";
        
        [ViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTipLabel) object:nil];
        [self performSelector:@selector(dismissTipLabel) withObject:nil afterDelay:3 ];
    });
}

- (void)dismissTipLabel
{
    self.tipLabel.hidden = YES;
}


- (void)applicationDidFinishLaunching{
    
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    window.delegate = self;
    
    float dw = window.frame.size.width - self.view.frame.size.width;
    float dh = window.frame.size.height - self.view.frame.size.height;
    
    NSSize visibleSize = [NSScreen mainScreen].visibleFrame.size;
    visibleSize.width -= dw;
    visibleSize.height -= dh;

    float ratio = 2.0 / 3.0;
    
    if (visibleSize.height / visibleSize.width > ratio) {
        visibleSize.height = visibleSize.width * ratio;
    }else{
        visibleSize.width = visibleSize.height / ratio;
    }
    
    visibleSize.width += dw;
    visibleSize.height += dh;
    window.maxFullScreenContentSize = visibleSize;
}

- (FUCamera *)camera{
    if (!_camera) {
        _camera = [[FUCamera alloc] init];
        _camera.delegate = self;
    }
    
    return _camera;
}

-(NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize{

    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    float dw = window.frame.size.width - self.view.frame.size.width;
    float dh = window.frame.size.height - self.view.frame.size.height;
    
    NSSize maxSize = sender.maxFullScreenContentSize;
    maxSize.width -= dw;
    maxSize.height -= dh;
    
    NSSize minSize = sender.minFullScreenContentSize;
    minSize.width -= dw;
    minSize.height -= dh;
    
    frameSize.width -= dw;
    frameSize.height -= dh;
    
    float ratio = 2.0/3.0;
    
    if (frameSize.width >= minSize.width && frameSize.width <= maxSize.width ) {
        frameSize.height = frameSize.width * ratio;
    }else if (frameSize.width < minSize.width){
        frameSize = minSize;
    }else{
        frameSize = maxSize;
    }
    
    frameSize.width += dw;
    frameSize.height += dh;
    
    return frameSize;
}

- (void)didOutputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
    
    CVPixelBufferRetain(pixelBuffer);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.metalView displayPixelBuffer:pixelBuffer];
        CVPixelBufferRelease(pixelBuffer);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /**判断是否检测到人脸*/
        self.noTrackView.hidden = [[FUManager shareManager] isTracking];
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
