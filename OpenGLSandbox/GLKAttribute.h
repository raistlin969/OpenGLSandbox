//
//  GLKAttribute.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLKAttribute : NSObject

@property(strong, nonatomic)NSString *nameInShader;
@property(nonatomic)GLint location;
@property(nonatomic)GLenum type;
@property(nonatomic)GLint size;

+(GLKAttribute *)attributeNamed:(NSString *)nameOfAttribute GLType:(GLenum)openGLType GLLocation:(GLint)openGLLocation GLSize:(GLint)openGLSize;

@end
