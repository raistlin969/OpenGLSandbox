//
//  GLKVertexArrayObject.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKVertexArrayObject.h"
#import "GLKAttribute.h"

@implementation GLKVertexArrayObject

-(id)init
{
    self = [super init];
    if(self)
    {
        glGenVertexArraysOES(1, &_name);
        _VBOs = [NSMutableArray array];
    }
    return self;
}

-(GLKBufferObject *)addVBOForAttribute:(GLKAttribute *)targetAttribute
                        filledWithData:(void *)data
                  bytesPerArrayElement:(GLsizeiptr)bytesPerDataItem
                           arrayLength:(int)numDataItems
{
    return [self addVBOForAttribute:targetAttribute
                     filledWithData:data
               bytesPerArrayElement:bytesPerDataItem
                        arrayLength:numDataItems
                    updateFrequency:GLKBufferObjectFrequencyStatic];
}

-(GLKBufferObject *)addVBOForAttribute:(GLKAttribute *)targetAttribute
                        filledWithData:(void *)data
                  bytesPerArrayElement:(GLsizeiptr)bytesPerDataItem
                           arrayLength:(int)numDataItems
                       updateFrequency:(GLKBufferObjectFrequency)freq
{
    NSAssert(targetAttribute != nil, @"Can't add a VBO for a nil vertex attribute");
    return [self addVBOForAttributes:@[targetAttribute]
                      filledWithData:data
                            inFormat:[GLKBufferFormat bufferFormatWithSingleTypeOfFloats:bytesPerDataItem/4 bytesPerItem:bytesPerDataItem]
                         numVertices:numDataItems
                     updateFrequency:freq];
}

-(GLKBufferObject *)addVBOForAttributes:(NSArray *)targetAttributes
                         filledWithData:(void *)data
                               inFormat:(GLKBufferFormat *)format
                            numVertices:(int)numDataItems
                        updateFrequency:(GLKBufferObjectFrequency)freq
{
    //create vbo on gpu to store data
    GLKBufferObject *vbo = [GLKBufferObject vertexBufferObject];
    [self.VBOs addObject:vbo];
    //send vertex data to new vbo
    [vbo upload:data numItems:numDataItems usageHint:[vbo getUsageEnumValueFromFrequency:freq nature:GLKBufferObjectNatureDraw] withNewFormat:format];
    
    //configure vao state
    glBindVertexArrayOES(self.name);
    GLsizeiptr bytesForPreviousItems = 0;
    int i = -1;
    for(GLKAttribute *attribute in targetAttributes)
    {
        i++;
        GLuint numFloatsForItem = [vbo.currentFormat sizePerItemInFloatsForSubTypeIndex:i];
        GLsizeiptr bytesPerItem = [vbo.currentFormat bytesPerItemForSubTypeIndex:i];
        
        glEnableVertexAttribArray(attribute.location);
        glVertexAttribPointer(attribute.location, numFloatsForItem, GL_FLOAT, GL_FALSE, vbo.totalBytesPerItem, (const GLvoid *)bytesForPreviousItems);
        bytesForPreviousItems += bytesPerItem;
    }
    glBindVertexArrayOES(0);
    return vbo;
}

@end
