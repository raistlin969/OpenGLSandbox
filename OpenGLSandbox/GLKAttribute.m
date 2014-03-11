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

-(BOOL)isEqual:(id)object
{
    if([object class] != [self class])
        return NO;

    GLKAttribute *other = (GLKAttribute *)object;
    return other.location == self.location && other.type == self.type && [other.nameInShader isEqualToString:self.nameInShader];
}

-(NSUInteger)hash
{
    return [self.nameInShader hash];
}

@end
