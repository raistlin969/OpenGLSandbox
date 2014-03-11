//
//  ViewController.m
//  OpenGLSandbox
//
//  Created by Michael Davidson on 1/8/14.
//  Copyright (c) 2014 Michael Davidson. All rights reserved.
//

#import "ViewController.h"
#import "GLKSeparateProgram.h"
#import "GLKProgramPipelineObject.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "GLKAttribute.h"
#import "GLKDrawCall.h"
#import <GLKit/GLKit.h>

@interface ViewController ()

@property (strong, nonatomic)NSMutableArray *drawCalls;

@end

@implementation ViewController

typedef struct
{
    GLKVector3  positionCoords;
} SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

-(void)renderSingleFrame
{
    if([EAGLContext currentContext] == nil)
    {
        NSLog(@"We have no gl context; skipping all frame rendering");
        return;
    }

    if(self.drawCalls == nil || self.drawCalls.count < 1)
    {
        NSLog(@"no draw calls specified; rendering nothing");
    }

    for(GLKDrawCall *drawCall in self.drawCalls)
    {
        [self renderSingleDrawCall:drawCall];
    }
}

-(void)renderSingleDrawCall:(GLKDrawCall *)drawCall
{
    //clear color depth or both
    float* newClearColor = [drawCall clearColorArray];
    glClearColor(newClearColor[0], newClearColor[1], newClearColor[2], newClearColor[3]);
    glClear((drawCall.shouldClearColorBit ? GL_COLOR_BUFFER_BIT : 0));

    if(drawCall.ppo != nil)
        glBindProgramPipelineEXT(drawCall.ppo.handle);
    else
        glBindProgramPipelineEXT(0);
    
    if(drawCall.VAO != nil)
        glBindVertexArrayOES(drawCall.VAO.name);

    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(NSMutableArray *)createAllDrawCalls
{
    NSMutableArray *result = [NSMutableArray array];
    GLKDrawCall *simpleClearingCall = [[GLKDrawCall alloc] init];
    simpleClearingCall.shouldClearColorBit = YES;
    [result addObject:simpleClearingCall];

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Vertex"
                                                         ofType:@"vsh"];
    GLKSeparateProgram *vertex = [[GLKSeparateProgram alloc]initFromFile:filePath ShaderType:GLKShaderTypeVertex];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"fsh"];
    GLKSeparateProgram *fragment = [[GLKSeparateProgram alloc] initFromFile:filePath ShaderType:GLKShaderTypeFragment];
    GLKProgramPipelineObject *ppo = [[GLKProgramPipelineObject alloc]initWithVertex:vertex Fragment:fragment];

    for(int i = 0; i < 4; i++)
    {
        GLKDrawCall *triangle = [[GLKDrawCall alloc] init];
        triangle.ppo = ppo;
        glBindProgramPipelineEXT(triangle.ppo.handle);
        GLKAttribute *attribute = [triangle.ppo attributeNamed:@"position"];
        
        GLfloat z = -0.5;
        triangle.numVerticesToDraw = 3;
        GLKVector3 cpuBuffer[3] =
        {
            GLKVector3Make(-1 + i%2, -1 + i/2, z),
            GLKVector3Make(-0.5 + i%2, 0 + i/2, z),
            GLKVector3Make(0 + i%2, -1 + i/2, z)
        };
        triangle.VAO = [[GLKVertexArrayObject alloc] init];
        [triangle.VAO addVBOForAttribute:attribute filledWithData:cpuBuffer bytesPerArrayElement:sizeof(GLKVector3) arrayLength:triangle.numVerticesToDraw];
        
        [result addObject:triangle];
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredFramesPerSecond = 60;
	// Do any additional setup after loading the view, typically from a nib.
    if(self.localContext == nil)
    {
        self.localContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    NSAssert(self.localContext != nil, @"Failed to create ES context");

    
    GLKView *view = (GLKView *)self.view;
    view.context = self.localContext;
    [EAGLContext setCurrentContext:self.localContext];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [view bindDrawable];
    NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
    NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString *oneExtension in extensions)
        NSLog(@"%@", oneExtension);

    self.drawCalls = [self createAllDrawCalls];
}

//-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
//{
//    glClearColor(1.0, 1.0, 1.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
//}

-(void)update
{
    [self renderSingleFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
