//
//  GLKDrawCall.h
//  OpenGLSandbox
//
//  Created by Michael Davidson on 3/10/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKProgramPipelineObject.h"

@interface GLKDrawCall : NSObject

@property (nonatomic)BOOL shouldClearColorBit;
@property (strong, nonatomic)GLKProgramPipelineObject *ppo;


-(id)init;
-(float *)clearColorArray;
-(void)setClearColorRed:(float) r green:(float) g blue:(float) b alpha:(float) a;

@end
