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

    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(self.localContext == nil)
    {
        self.localContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    NSAssert(self.localContext != nil, @"Failed to create ES context");

    self.drawCalls = [[NSMutableArray alloc] init];
    GLKDrawCall *simpleClearingCall = [[GLKDrawCall alloc] init];
    simpleClearingCall.shouldClearColorBit = YES;
    [self.drawCalls addObject:simpleClearingCall];

    GLKView *view = (GLKView *)self.view;
    view.context = self.localContext;
    [EAGLContext setCurrentContext:self.localContext];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [view bindDrawable];
    NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
    NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString *oneExtension in extensions)
        NSLog(@"%@", oneExtension);

    GLKDrawCall *draw1Triangle = [[GLKDrawCall alloc] init];
    [self.drawCalls addObject:draw1Triangle];
    [draw1Triangle setClearColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    draw1Triangle.shouldClearColorBit = NO;

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Vertex"
                                                         ofType:@"vsh"];
    GLKSeparateProgram *vertex = [[GLKSeparateProgram alloc]initFromFile:filePath ShaderType:GLKShaderTypeVertex];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"fsh"];
    GLKSeparateProgram *fragment = [[GLKSeparateProgram alloc] initFromFile:filePath ShaderType:GLKShaderTypeFragment];
    draw1Triangle.ppo = [[GLKProgramPipelineObject alloc]initWithVertex:vertex Fragment:fragment];
    glBindProgramPipelineEXT(draw1Triangle.ppo.handle);

    // Create vertex buffer containing vertices to draw

//    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
//                                                                 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
//                                                                             data:vertices
//                                                                            usage:GL_STATIC_DRAW];


    //make some geometry
    GLfloat z = -0.5;
    GLKVector3 cpuBuffer[] =
    {
        GLKVector3Make(-1, -1, z),
        GLKVector3Make(-1, 1, z),
        GLKVector3Make(1, 1, z),
        GLKVector3Make(1, 1, z),
        GLKVector3Make(1, -1, z),
        GLKVector3Make(-1, -1, z)
    };

    GLuint vboName;
    glGenBuffers(1, &vboName);
    glBindBuffer(GL_ARRAY_BUFFER, vboName);
    glBufferData(GL_ARRAY_BUFFER, 6 * sizeof(GLKVector3), cpuBuffer, GL_STATIC_DRAW);

    GLuint vaoName;
    glGenVertexArraysOES(1, &vaoName);
    glBindVertexArrayOES(vaoName);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
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
