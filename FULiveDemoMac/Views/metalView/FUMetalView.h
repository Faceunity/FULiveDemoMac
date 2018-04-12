//
//  FUMetalView.h
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MetalKit/MetalKit.h>

@interface FUMetalView : MTKView
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end
