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

@interface GLKDrawCall : NSObject

@property (nonatomic)BOOL shouldClearColorBit;
@property (strong, nonatomic)GLKProgramPipelineObject *ppo;
@property (strong, nonatomic)GLKVertexArrayObject *VAO;
@property (nonatomic)BOOL requiresDepthTest;
@property (nonatomic)GLuint glDrawCallType;
@property (nonatomic)GLuint numVerticesToDraw;

-(id)init;
-(float *)clearColorArray;
-(void)setClearColorRed:(float) r green:(float) g blue:(float) b alpha:(float) a;

@end
