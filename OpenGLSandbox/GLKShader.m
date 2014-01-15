//
//  GLKShader.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/8/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKShader.h"

@implementation GLKShader

-(id)initFromFile:(NSString *)fname Type:(GLKShaderType)type
{
    self = [super init];
    if(self)
    {
        _type = type;
        _status = GLKShaderStatusUncompiled;
        GLenum t = type == GLKShaderTypeVertex ? GL_VERTEX_SHADER : GL_FRAGMENT_SHADER;
        _handle = glCreateShader(t);
        NSError *error = nil;
        const GLchar *source = [[NSString stringWithContentsOfFile:fname encoding:NSUTF8StringEncoding error:&error] UTF8String];
        if(error)
            NSLog(@"Error reading in file:\n%@", [error description]);
        else
            glShaderSource(_handle, 1, &source, NULL);
    }
    return self;
}

-(BOOL)compile
{
    GLint status;
    glCompileShader(self.handle);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(self.handle, GL_INFO_LOG_LENGTH, &logLength);
    if(logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(self.handle, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif

    glGetShaderiv(self.handle, GL_COMPILE_STATUS, &status);
    if(status == 0)
    {
        glDeleteShader(self.handle);
        return NO;
    }
    self.status = GLKShaderStatusCompiled;
    return YES;
}

@end
