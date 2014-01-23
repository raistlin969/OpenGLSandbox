//
//  GLKProgramPipelineObject.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/22/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKProgramPipelineObject.h"

@implementation GLKProgramPipelineObject

-(id)initWithVertex:(GLKSeparateProgram *)vertex Fragment:(GLKSeparateProgram *)fragment
{
    self = [super init];
    if(self)
    {
        _vertexProgram = vertex;
        _fragmentProgram = fragment;
        glGenProgramPipelinesEXT(1, &_handle);
        glBindProgramPipelineEXT(_handle);
        glUseProgramStagesEXT(_handle, GL_VERTEX_SHADER_BIT_EXT, _vertexProgram.handle);
        glUseProgramStagesEXT(_handle, GL_FRAGMENT_SHADER_BIT_EXT, _fragmentProgram.handle);
#if defined(DEBUG)
        glValidateProgramPipelineEXT(_handle);
        GLint logLength;
        glGetProgramPipelineivEXT(self.handle, GL_INFO_LOG_LENGTH, &logLength);
        if(logLength > 0)
        {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetProgramPipelineInfoLogEXT(self.handle, logLength, &logLength, log);
            NSLog(@"Pipeline Validation:\n%s", log);
            free(log);
        }
#endif
    }
    return self;
}

@end
