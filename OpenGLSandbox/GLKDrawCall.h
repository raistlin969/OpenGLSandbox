//
//  GLKDrawCall.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKProgramPipelineObject.h"
#import "GLKVertexArrayObject.h"

@class GLKTexture;
@class GLKUniform;

@interface GLKDrawCall : NSObject

@property (nonatomic)BOOL shouldClearColorBit;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)GLKProgramPipelineObject *ppo;
@property (strong, nonatomic)GLKVertexArrayObject *VAO;
@property (nonatomic)BOOL requiresDepthTest;
@property (nonatomic)GLuint glDrawCallType;
@property (nonatomic)GLuint numVerticesToDraw;
@property (strong, nonatomic)NSMutableDictionary *texturesFromSamplers;

-(id)init;
-(id)initWithTitle:(NSString *)title;
-(float *)clearColorArray;
-(void)setClearColorRed:(float) r green:(float) g blue:(float) b alpha:(float) a;
-(GLuint)setTexture:(GLKTexture *)texture forSampler:(GLKUniform *)sampler;
-(GLuint)setTexture:(GLKTexture *)texture forSamplerNamed:(NSString *)samplerName;
-(GLint)textureUnitOffsetForSampler:(GLKUniform *)sampler;

@end
