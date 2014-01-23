//
//  GLKSeparateProgram.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/15/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKSeparateProgram.h"

@implementation GLKSeparateProgram

-(id)initFromFile:(NSString *)filePath ShaderType:(GLKShaderType)type
{
    self = [super init];
    if(self)
    {
        _type = type;
        GLenum t = type == GLKShaderTypeVertex ? GL_VERTEX_SHADER : GL_FRAGMENT_SHADER;
        NSError *error = nil;
        const GLchar *source = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] UTF8String];
        if(error)
        {
            NSLog(@"Error reading in file:\n%@", [error description]);
            _handle = 0;
        }
        else
        {
            _handle = glCreateShaderProgramvEXT(t, 1, &source);
#if defined(DEBUG)
            GLint logLength;
            glGetProgramiv(self.handle, GL_INFO_LOG_LENGTH, &logLength);
            if(logLength > 0)
            {
                GLchar *log = (GLchar *)malloc(logLength);
                glGetProgramInfoLog(self.handle, logLength, &logLength, log);
                NSLog(@"Shader compile log:\n%s", log);
                free(log);
            }
#endif

        }
    }
    return self;
}

@end
