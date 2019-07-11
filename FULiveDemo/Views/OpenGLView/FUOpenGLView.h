//
//  FUOpenGLView.h
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/15.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FUOpenGLView : NSOpenGLView

- (void)displayImageData:(void *)imageData withSize:(CGSize)size withPoints:(int16_t *)points count:(int)count;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end
