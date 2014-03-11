//
//  GLKBufferFormat.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKBufferFormat.h"

@interface GLKBufferFormat()

@property (nonatomic, strong)NSArray *numFloatsPerItem;
@property (strong, nonatomic)NSArray *bytesPerItem;

@end

@implementation GLKBufferFormat

+(GLKBufferFormat *)bufferFormatWithSingleTypeOfFloats:(GLuint)numFloats bytesPerItem:(GLsizeiptr)bytesPerItem
{
    GLKBufferFormat *format = [[GLKBufferFormat alloc] init];
    format.numberOfSubTypes = 1;
    format.numFloatsPerItem = @[@(numFloats)];
    format.bytesPerItem = @[@(bytesPerItem)];
    return format;
}

+(GLKBufferFormat *)bufferFormatWithFloatsPerItem:(NSArray *)floatsArray bytesPerItem:(NSArray *)bytesArray
{
    GLKBufferFormat *format = [[GLKBufferFormat alloc] init];
    format.numberOfSubTypes = 1;
    format.numFloatsPerItem = floatsArray;
    format.bytesPerItem = bytesArray;
    return format;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.numFloatsPerItem = [NSMutableArray array];
        self.bytesPerItem = [NSMutableArray array];
    }
    return self;
}

-(GLuint)sizePerItemInFloatsForSubTypeIndex:(int)index
{
    return [((NSNumber *)[self.numFloatsPerItem objectAtIndex:index]) unsignedIntValue];
}

-(GLsizeiptr)bytesPerItemForSubTypeIndex:(int)index
{
    return [((NSNumber *)[self.bytesPerItem objectAtIndex:index]) longValue];
}

@end
