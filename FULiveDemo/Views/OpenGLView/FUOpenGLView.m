//
//  FUOpenGLView.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/15.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUOpenGLView.h"
#import <CoreVideo/CoreVideo.h>
#import <GLKit/GLKit.h>
#import <AppKit/AppKit.h>
#define STRINGIZE(x)    #x
#define STRINGIZE2(x)    STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const FUYUVToRGBAFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mat3 colorConversionMatrix;
 
 void main()
 {
    vec3 yuv;
    vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).rg - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1.0);
 }
 );


NSString *const FURGBAFragmentShaderString = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 
 varying vec2 textureCoordinate;
 
 void main()
{
    gl_FragColor = vec4(texture2D(inputImageTexture, textureCoordinate).rgb,1.0);
}
 );

NSString *const FUVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

NSString *const FUPointsFrgShaderString = SHADER_STRING
(
 
 void main()
{
    gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}
 
 );

NSString *const FUPointsVtxShaderString = SHADER_STRING
(
 attribute vec4 position;
 
 void main()
{
    gl_Position = position;
    
    gl_PointSize = 10.0;
}
 );

enum
{
    furgbaPositionAttribute,
    furgbaTextureCoordinateAttribute,
};

enum
{
    fuyuvConversionPositionAttribute,
    fuyuvConversionTextureCoordinateAttribute
};

@interface FUOpenGLView()

@property (nonatomic, strong) NSOpenGLPixelFormat *mPixelFormat;

@property(nonatomic) dispatch_queue_t contextQueue;

@end

@implementation FUOpenGLView
{
    GLuint rgbaProgram;
    
    GLuint pointProgram;
    
    GLint displayInputTextureUniform;
    
    GLfloat vertices[8];
    
    int frameWidth;
    int frameHeight;
    int backingWidth;
    int backingHeight;
    
    GLuint texture;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonInit];
    }
        
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame] ) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit;
{
    _contextQueue = dispatch_queue_create("com.faceunity.contextQueue", DISPATCH_QUEUE_SERIAL);
    
    NSOpenGLPixelFormatAttribute pixelFormatAttributes[] = {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAccelerated, 0,
        0
    };
    
    _mPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:pixelFormatAttributes];
    if (_mPixelFormat == nil)
    {
        NSLog(@"Error: No appropriate pixel format found");
    }

    NSOpenGLContext *glContext = [[NSOpenGLContext alloc] initWithFormat:_mPixelFormat shareContext:nil];

    if ([self respondsToSelector:@selector(setWantsBestResolutionOpenGLSurface:)])
    {
        [self  setWantsBestResolutionOpenGLSurface:YES];
    }

    [self setOpenGLContext:glContext];
    [self createDisplayFramebuffer];
    [self.openGLContext makeCurrentContext];
}

//- (void)layoutSubviews{
//
//    [super layoutSubviews];
//
//    // The frame buffer needs to be trashed and re-created when the view size changes.
//    if (!CGSizeEqualToSize(self.bounds.size, boundsSizeAtFrameBufferEpoch) &&
//        !CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
//
//        boundsSizeAtFrameBufferEpoch = self.bounds.size;
//
//        dispatch_async(_contextQueue, ^{
//            [self destroyDisplayFramebuffer];
//            [self createDisplayFramebuffer];
//            [self updateVertices];
//        });
//    }
//}

- (void)dealloc
{
    dispatch_sync(_contextQueue, ^{
        [self destroyDisplayFramebuffer];
        [self destoryProgram];
    });
}

- (void)createDisplayFramebuffer
{
    CGSize size;
    // Perhaps I'll use an FBO at some time later, but for now will render directly to the screen
    if ([self respondsToSelector:@selector(convertSizeToBacking:)])
    {
        size = [self convertSizeToBacking:self.bounds.size];
        
    }
    else
    {
        size = self.bounds.size;
    }
    
    backingWidth = size.width;
    backingHeight = size.height;
}

- (void)destroyDisplayFramebuffer;
{
    [self.openGLContext makeCurrentContext];
}

- (void)setDisplayFramebuffer;
{
//    glBindFramebuffer(GL_FRAMEBUFFER, 0);
//    glBindRenderbuffer(GL_RENDERBUFFER, 0);
//
//    glViewport(0, 0, (GLint)backingWidth, (GLint)backingHeight);
}

- (void)destoryProgram{
    if (rgbaProgram) {
        glDeleteProgram(rgbaProgram);
        rgbaProgram = 0;
    }
}

- (void)presentFramebuffer;
{
    [self.openGLContext flushBuffer];
}

- (CGSize)maximumOutputSize;
{
    if ([self respondsToSelector:@selector(convertSizeToBacking:)])
    {
        return [self convertSizeToBacking:self.bounds.size];
    }
    else
    {
        return self.bounds.size;
    }
}

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer{

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *imageData = CVPixelBufferGetBaseAddress(pixelBuffer);
    float w = CVPixelBufferGetBytesPerRow(pixelBuffer)/4;
    float h = CVPixelBufferGetHeight(pixelBuffer);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    [self displayImageData:imageData withSize:CGSizeMake(w, h) withPoints:NULL count:0];
}

- (void)displayImageData:(void *)imageData withSize:(CGSize)size withPoints:(int16_t *)points count:(int)count {

    frameWidth = (int)size.width;
    frameHeight = (int)size.height;
    
    [self.openGLContext makeCurrentContext];
    
    [self createDisplayFramebuffer];
//    [self setDisplayFramebuffer];
    
    if (!rgbaProgram) {
        [self loadShadersRGBA];
    }

    if (texture == 0) {
        glGenTextures(1, &texture);
    }

    glBindTexture(GL_TEXTURE_2D, texture);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(rgbaProgram);

    // Re-render onscreen, flipped to a normal orientation
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(displayInputTextureUniform, 1);

    [self updateVertices];

    // 更新顶点数据
    glVertexAttribPointer(furgbaPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glEnableVertexAttribArray(furgbaPositionAttribute);

    GLfloat quadTextureData[] =  {
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        0.0f,  0.0f,
    };

    glVertexAttribPointer(furgbaTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, quadTextureData);
    glEnableVertexAttribArray(furgbaTextureCoordinateAttribute);

    BOOL canLockFocus = YES;
    if ([self respondsToSelector:@selector(lockFocusIfCanDraw)])
    {
        canLockFocus = [self lockFocusIfCanDraw];
    }
    else
    {
        [self lockFocus];
    }

    if (canLockFocus)
    {
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        [self unlockFocus];
    }
    if (points != NULL) {
        [self prepareToDrawPoint:points count:count];
    }
    
    [self presentFramebuffer];
    glBindTexture(GL_TEXTURE_2D, 0);
    
}

- (void)updateVertices
{
    const float width   = frameWidth;
    const float height  = frameHeight;
    const float dH      = (float)backingHeight / height;
    const float dW      = (float)backingWidth      / width;
    const float dd      = MAX(dH, dW);
    const float h       = (height * dd / (float)backingHeight);
    const float w       = (width  * dd / (float)backingWidth );
    
    vertices[0] = - w;
    vertices[1] = - h;
    vertices[2] =   w;
    vertices[3] = - h;
    vertices[4] = - w;
    vertices[5] =   h;
    vertices[6] =   w;
    vertices[7] =   h;
}

- (void)prepareToDrawPoint:(int16_t *)points count:(int)count
{
    if (!pointProgram) {
        [self loadPointsShaders];
    }
    
    glUseProgram(pointProgram);
    
    float tmpPoints[count*2];

    for (int i = 0; i < count; i++)
    {
        //转化坐标
        
        float x = i*1.0/count*frameWidth;
        float y = points[i]*1.0/65534;
        if (y+0.0000001 >= 0.5) {
            y = 1;
        }
        //转化坐标
        tmpPoints[2 * i] = (float)((2 * x / frameWidth - 1));
        tmpPoints[2 * i + 1] = y;
    }
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, (GLfloat *)tmpPoints);
    
    BOOL canLockFocus = YES;
    if ([self respondsToSelector:@selector(lockFocusIfCanDraw)])
    {
        canLockFocus = [self lockFocusIfCanDraw];
    }
    else
    {
        [self lockFocus];
    }
    
    if (canLockFocus)
    {
        glDrawArrays(GL_LINES, 0, count);
        [self unlockFocus];
    }
   
}


#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShadersRGBA
{
    GLuint vertShader, fragShader;
    
    if (!rgbaProgram) {
        rgbaProgram = glCreateProgram();
    }
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:FUVertexShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:FURGBAFragmentShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(rgbaProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(rgbaProgram, fragShader);
    
    // Bind attribute locations. This needs to be done prior to linking.
    glBindAttribLocation(rgbaProgram, furgbaPositionAttribute, "position");
    glBindAttribLocation(rgbaProgram, furgbaTextureCoordinateAttribute, "inputTextureCoordinate");
    
    // Link the program.
    if (![self linkProgram:rgbaProgram]) {
        NSLog(@"Failed to link program: %d", rgbaProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (rgbaProgram) {
            glDeleteProgram(rgbaProgram);
            rgbaProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    displayInputTextureUniform = glGetUniformLocation(rgbaProgram, "inputImageTexture");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(rgbaProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(rgbaProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type string:(NSString *)shaderString
{
    GLint status;
    const GLchar *source;
    source = (GLchar *)[shaderString UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)loadPointsShaders
{
    GLuint vertShader, fragShader;
    
    pointProgram = glCreateProgram();
    
    // Create and compile the vertex shader.
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER string:FUPointsVtxShaderString]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER string:FUPointsFrgShaderString]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(pointProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(pointProgram, fragShader);
    
    // Link the program.
    if (![self linkProgram:pointProgram]) {
        NSLog(@"Failed to link program: %d", pointProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (pointProgram) {
            glDeleteProgram(pointProgram);
            pointProgram = 0;
        }
        
        return NO;
    }
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(pointProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(pointProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
@end
