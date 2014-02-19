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
#import <GLKit/GLKit.h>

@interface ViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic)GLKProgramPipelineObject *ppo;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [view bindDrawable];
    NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
    NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString *oneExtension in extensions)
        NSLog(@"%@", oneExtension);


    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Vertex"
                                                         ofType:@"vsh"];
    GLKSeparateProgram *vertex = [[GLKSeparateProgram alloc]initFromFile:filePath ShaderType:GLKShaderTypeVertex];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"fsh"];
    GLKSeparateProgram *fragment = [[GLKSeparateProgram alloc] initFromFile:filePath ShaderType:GLKShaderTypeFragment];
    self.ppo = [[GLKProgramPipelineObject alloc]initWithVertex:vertex Fragment:fragment];

    // Create vertex buffer containing vertices to draw

    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                                                             data:vertices
                                                                            usage:GL_STATIC_DRAW];

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
