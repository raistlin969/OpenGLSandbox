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
#import "GLKTexture.h"
#import "GLKUniform.h"
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
    
    for(GLKUniform *sampler in drawCall.texturesFromSamplers)
    {
        GLKTexture *texture = [drawCall.texturesFromSamplers objectForKey:sampler];
        glActiveTexture(GL_TEXTURE0 + [drawCall textureUnitOffsetForSampler:sampler]);
        glBindTexture(GL_TEXTURE_2D, texture.name);
    }

    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(NSMutableArray *)createAllDrawCalls
{
    NSMutableArray *result = [NSMutableArray array];
    GLKDrawCall *simpleClearingCall = [[GLKDrawCall alloc] init];
    simpleClearingCall.shouldClearColorBit = YES;
    [result addObject:simpleClearingCall];

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"VertexPositionUnprojected"
                                                         ofType:@"vsh"];
    GLKSeparateProgram *vertex = [[GLKSeparateProgram alloc]initFromFile:filePath ShaderType:GLKShaderTypeVertex];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"FragmentXYParameterized" ofType:@"fsh"];
    GLKSeparateProgram *fragment = [[GLKSeparateProgram alloc] initFromFile:filePath ShaderType:GLKShaderTypeFragment];
    GLKProgramPipelineObject *ppo = [[GLKProgramPipelineObject alloc]initWithVertex:vertex Fragment:fragment];

    GLKDrawCall *drawQuad = [[GLKDrawCall alloc] init];
    drawQuad.numVerticesToDraw = 6;
    drawQuad.ppo = ppo;
    glBindProgramPipelineEXT(drawQuad.ppo.handle);
    GLfloat z = -0.5;
    GLKVector3 cpuBufferQuad[6] =
    {
        GLKVector3Make(-0.5, -0.5, z),
        GLKVector3Make(-0.5, 0.5, z),
        GLKVector3Make(0.5, 0.5, z),
        GLKVector3Make(-0.5, -0.5, z),
        GLKVector3Make(0.5, 0.5, z),
        GLKVector3Make(0.5, -0.5, z)
    };
    
    GLKVector2 attributesVirtualXY [6] =
    {
        GLKVector2Make(0, 1),
        GLKVector2Make(0, 0),
        GLKVector2Make(1, 0),
        GLKVector2Make(0, 1),
        GLKVector2Make(1, 0),
        GLKVector2Make(1, 1)
    };
    
    drawQuad.VAO = [[GLKVertexArrayObject alloc]init];
    GLKAttribute *position = [drawQuad.ppo attributeNamed:@"position"];
    [drawQuad.VAO addVBOForAttribute:position filledWithData:cpuBufferQuad bytesPerArrayElement:sizeof(GLKVector3) arrayLength:drawQuad.numVerticesToDraw];
    GLKAttribute *attXY = [drawQuad.ppo attributeNamed:@"a_virtualXY"];
    [drawQuad.VAO addVBOForAttribute:attXY filledWithData:attributesVirtualXY bytesPerArrayElement:sizeof(GLKVector2) arrayLength:drawQuad.numVerticesToDraw];
    
    NSError *error;
    GLKTextureInfo *appleTex = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tex2" ofType:@"png"] options:nil error:&error];
    
    NSAssert(appleTex != nil, @"Error loading texture: %@", error);
    GLKTexture *texture = [GLKTexture texturePreLoadedByApplesGLKit:appleTex];
    
    GLKUniform *uniformTex = [drawQuad.ppo uniformNamed:@"s_texture"];
    [drawQuad setTexture:texture forSampler:uniformTex];
    
    [result addObject:drawQuad];
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
