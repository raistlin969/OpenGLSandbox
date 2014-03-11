//
//  GLKBufferFormat.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLKBufferFormat : NSObject

@property (nonatomic)int numberOfSubTypes;

+(GLKBufferFormat *)bufferFormatWithSingleTypeOfFloats:(GLuint) numFloats bytesPerItem:(GLsizeiptr) bytesPerItem;
-(GLuint)sizePerItemInFloatsForSubTypeIndex:(int)index;
-(GLsizeiptr)bytesPerItemForSubTypeIndex:(int)index;

@end
