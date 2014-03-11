//
//  GLKTexture.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/11/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKTexture.h"
#import "GLKTextureLoaderPVRv1.h"

@implementation GLKTexture

+(GLKTexture *)texturePreLoadedByApplesGLKit:(GLKTextureInfo *)appleMetadata
{
    GLKTexture *tex = [[GLKTexture alloc] initWithName:appleMetadata.name];
    return tex;
}

-(id)init
{
    GLuint name;
    glGenTextures(1, &name);
    return [self initWithName:name];
}

-(id)initWithName:(GLuint)name
{
    self = [super init];
    if(self)
    {
        self.name = name;
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"Dealloc: %@, glDeleteTextures(1, %i)", [self class], self.name);
    glDeleteTextures(1, &_name);
}

@end
