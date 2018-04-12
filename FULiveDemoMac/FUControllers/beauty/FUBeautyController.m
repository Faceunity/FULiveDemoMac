//
//  FUBeautyController.m
//  FULiveDemoMac
//
//  Created by ly-Mac on 2018/3/11.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUBeautyController.h"
#import "FUManager.h"

@interface FUBeautyController ()
@property (weak) IBOutlet NSTextField *whiteLabel;
@property (weak) IBOutlet NSSlider *whiteSlider;
@property (weak) IBOutlet NSTextField *redLabel;
@property (weak) IBOutlet NSSlider *redSlider;
@property (weak) IBOutlet NSTextField *faceShapeLabel;
@property (weak) IBOutlet NSSlider *faceShapeSlider;
@property (weak) IBOutlet NSTextField *enlargingLabel;
@property (weak) IBOutlet NSSlider *enlargingSlider;
@property (weak) IBOutlet NSTextField *thinningLabel;
@property (weak) IBOutlet NSSlider *thinningSlider;
@property (weak) IBOutlet NSPopUpButton *blurPopUpButton;
@property (weak) IBOutlet NSPopUpButton *faceShapePopUpButton;
@property (weak) IBOutlet NSButton *skinDetectButton;

@end

@implementation FUBeautyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    self.view .layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.5].CGColor;
    [self.view setNeedsDisplay:YES];
    
    self.whiteSlider.doubleValue = [FUManager shareManager].beautyLevel;
    self.whiteLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].beautyLevel];
    self.redSlider.doubleValue = [FUManager shareManager].redLevel;
    self.redLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].redLevel];
    [self.blurPopUpButton selectItemWithTag:[FUManager shareManager].selectedBlur];
    self.skinDetectButton.state = [FUManager shareManager].skinDetectEnable ? NSControlStateValueOn:NSControlStateValueOff;
    [self.faceShapePopUpButton selectItemWithTag:[FUManager shareManager].faceShape];
    self.faceShapeLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].faceShapeLevel];
    self.faceShapeSlider.doubleValue = [FUManager shareManager].faceShapeLevel;
    self.enlargingLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].enlargingLevel];
    self.enlargingSlider.doubleValue = [FUManager shareManager].enlargingLevel;
    self.thinningLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].thinningLevel];
    self.thinningSlider.doubleValue = [FUManager shareManager].thinningLevel;
    
    NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self.skinDetectButton attributedTitle]];
    NSRange titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:[NSColor highlightColor] range:titleRange];
    [self.skinDetectButton setAttributedTitle:colorTitle];
}
- (IBAction)skinDetectValueChanged:(NSButton *)sender {
    [FUManager shareManager].skinDetectEnable = sender.state == NSControlStateValueOn;
}

- (IBAction)popUpBtnValueChanged:(NSPopUpButton *)sender {
    if (sender == self.blurPopUpButton) {
        [FUManager shareManager].selectedBlur = sender.selectedTag;
    }else if (sender == self.faceShapePopUpButton){
        [FUManager shareManager].faceShape = sender.selectedTag;
    }
}

- (IBAction)sliderValueDidchanged:(NSSlider *)slider{
    if (slider == self.whiteSlider) {
        [FUManager shareManager].beautyLevel = slider.doubleValue;
        self.whiteLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].beautyLevel];
    }else if (slider == self.redSlider){
        [FUManager shareManager].redLevel = slider.doubleValue;
        self.redLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].redLevel];
    }else if (slider == self.faceShapeSlider){
        [FUManager shareManager].faceShapeLevel = slider.doubleValue;
        self.faceShapeLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].faceShapeLevel];
    }else if (slider == self.enlargingSlider){
        [FUManager shareManager].enlargingLevel = slider.doubleValue;
        self.enlargingLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].enlargingLevel];
    }else if (slider == self.thinningSlider){
        [FUManager shareManager].thinningLevel = slider.doubleValue;
        self.thinningLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].thinningLevel];
    }
}

@end
