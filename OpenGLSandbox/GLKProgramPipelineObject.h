//
//  GLKProgramPipelineObject.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/22/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKSeparateProgram.h"

@interface GLKProgramPipelineObject : NSObject

@property (strong, nonatomic)GLKSeparateProgram *vertexProgram;
@property (strong, nonatomic)GLKSeparateProgram *fragmentProgram;
@property (strong, nonatomic)NSMutableDictionary *vertexAttributesByName;

@property (nonatomic)GLuint handle;

-(id)initWithVertex:(GLKSeparateProgram *)vertex Fragment:(GLKSeparateProgram *)fragment;

@end
