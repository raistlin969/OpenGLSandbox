//
//  GLKUniform.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/11/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLKUniform : NSObject <NSCopying>

+(GLKUniform *)uniformNamed:(NSString *)nameOfUniform GLType:(GLenum)openGLType GLLocation:(GLint)openGLLocation numElementsInArray:(GLint)numElements;

@property (strong, nonatomic)NSString *nameInShader;
@property (nonatomic)GLint location;
@property (nonatomic)GLenum type;
@property (nonatomic)GLint arrayLength;
@property (nonatomic)BOOL isInteger;
@property (nonatomic)BOOL isFloat;
@property (nonatomic)BOOL isVector;
@property (nonatomic)BOOL isMatrix;

-(int)matrixWidth;
-(int)vectorWidth;

@end
