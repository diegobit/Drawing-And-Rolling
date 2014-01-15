//
//  DRRScene.m
//  Drawing
//
//  Created by Diego on 09/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import "DRRScene.h"



@implementation DRRSceneView

- (id)initWithFrame:(NSRect)frameRect {
    NSLog(@"4");
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self setWantsLayer:YES];

//        DRRScene * nextScene = [DRRScene sceneWithSize:CGSizeMake(frameRect.size.width, frameRect.size.height)];
//        nextScene.scaleMode = SKSceneScaleModeFill;
//        [self presentScene:nextScene];
//        nextScene = NULL; // FIXME
        
//        self.scene run
        
//        [self setPaused:YES];
        
        #ifdef DEBUGSCENE
        self.showsFPS = YES;
        self.showsNodeCount = YES;
        self.showsDrawCount = YES;
        #endif
        
    }
    return self;

}



- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint *)ballpos ballRadius:(CGFloat)rad move:(NSSize)mfactor scale:(CGFloat)sfactor {
    NSLog(@"5");
    DRRScene * nextScene = NULL;
    
    if ([lines count] > 0) {

        // Creo i path delle linee per la scena
        NSMutableArray * linesPaths = [[NSMutableArray alloc] init];
        
        [lines enumerateObjectsUsingBlock:^(NSMutableArray * line, NSUInteger idx, BOOL *stop) {
            CGMutablePathRef linesMutPath = CGPathCreateMutable();
            
            [line enumerateObjectsUsingBlock:^(NSValue * vpoint, NSUInteger idx, BOOL *stop) {
                NSPoint p = [vpoint pointValue];
                
                if (idx == 0)
                    CGPathMoveToPoint(linesMutPath, NULL, p.x, p.y);
                else
                    CGPathAddLineToPoint(linesMutPath, NULL, p.x, p.y);
            }];
            
            [linesPaths addObject:[NSValue valueWithPointer:CGPathCreateCopy(linesMutPath)]];
            CGPathRelease(linesMutPath);
        }];
        
        
        
        // Creo la scena con le linee e il bordo per la simulazione fisica. Gli passo la posizione della palla, così se la crea. SCALO e MUOVO già la scena
        nextScene.scaleMode = SKSceneScaleModeAspectFit;
        nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / sfactor,
                                                              self.bounds.size.height / sfactor)
                                         linesPath:linesPaths
                                      ballPosition:CGPointMake(ballpos->x, ballpos->y)
                                        ballRadius:rad];
        
        CGVector diff = CGVectorMake(mfactor.width, mfactor.height);
        [nextScene runAction:[SKAction moveBy:diff duration:0]];
        
//        [nextScene setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:linesPath]];
    }
    
    // Non ci sono linee nell'array, creo una scena vuota con la palla (se c'è)
    else {
        nextScene.scaleMode = SKSceneScaleModeAspectFit;
        if (ballpos != NULL) {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / sfactor,
                                                                  self.bounds.size.height / sfactor)
                                             linesPath:NULL
                                          ballPosition:*ballpos
                                            ballRadius:rad];
        }
        else {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / sfactor,
                                                                  self.bounds.size.height / sfactor)];
        }
        
        CGVector diff = CGVectorMake(mfactor.width, mfactor.height);
        [nextScene runAction:[SKAction moveBy:diff duration:0]];
    }
    
    NSLog(@"7");
    // Creo la fisica globale
    nextScene.physicsWorld.gravity = CGVectorMake(0.0,-9.8);
//    nextScene.physicsWorld.contactDelegate = self;
    
    
    
    
//    // Cero e posiziono la palla e imposto la sua fisica
//    SKShapeNode * ball =

    
    
    
    [self presentScene:nextScene];
    nextScene = NULL; // FIXME
    NSLog(@"8");
}



- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self.scene setSize:NSSizeToCGSize(newSize)];
}



//- (void)drawRect:(NSRect)dirtyRect {
//    NSLog(@"sceneview draw");
//    [[NSColor clearColor] setFill];
//    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
//}



- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"skview");
    [self.superview mouseDown:theEvent];
}
- (void)mouseDragged:(NSEvent *)theEvent {
    [self.superview mouseDragged:theEvent];
}
- (void)mouseUp:(NSEvent *)theEvent {
    [self.superview mouseUp:theEvent];
}
//- (void)rightMouseDown:(NSEvent *)theEvent {
//    [self.superview rightMouseDown:theEvent];
//}
//- (void)rightMouseUp:(NSEvent *)theEvent {
//    [self.superview rightMouseUp:theEvent];
//}

@end



@implementation DRRScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        
//        SKShapeNode * ball = [[SKShapeNode alloc] init];
//        CGMutablePathRef myPath = CGPathCreateMutable();
//        CGPathAddArc(myPath, NULL, 100,100, 15, 0, M_PI*2, YES);
//        ball.path = myPath;
//        ball.lineWidth = 1.0;
//        ball.fillColor = [SKColor blueColor];
//        ball.strokeColor = [SKColor redColor];
////        ball.glowWidth = 0.5;
//        
//        [self addChild:ball];
    }
    return self;
}

- (id)initWithSize:(CGSize)size linesPath:(NSMutableArray *)lpaths ballPosition:(CGPoint)ballPos ballRadius:(CGFloat)rad {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        if (lpaths != NULL) {
            
            NSMutableArray * shapeNodes = [[NSMutableArray alloc] init];
            [lpaths enumerateObjectsUsingBlock:^(NSValue * pathVal, NSUInteger idx, BOOL *stop) {
                [shapeNodes addObject:[[SKShapeNode alloc] init]];
                ((SKShapeNode *) shapeNodes[idx]).path = [pathVal pointerValue];
                ((SKShapeNode *) shapeNodes[idx]).lineWidth = 0.1;
                ((SKShapeNode *) shapeNodes[idx]).strokeColor = [SKColor blackColor];
                ((SKShapeNode *) shapeNodes[idx]).fillColor = [SKColor clearColor]; // FIXME: sarebbe meglio non riempisse proprio
                [((SKShapeNode *) shapeNodes[idx]) setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:((SKShapeNode *) shapeNodes[idx]).path]];
                
                
                [self addChild:((SKShapeNode *) shapeNodes[idx])];

            }];
            
        }
        
        SKShapeNode * ball = [[SKShapeNode alloc] init];
//        CGPathRef bpath = CGPathCreateWithEllipseInRect(CGRectMake(ballPos.x - rad, ballPos.y - rad,
//                                                                   rad * 2, rad * 2),
//                                                        NULL);
        CGPathRef bpath = CGPathCreateWithEllipseInRect(CGRectMake(- rad, - rad,
                                                                   rad * 2, rad * 2),
                                                        NULL);
        ball.path = bpath;
        ball.lineWidth = 1.0;
        ball.strokeColor = [SKColor blackColor];
        
        [self addChild:ball];
        [ball setPosition:ballPos];
        [ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:rad]];
        
        
        
        
        
//        SKShapeNode * ball = [[SKShapeNode alloc] init];
//        CGMutablePathRef myPath = CGPathCreateMutable();
////        CGAffineTransform m = CGAffineTransformIdentity;
////        m = CGAffineTransformScale(m, 3, 3);
//        CGPathAddArc(myPath, NULL, 100,100, 15, 0, M_PI*2, YES);
//        ball.path = myPath;
//        ball.lineWidth = 1.0;
//        ball.fillColor = [SKColor blueColor];
//        ball.strokeColor = [SKColor redColor];
//        ball.glowWidth = 0.5;
//        
//        [self addChild:ball];
//        
//        SKShapeNode *yourline = [SKShapeNode node];
//        CGMutablePathRef pathToDraw = CGPathCreateMutable();
//        CGPathMoveToPoint(pathToDraw, NULL, 100.0, 100.0);
//        CGPathAddLineToPoint(pathToDraw, NULL, 50.0, 50.0);
//        CGPathAddLineToPoint(pathToDraw, NULL, 40.0, 50.0);
//        CGPathMoveToPoint(pathToDraw, NULL, 40.0, 60.0);
//        CGPathAddLineToPoint(pathToDraw, NULL, 40.0, 70.0);
//
//        yourline.path = pathToDraw;
//        [yourline setStrokeColor:[NSColor redColor]];
//        [self addChild:yourline];
        
        
        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        [self addChild:myLabel];
    }
    return self;
}

//- (id)initWithSize:(CGSize)size linesPathFromNSBezierPath:(NSBezierPath *)path {
//    CGMutablePathRef newPath = CGPathCreateMutable();
//        // TODO conversione path
//    
//    
//    self = [self initWithSize:size linesPath:newPath];
//    return self;
//}





//- (void)drawRect:(NSRect)dirtyRect {
//    [[NSColor clearColor] setFill];
//    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
//}



- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"scene");
    [self.view mouseDown:theEvent];
}
- (void)mouseDragged:(NSEvent *)theEvent {
    [self.view mouseDragged:theEvent];
}
- (void)mouseUp:(NSEvent *)theEvent {
    [self.view mouseUp:theEvent];
}
- (void)rightMouseDown:(NSEvent *)theEvent {
    [self.view rightMouseDown:theEvent];
}
- (void)rightMouseUp:(NSEvent *)theEvent {
    [self.view rightMouseUp:theEvent];
}

@end
