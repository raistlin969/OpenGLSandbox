//
//  GLKVertexArrayObject.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKBufferObject.h"

@class GLKAttribute;

@interface GLKVertexArrayObject : NSObject

@property(nonatomic)GLuint name;
@property(strong, nonatomic)NSMutableArray *VBOs;

-(GLKBufferObject *)addVBOForAttribute:(GLKAttribute *)targetAttribute
                        filledWithData:(void *)data
                  bytesPerArrayElement:(GLsizeiptr)bytesPerDataItem
                           arrayLength:(int)numDataItems;   //defaults to GL_STATIC_DRAW

-(GLKBufferObject *)addVBOForAttribute:(GLKAttribute *)targetAttribute
                        filledWithData:(void *)data
                  bytesPerArrayElement:(GLsizeiptr)bytesPerDataItem
                           arrayLength:(int)numDataItems
                       updateFrequency:(GLKBufferObjectFrequency)freq;

@end
