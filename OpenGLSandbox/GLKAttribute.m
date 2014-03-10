//
//  GLKAttribute.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKAttribute.h"

@implementation GLKAttribute

+(GLKAttribute *)attributeNamed:(NSString *)nameOfAttribute GLType:(GLenum)openGLType GLLocation:(GLint)openGLLocation GLSize:(GLint)openGLSize
{
    GLKAttribute *att = [[GLKAttribute alloc] init];
    att.nameInShader = nameOfAttribute;
    att.type = openGLType;
    att.location = openGLLocation;
    att.size = openGLSize;

    return att;
}

@end
