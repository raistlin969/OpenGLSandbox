//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 2/19/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer()

@property (nonatomic, assign)GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign)GLsizeiptr stride;

@end

@implementation AGLKVertexAttribArrayBuffer

-(id)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);

    if(nil != (self = [super init]))
    {
        _stride = stride;
        _bufferSizeBytes = stride * count;

        glGenBuffers(1, &_glName);
        glBindBuffer(GL_ARRAY_BUFFER, _glName);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);

        NSAssert(0 != _glName, @"Failed to generate glName");
    }
    return self;
}

-(void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert(0 < count);
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != self.glName, @"Invalid glName");

    glBindBuffer(GL_ARRAY_BUFFER, self.glName);

    if(shouldEnable)
    {
        glEnableVertexAttribArray(index);
    }

    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
}

-(void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride), @"Attempt to draw more vertex data than available");
    glDrawArrays(mode, first, count);
}

-(void)dealloc
{
    if(0 != self.glName)
    {
        glDeleteBuffers(1, &_glName);
        _glName = 0;
    }
}

@end
