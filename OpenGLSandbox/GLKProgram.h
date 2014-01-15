//
//  GLKProgram.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/9/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLKShader;

typedef enum GLKShaderProgramStatus
{
    GLKShaderProgramStatusUnlinked,
    GLKShaderProgramStatusLinked
} GLKShaderProgramStatus;


@interface GLKProgram : NSObject

@property (nonatomic)GLKShaderProgramStatus status;
@property (nonatomic)GLuint program;
@property (nonatomic, strong)GLKShader *vertexShader;
@property (nonatomic, strong)GLKShader *fragmentShader;

-(id)init;
-(BOOL)loadFromFileVertexShader:(NSString *)vFilename FragmentShader:(NSString *)fFilename;

@end
