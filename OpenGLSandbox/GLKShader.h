//
//  GLKShader.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/8/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GLKShaderType
{
    GLKShaderTypeVertex,
    GLKShaderTypeFragment
} GLKShaderType;

typedef enum GLKShaderStatus
{
    GLKShaderStatusUncompiled,
    GLKShaderStatusCompiled,
    GLKShaderStatusLinked
} GLKShaderStatus;

@interface GLKShader : NSObject

@property (nonatomic)GLKShaderType type;
@property (nonatomic)GLKShaderStatus status;
@property (nonatomic)GLuint handle;

-(BOOL)compile;
-(id)initFromFile:(NSString *)fname Type:(GLKShaderType)type;

@end
