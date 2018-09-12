//
//  Shaders.metal
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/7.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

    typedef enum VertexAttributes {
        kVertexAttributePosition  = 0,
        kVertexAttributeTexcoord  = 1,
        } VertexAttributes;
    
typedef struct {
    float2 position [[attribute(kVertexAttributePosition)]];
    float2 texCoord [[attribute(kVertexAttributeTexcoord)]];
} ImageVertex;

typedef struct {
    float4 position [[position]];
    float2 texCoord;
} ImageColorInOut;



// Captured image vertex function
vertex ImageColorInOut capturedImageVertexTransform(ImageVertex in [[stage_in]]) {
    ImageColorInOut out;
    
    // Pass through the image vertex's position
    out.position = float4(in.position, 0.0, 1.0);
    
    // Pass through the texture coordinate
    out.texCoord = in.texCoord;
    
    return out;
}

// Captured image fragment function
fragment float4 capturedImageFragmentShader(ImageColorInOut in [[stage_in]],
                                            texture2d<float, access::sample> capturedImageTexture [[ texture(1) ]]) {
    
    constexpr sampler colorSampler(mip_filter::linear,
                                   mag_filter::linear,
                                   min_filter::linear);
    
    // Return converted RGB color
    return capturedImageTexture.sample(colorSampler, in.texCoord);;
}
