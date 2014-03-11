//
//  GLKDrawCall.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKDrawCall.h"
#import "GLKUniform.h"

@interface GLKDrawCall()
@property(nonatomic,strong) NSMutableArray* textureUnitSlots;
@end

@implementation GLKDrawCall
{
    float clearColor[4];
}

-(void)dealloc
{
    self.texturesFromSamplers = nil;
    self.textureUnitSlots = nil;
    self.ppo = nil;
    self.VAO = nil;

    NSLog(@"Drawcall deallocated: %@", [self class]);
}

-(id)initWithTitle:(NSString *)title
{
    self = [super init];
    if(self)
    {
        self.title = title;
        [self setClearColorRed:1.0f green:0.0f blue:1.0f alpha:1.0f];
        self.texturesFromSamplers = [NSMutableDictionary dictionary];
        GLint sizeOfTextureUnitSlotsArray;
        glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, &sizeOfTextureUnitSlotsArray);
        self.textureUnitSlots = [NSMutableArray arrayWithCapacity:sizeOfTextureUnitSlotsArray];
        for(int i = 0; i < sizeOfTextureUnitSlotsArray; i++)
        {
            [self.textureUnitSlots addObject:[NSNull null]];
        }
    }
    return self;
}

-(id)init
{
    return [self initWithTitle:[NSString stringWithFormat:@"Drawcall-%i", arc4random_uniform(INT_MAX)]];
}

-(GLuint)setTexture:(GLKTexture *)texture forSampler:(GLKUniform *)sampler
{
    NSAssert(sampler != nil, @"Cant set a texture for non existent sampler = nil");

    if(texture != nil)
    {
        int indexOfStoredSampler = -1;
        int i = -1;
        for(GLKUniform *samplerInUnitSlot in self.textureUnitSlots)
        {
            i++;
            if((id)samplerInUnitSlot != [NSNull null] && [samplerInUnitSlot isEqual:sampler])
            {
                indexOfStoredSampler = i;
                break;
            }
        }

        [self.texturesFromSamplers setObject:texture forKey:sampler];

        if(indexOfStoredSampler < 0)
        {
            i = -1;
            for(GLKUniform *samplerInUnitSlot in self.textureUnitSlots)
            {
                i++;
                if((id)samplerInUnitSlot == [NSNull null])
                {
                    [self.textureUnitSlots replaceObjectAtIndex:i withObject:sampler];
                    indexOfStoredSampler = i;

                    GLint currentPPO;
                    glGetIntegerv(GL_PROGRAM_PIPELINE_BINDING_EXT, &currentPPO);

                    NSAssert(self.ppo != nil, @"Cant set textures on a drawcall until it has a ppo");
                    GLint textureUnitOffsetOpenGLMakesThisHard = [self textureUnitOffsetForSampler:sampler];
                    glBindProgramPipelineEXT(self.ppo.handle);
                    glUniform1i(sampler.location, textureUnitOffsetOpenGLMakesThisHard);
                    glBindProgramPipelineEXT(currentPPO);
                    break;
                }
            }
            NSAssert(indexOfStoredSampler >= 0, @"Ran out of texture units");
        }
        return indexOfStoredSampler;
    }
    else
    {
        [self.texturesFromSamplers removeObjectForKey:sampler];
        int i = -1;
        for(GLKUniform *samplerInUnitSlot in self.textureUnitSlots)
        {
            i++;
            if((id)samplerInUnitSlot != [NSNull null] && [samplerInUnitSlot isEqual:sampler])
            {
                [self.textureUnitSlots replaceObjectAtIndex:i withObject:[NSNull null]];
                break;
            }
        }
        return -1;
    }
}

-(GLuint)setTexture:(GLKTexture *)texture forSamplerNamed:(NSString *)samplerName
{
    NSAssert(self.ppo != nil, @"Cant set textures on draw call until it has a ppo");

    GLKUniform *sampler = [self.ppo uniformNamed:samplerName];
    NSAssert(sampler != nil, @"Unknown sampler named %@", samplerName);

    return [self setTexture:texture forSampler:sampler];
}

-(GLint)textureUnitOffsetForSampler:(GLKUniform *)sampler
{
    int i = -1;
    for(GLKUniform *samplerInUnitSlot in self.textureUnitSlots)
    {
        i++;
        if((id)samplerInUnitSlot != [NSNull null] && [samplerInUnitSlot isEqual:sampler])
        {
            return i;
        }
    }
    return -1;
}

-(float *)clearColorArray
{
    return &clearColor[0];
}

-(void)setClearColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
    clearColor[0] = r;
    clearColor[1] = g;
    clearColor[2] = b;
    clearColor[3] = a;
}

@end
