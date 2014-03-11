//
//  GLKTexture.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/11/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface GLKTexture : NSObject

+(GLKTexture *)texturePreLoadedByApplesGLKit:(GLKTextureInfo *)appleMetadata;

@property (nonatomic)GLuint name;

-(id)init;
-(id)initWithName:(GLuint)name;

@end
