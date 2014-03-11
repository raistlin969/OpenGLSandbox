//
//  GLKBufferObject.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKBufferFormat.h"

typedef enum GLKBufferObjectFrequency
{
    GLKBufferObjectFrequencyStream,
    GLKBufferObjectFrequencyStatic,
    GLKBufferObjectFrequencyDynamic
} GLKBufferObjectFrequency;

typedef enum GLKBufferObjectNature
{
    GLKBufferObjectNatureDraw,
    GLKBufferObjectNatureRead,
    GLKBufferObjectNatureCopy
} GLKBufferObjectNature;

@interface GLKBufferObject : NSObject

@property (nonatomic)GLuint name;
@property (nonatomic)GLenum bufferType;
@property (strong, nonatomic)GLKBufferFormat *currentFormat;
@property (nonatomic)GLsizeiptr totalBytesPerItem;

+(GLKBufferObject *)vertexBufferObject;
-(GLenum)getUsageEnumValueFromFrequency:(GLKBufferObjectFrequency)frequency nature:(GLKBufferObjectNature)nature;
-(void)upload:(void *)dataArray numItems:(int) count usageHint:(GLenum)usage withNewFormat:(GLKBufferFormat *)format;
-(void)upload:(void *)dataArray numItems:(int) count usageHint:(GLenum)usage;

@end
