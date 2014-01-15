//
//  GLKProgram.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/9/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKProgram.h"
#import "GLKShader.h"

@implementation GLKProgram

-(id)init
{
    self = [super init];
    if(self)
    {
        _status = GLKShaderProgramStatusUnlinked;
        _vertexShader = nil;
        _fragmentShader = nil;
        _program = glCreateProgram();
    }
    return self;
}

-(BOOL)loadFromFileVertexShader:(NSString *)vFilename FragmentShader:(NSString *)fFilename
{
    self.vertexShader = [[GLKShader alloc] initFromFile:vFilename Type:GLKShaderTypeVertex];
    BOOL result = [self.vertexShader compile];
    if(!result)
    {
        NSLog(@"Vertex Shader failed to compile");
        return NO;
    }
    self.fragmentShader = [[GLKShader alloc] initFromFile:fFilename Type:GLKShaderTypeFragment];
    result = [self.fragmentShader compile];
    if(!result)
    {
        NSLog(@"Fragment Shader failed to compile");
        return NO;
    }
    glAttachShader(self.program, self.vertexShader.handle);
    glAttachShader(self.program, self.fragmentShader.handle);
    return YES;
}

@end
