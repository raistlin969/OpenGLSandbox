//
//  GLKSeparateProgram.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/15/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GLKShaderType
{
    GLKShaderTypeVertex,
    GLKShaderTypeFragment
} GLKShaderType;

@interface GLKSeparateProgram : NSObject

@property (nonatomic)GLuint handle;
@property (nonatomic)GLKShaderType type;

-(id)initFromFile:(NSString *)filePath ShaderType:(GLKShaderType)type;

@end
