//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 2/19/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class AGLKElementIndexArrayBuffer;

@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, readonly)GLuint glName;
@property (nonatomic, readonly)GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly)GLsizeiptr stride;

-(id)initWithAttribStride:(GLsizeiptr)stride
         numberOfVertices:(GLsizei)count
                     data:(const GLvoid*)dataPtr
                    usage:(GLenum)usage;

-(void)prepareToDrawWithAttrib:(GLuint)index
           numberOfCoordinates:(GLint)count
                  attribOffset:(GLsizeiptr)offset
                  shouldEnable:(BOOL)shouldEnable;

-(void)drawArrayWithMode:(GLenum)mode
        startVertexIndex:(GLint)first
        numberOfVertices:(GLsizei)count;

@end
