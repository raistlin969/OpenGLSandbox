//
//  GLKProgramPipelineObject.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/22/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKProgramPipelineObject.h"
#import "GLKAttribute.h"

@implementation GLKProgramPipelineObject

-(id)initWithVertex:(GLKSeparateProgram *)vertex Fragment:(GLKSeparateProgram *)fragment
{
    self = [super init];
    if(self)
    {
        _vertexAttributesByName = [[NSMutableDictionary alloc] init];
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
        GLint numCharsInLongestName;
        glGetProgramiv(_vertexProgram.handle, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &numCharsInLongestName);
        char *nextName = malloc(sizeof(char) * numCharsInLongestName);

        //how many attributes did we find
        GLint numAttributesFound;
        glGetProgramiv(_vertexProgram.handle, GL_ACTIVE_ATTRIBUTES, &numAttributesFound);

        for(int i = 0; i < numAttributesFound; i++)
        {
            GLint attributeLocation;
            GLint attributeSize;
            GLenum attributeType;
            NSString *stringName;
            glGetActiveAttrib(_vertexProgram.handle, i, numCharsInLongestName, NULL, &attributeSize, &attributeType, nextName);
            attributeLocation = glGetAttribLocation(_vertexProgram.handle, nextName);
            stringName = [NSString stringWithUTF8String:nextName];

            GLKAttribute *newAttribute = [GLKAttribute attributeNamed:stringName GLType:attributeType GLLocation:attributeLocation GLSize:attributeSize];
            [_vertexAttributesByName setObject:newAttribute forKey:stringName];
        }
        free(nextName);
    }
    return self;
}

@end
