//
//  GLKDrawCall.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "GLKDrawCall.h"

@implementation GLKDrawCall
{
    float clearColor[4];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setClearColorRed:1.0f green:0.0f blue:1.0f alpha:1.0f];
    }
    return self;
}

-(float *)clearColorArray
{
    return &clearColor[0];
}

-(void)setClearColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
    clearColor[0] = r;
    clearColor[1] = g;
    clearColor[2] = b;
    clearColor[3] = a;
}

@end
