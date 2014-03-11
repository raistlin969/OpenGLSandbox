//
//  GLKBufferObject.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKBufferObject.h"

@implementation GLKBufferObject

+(GLKBufferObject *)vertexBufferObject
{
    GLKBufferObject *buffer = [[GLKBufferObject alloc] init];
    buffer.bufferType = GL_ARRAY_BUFFER;
    return buffer;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        glGenBuffers(1, &_name);
    }
    return self;
}

-(void)dealloc
{
    if(self.name > 0)
    {
        NSLog(@"[%@] glDeleteBuffer(%i)", [self class], self.name);
        glDeleteBuffers(1, &(_name));
    }
}

-(void)bind
{
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
}

-(GLenum)getUsageEnumValueFromFrequency:(GLKBufferObjectFrequency)frequency nature:(GLKBufferObjectNature)nature
{
    GLenum usage;
    switch (frequency)
    {
        case GLKBufferObjectFrequencyDynamic:
        {
            switch (nature)
            {
                case GLKBufferObjectNatureCopy:
                case GLKBufferObjectNatureRead:
                    NSAssert(FALSE, @"Illegal in GL ES 2");
                    usage = 0;
                    break;
                    
                case GLKBufferObjectNatureDraw:
                    usage = GL_DYNAMIC_DRAW;
                    break;
                    
                default:
                    NSAssert(FALSE, @"Illegal Parameters");
                    break;
            }
        }
        break;
            
        case GLKBufferObjectFrequencyStatic:
        {
            switch (nature)
            {
                case GLKBufferObjectNatureCopy:
                case GLKBufferObjectNatureRead:
                    NSAssert(FALSE, @"Illegal in GL ES 2");
                    usage = 0;
                    break;
                    
                case GLKBufferObjectNatureDraw:
                    usage = GL_STATIC_DRAW;
                    break;
                    
                default:
                    NSAssert(FALSE, @"Illegal Parameters");
                    break;
            }
        }
        break;
            
        case GLKBufferObjectFrequencyStream:
        {
            switch (nature)
            {
                case GLKBufferObjectNatureCopy:
                case GLKBufferObjectNatureRead:
                    NSAssert(FALSE, @"Illegal in GL ES 2");
                    usage = 0;
                    break;
                    
                case GLKBufferObjectNatureDraw:
                    usage = GL_STREAM_DRAW;
                    break;
                    
                default:
                    NSAssert(FALSE, @"Illegal Parameters");
                    break;
            }
        }
        break;

        default:
            NSAssert(FALSE, @"Illegal Parameters");
            break;
    }
    return usage;
}

-(void)setCurrentFormat:(GLKBufferFormat *)currentFormat
{
    _currentFormat = currentFormat;
    self.totalBytesPerItem = 0;
    for(int i = 0; i < self.currentFormat.numberOfSubTypes; i++)
    {
        GLsizeiptr bytesPerItem = [self.currentFormat bytesPerItemForSubTypeIndex:i];
        NSAssert(bytesPerItem > 0, @"Invalid GLKBufferFormat");
        self.totalBytesPerItem += bytesPerItem;
    }
}

-(void)upload:(void *)dataArray numItems:(int)count usageHint:(GLenum)usage withNewFormat:(GLKBufferFormat *)format
{
    self.currentFormat = format;
    [self upload:dataArray numItems:count usageHint:usage];
}

-(void)upload:(void *)dataArray numItems:(int)count usageHint:(GLenum)usage
{
    NSAssert(self.currentFormat != nil, @"Use version that takes a new format, or set current format manually");
    glBindBuffer(self.bufferType, self.name);
    glBufferData(GL_ARRAY_BUFFER, count * self.totalBytesPerItem, dataArray, usage);
}

@end
