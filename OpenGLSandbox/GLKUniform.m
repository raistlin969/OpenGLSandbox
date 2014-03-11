//
//  GLKUniform.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/11/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKUniform.h"

@implementation GLKUniform

+(GLKUniform *)uniformNamed:(NSString *)nameOfUniform GLType:(GLenum)openGLType GLLocation:(GLint)openGLLocation numElementsInArray:(GLint)numElements
{
    GLKUniform *uni = [[GLKUniform alloc]init];
    uni.nameInShader = nameOfUniform;
    uni.type = openGLType;
    uni.location = openGLLocation;
    uni.arrayLength = numElements;
    return uni;
}

-(BOOL)isInteger
{
    switch (self.type)
    {
        case GL_INT:
        case GL_INT_VEC2:
        case GL_INT_VEC3:
        case GL_INT_VEC4:
            return YES;

        default:
            return FALSE;
    }
}

-(BOOL)isFloat
{
    switch (self.type)
    {
        case GL_FLOAT:
        case GL_FLOAT_VEC2:
        case GL_FLOAT_VEC3:
        case GL_FLOAT_VEC4:
        case GL_FLOAT_MAT2:
        case GL_FLOAT_MAT3:
        case GL_FLOAT_MAT4:
            return YES;

        default:
            return NO;
    }
}

-(BOOL)isMatrix
{
    switch (self.type)
    {
        case GL_FLOAT_MAT2:
        case GL_FLOAT_MAT3:
        case GL_FLOAT_MAT4:
            return YES;

        default:
            return NO;
    }
}

-(BOOL)isVector
{
    switch (self.type)
    {
        case GL_FLOAT_VEC2:
        case GL_FLOAT_VEC3:
        case GL_FLOAT_VEC4:
        case GL_INT_VEC2:
        case GL_INT_VEC3:
        case GL_INT_VEC4:
            return YES;

        default:
            return NO;
    }
}

-(int)vectorWidth
{
    switch (self.type)
    {
        case GL_INT_VEC2:
        case GL_FLOAT_VEC2:
            return 2;
        case GL_FLOAT_VEC3:
        case GL_INT_VEC3:
            return 3;
        case GL_INT_VEC4:
        case GL_FLOAT_VEC4:
            return 4;

        default:
            return 0;
    }
}

-(int)matrixWidth
{
    switch (self.type)
    {
        case GL_FLOAT_MAT2:
            return 2;
        case GL_FLOAT_MAT3:
            return 3;
        case GL_FLOAT_MAT4:
            return 4;

        default:
            return 0;
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<GLK2Uniform:\"%@\" @ %i: %@%@>", self.nameInShader, self.location, self.isVector ? [NSString stringWithFormat:@"vec%i", self.vectorWidth] : self.isMatrix ? [NSString stringWithFormat:@"mat%i", self.matrixWidth] : self.isFloat ? @"float" : self.isInteger ? @"int" : @"unknown type", self.arrayLength < 2 ?@"" : [NSString stringWithFormat:@" (%i array elements)", self.arrayLength]];
}

-(id)copyWithZone:(NSZone *)zone
{
    GLKUniform *newCopy = [[GLKUniform allocWithZone:zone] init];
    newCopy.nameInShader = self.nameInShader;
    newCopy.type = self.type;
    newCopy.location = self.location;
    newCopy.arrayLength = self.arrayLength;
    return newCopy;
}

-(BOOL)isEqual:(id)object
{
    if([object class] != [self class])
        return NO;

    GLKUniform *other = (GLKUniform *)object;
    return other.location == self.location && other.type == self.type && other.arrayLength == self.arrayLength && [other.nameInShader isEqualToString:self.nameInShader];
}

-(NSUInteger)hash
{
    return [self.nameInShader hash];
}

@end
