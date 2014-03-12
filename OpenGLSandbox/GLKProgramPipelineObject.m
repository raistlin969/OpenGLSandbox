//
//  GLKProgramPipelineObject.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/22/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKProgramPipelineObject.h"
#import "GLKAttribute.h"
#import "GLKUniform.h"

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

        //uniforms
        _uniformVariablesByName = [[NSMutableDictionary alloc] init];
        glGetProgramiv(_fragmentProgram.handle, GL_ACTIVE_UNIFORM_MAX_LENGTH, &numCharsInLongestName);
        nextName = malloc(sizeof(char) * numCharsInLongestName);

        GLint numUniformsFound;
        glGetProgramiv(_fragmentProgram.handle, GL_ACTIVE_UNIFORMS, &numUniformsFound);

        for(int i = 0; i < numUniformsFound; i++)
        {
            GLint uniformSize, uniformLocation;
            GLenum uniformType;
            NSString *stringName;

            glGetActiveUniform(_fragmentProgram.handle, i, numCharsInLongestName, NULL, &uniformSize, &uniformType, nextName);
            uniformLocation = glGetUniformLocation(_fragmentProgram.handle, nextName);
            stringName = [NSString stringWithUTF8String:nextName];
            GLKUniform *newUniform = [GLKUniform uniformNamed:stringName GLType:uniformType GLLocation:uniformLocation numElementsInArray:uniformSize];
            [_uniformVariablesByName setObject:newUniform forKey:stringName];
        }
        free(nextName);
    }
    return self;
}

-(void)dealloc
{
    self.vertexProgram = nil;
    self.fragmentProgram = nil;
    self.vertexAttributesByName = nil;
    self.uniformVariablesByName = nil;

    if(self.handle)
    {
        glDeleteProgram(self.handle);
        NSLog(@"[%@] dealloc: Deleted GL program with GL name = %i", [self class], self.handle);
    }
    else
        NSLog(@"[%@] dealloc: NOT deleteing GL program (no GL name)", [self class]);
}

-(GLKAttribute *)attributeNamed:(NSString *)name
{
    return [self.vertexAttributesByName objectForKey:name];
}

-(GLKUniform *)uniformNamed:(NSString *)name
{
    return [self.uniformVariablesByName objectForKey:name];
}

-(NSArray *)allAttributes
{
    return [self.vertexAttributesByName allValues];
}

-(NSArray *)allUniforms
{
    return [self.uniformVariablesByName allValues];
}

@end
