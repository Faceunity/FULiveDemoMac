//
//  FUHelpDocViewController.m
//  FULiveDemo
//
//  Created by 孙慕 on 2018/8/22.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUHelpDocViewController.h"
#import <WebKit/WebKit.h>

@interface FUHelpDocViewController ()<WebUIDelegate,WebFrameLoadDelegate>
@property (weak) IBOutlet WebView *mWebView;

/* 加载菊花 */
@property (retain) NSProgressIndicator* indicator;

@end

@implementation FUHelpDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    NSString *path = [[NSBundle mainBundle] pathForResource:@"README" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    
    [[_mWebView mainFrame] loadHTMLString:path baseURL:nil];
    [[_mWebView mainFrame] loadRequest:request];
    [_mWebView setFrameLoadDelegate:self];
    _mWebView.UIDelegate = self;
    
    
    // _mWebView.layer.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.0].CGColor;
    _mWebView.layer.backgroundColor = [NSColor redColor].CGColor;
    
    float x =  self.view.frame.size.width / 2 - 15;
    float y =  self.view.frame.size.height / 2 - 15;
    
    _indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(x, y, 30, 30)];
    [_indicator setStyle:NSProgressIndicatorSpinningStyle];
    
    _indicator.controlSize = NSControlSizeRegular;
    [_indicator sizeToFit];    
    [self.view addSubview:_indicator];
    [self.indicator startAnimation:nil];
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    [self.indicator stopAnimation:nil];
    self.indicator.hidden = YES;
}


//-页面完成加载里调用
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    NSLog(@"加载完成");
    [self.indicator stopAnimation:nil];
    self.indicator.hidden = YES;
}



@end
