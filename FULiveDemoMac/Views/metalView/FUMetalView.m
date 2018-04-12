//
//  FUMetalView.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUMetalView.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

// Vertex data for an image plane
static const float kImagePlaneVertexData[16] = {
    -1.185, -1.0,  1.0, 1.0,
    1.185, -1.0,  0.0, 1.0,
    -1.185,  1.0,  1.0, 0.0,
    1.185,  1.0,  0.0, 0.0,
};

@interface FUMetalView ()

@property (nonatomic, strong) id<MTLCommandQueue> commanQueue;

@property (nonatomic, strong) id<MTLRenderPipelineState> renderPipelineState;

@property (nonatomic, strong) id <MTLDepthStencilState> capturedImageDepthState;

@property (nonatomic, strong) id<MTLBuffer> imagePlaneVertexBuffer;

@end

@implementation FUMetalView{
    CVMetalTextureRef _capturedImageTexture;
    // Captured image texture cache
    CVMetalTextureCacheRef _capturedImageTextureCache;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.device = MTLCreateSystemDefaultDevice();
        
        [self makeVertexBuffer];
        [self makePipeline];
        
        [self setNeedsDisplay:YES];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return self;
}

- (void)makeVertexBuffer{
    self.imagePlaneVertexBuffer = [self.device newBufferWithBytes:&kImagePlaneVertexData length:sizeof(kImagePlaneVertexData) options:MTLResourceCPUCacheModeDefaultCache];
}

- (void)makePipeline{
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    
    
    // Create a vertex descriptor for our image plane vertex buffer
    MTLVertexDescriptor *imagePlaneVertexDescriptor = [[MTLVertexDescriptor alloc] init];
    
    // Positions.
    imagePlaneVertexDescriptor.attributes[0].format = MTLVertexFormatFloat2;
    imagePlaneVertexDescriptor.attributes[0].offset = 0;
    imagePlaneVertexDescriptor.attributes[0].bufferIndex = 0;
    
    // Texture coordinates.
    imagePlaneVertexDescriptor.attributes[1].format = MTLVertexFormatFloat2;
    imagePlaneVertexDescriptor.attributes[1].offset = 8;
    imagePlaneVertexDescriptor.attributes[1].bufferIndex = 0;
    
    // Position Buffer Layout
    imagePlaneVertexDescriptor.layouts[0].stride = 16;
    imagePlaneVertexDescriptor.layouts[0].stepRate = 1;
    imagePlaneVertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
    
    MTLRenderPipelineDescriptor *rpld = [MTLRenderPipelineDescriptor new];
    rpld.label = @"MyCapturedImagePipeline";
    rpld.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    rpld.vertexFunction = [library newFunctionWithName:@"capturedImageVertexTransform"];
    rpld.fragmentFunction = [library newFunctionWithName:@"capturedImageFragmentShader"];
    rpld.sampleCount = 1;
    rpld.vertexDescriptor = imagePlaneVertexDescriptor;
    
    NSError *error;
    self.renderPipelineState = [self.device newRenderPipelineStateWithDescriptor:rpld error:&error];
    
    if (error) {
        NSLog(@"Failed to created captured image pipeline state, error %@", error);
    }
    
    
    MTLDepthStencilDescriptor *capturedImageDepthStateDescriptor = [[MTLDepthStencilDescriptor alloc] init];
    capturedImageDepthStateDescriptor.depthCompareFunction = MTLCompareFunctionAlways;
    capturedImageDepthStateDescriptor.depthWriteEnabled = NO;
    _capturedImageDepthState = [self.device newDepthStencilStateWithDescriptor:capturedImageDepthStateDescriptor];
    
    // Create captured image texture cache
    CVMetalTextureCacheCreate(NULL, NULL, self.device, NULL, &_capturedImageTextureCache);
    
    self.commanQueue = [self.device newCommandQueue];
}

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    
    CVPixelBufferRetain(pixelBuffer);
    dispatch_async(dispatch_get_main_queue(), ^{
        id<CAMetalDrawable> drawable = ((CAMetalLayer *)self.layer).nextDrawable;
        
        if (drawable) {
            
            MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor new];
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1.0);
            renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
            renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
            renderPassDescriptor.colorAttachments[0].texture = [drawable texture];
            
            id<MTLCommandBuffer> commandBuffer = [_commanQueue commandBuffer];
            id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            commandEncoder.label = @"MyRenderEncoder";
            
            CVMetalTextureRef capturedImageTexture = [self createTextureFromPixelBuffer:pixelBuffer pixelFormat:MTLPixelFormatBGRA8Unorm planeIndex:0];
            [self drawCapturedImageWithCommandEncoder:commandEncoder capturedImageTexture:capturedImageTexture];
            
            [commandEncoder endEncoding];
            
            [commandBuffer presentDrawable:drawable];
            [commandBuffer commit];

            [commandBuffer waitUntilCompleted];
            CVBufferRelease(capturedImageTexture);
        }
        CVPixelBufferRelease(pixelBuffer);
    });
}

- (void)drawRect:(NSRect)dirtyRect{
    
}

- (void)drawCapturedImageWithCommandEncoder:(id<MTLRenderCommandEncoder>)renderEncoder capturedImageTexture:(CVMetalTextureRef)capturedImageTexture {
    if (capturedImageTexture == nil) {
        return;
    }
    
    // Push a debug group allowing us to identify render commands in the GPU Frame Capture tool
    [renderEncoder pushDebugGroup:@"DrawCapturedImage"];
    
    // Set render command encoder state
    [renderEncoder setCullMode:MTLCullModeNone];
    [renderEncoder setRenderPipelineState:self.renderPipelineState];
    [renderEncoder setDepthStencilState:self.capturedImageDepthState];
    
    // Set mesh's vertex buffers
    [renderEncoder setVertexBuffer:self.imagePlaneVertexBuffer offset:0 atIndex:0];
    
    // Set any textures read/sampled from our render pipeline
    [renderEncoder setFragmentTexture:CVMetalTextureGetTexture(capturedImageTexture) atIndex:1];
    
    // Draw each submesh of our mesh
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    
//    [renderEncoder popDebugGroup];
}

- (void)updateCapturedImageTexturesWithFrame:(CVPixelBufferRef)pixelBuffer {
    
    CVBufferRelease(_capturedImageTexture);
    _capturedImageTexture = [self createTextureFromPixelBuffer:pixelBuffer pixelFormat:MTLPixelFormatBGRA8Unorm planeIndex:0];
}

- (CVMetalTextureRef)createTextureFromPixelBuffer:(CVPixelBufferRef)pixelBuffer pixelFormat:(MTLPixelFormat)pixelFormat planeIndex:(NSInteger)planeIndex {
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    const size_t width = CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex);
    const size_t height = CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex);
    
    CVMetalTextureRef mtlTextureRef = nil;

    CVReturn status = CVMetalTextureCacheCreateTextureFromImage(NULL, _capturedImageTextureCache, pixelBuffer, NULL, pixelFormat, width, height, planeIndex, &mtlTextureRef);
    if (status != kCVReturnSuccess) {
        CVBufferRelease(mtlTextureRef);
        mtlTextureRef = nil;
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return mtlTextureRef;
}

- (void)dealloc{
    CVBufferRelease(_capturedImageTexture);
}

@end

