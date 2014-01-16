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
        
        [self setPaused:YES];
        
        #ifdef DEBUGSCENE
        self.showsFPS = YES;
        self.showsNodeCount = YES;
        self.showsDrawCount = YES;
        #endif
        
    }
    return self;

}



- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint *)ballpos ballRadius:(CGFloat)rad move:(NSSize)mfactor scale:(CGFloat)sfactor {
    NSLog(@"start 1 build 1");
    DRRScene * nextScene = NULL;
    
    if ([lines count] > 0) {

        // Creo i path delle linee per la scena
        NSMutableArray * linesPaths = [[NSMutableArray alloc] init];
        NSLog(@"start 1 build 2 (si linee) ");
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
        
        NSLog(@"start 1 build 3 (si linee 2)");
        
        // Creo la scena con le linee e il bordo per la simulazione fisica. Gli passo la posizione della palla, così se la crea. SCALO e MUOVO già la scena
        nextScene.scaleMode = SKSceneScaleModeAspectFit;
        nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / self.scale,
                                                              self.bounds.size.height / self.scale)
                                         linesPath:linesPaths
                                      ballPosition:CGPointMake(ballpos->x, ballpos->y)
                                        ballRadius:rad];
        
        CGVector diff = CGVectorMake(self.pan.width, self.pan.height);
        [nextScene runAction:[SKAction moveBy:diff duration:0]];
        
//        [nextScene setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:linesPath]];
    }
    
    // Non ci sono linee nell'array, creo una scena vuota con la palla (se c'è)
    else {
        NSLog(@"start 1 build 4 (no linee)");
        nextScene.scaleMode = SKSceneScaleModeAspectFit;
        if (ballpos != NULL) {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / self.scale,
                                                                  self.bounds.size.height / self.scale)
                                             linesPath:NULL
                                          ballPosition:*ballpos
                                            ballRadius:rad];
        }
        else {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width / self.scale,
                                                                  self.bounds.size.height / self.scale)];
        }
        NSLog(@"start 1 build 5 (dopo init scena)");
        CGVector diff = CGVectorMake(self.pan.width, self.pan.height);
        [nextScene runAction:[SKAction moveBy:diff duration:0]];
    }
    
    NSLog(@"start 1 build 6");
    // Creo la fisica globale
    nextScene.physicsWorld.gravity = CGVectorMake(0.0,-9.8);
//    nextScene.physicsWorld.contactDelegate = self;
    
    
    
    
//    // Cero e posiziono la palla e imposto la sua fisica
//    SKShapeNode * ball =

    
    
    NSLog(@"start 1 build 7 (prima di present)");
    [self presentScene:nextScene];
    NSLog(@"start 1 build 8 (dopo present)");
    nextScene = NULL; // FIXME
    NSLog(@"start 1 build 9 (fine build)");
}



- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    CGSize newTransformedSize = NSSizeToCGSize(newSize);
//    CGSize newTransformedSize = CGSizeMake(newSize.width / self.scale, newSize.height / self.scale);
    [self.scene setSize:newTransformedSize];
}



//- (void)drawRect:(NSRect)dirtyRect {
//    NSLog(@"sceneview draw");
//    [[NSColor clearColor] setFill];
//    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
//}



- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"skview");
    
//    NSPoint pwindow = [theEvent locationInWindow];
//    NSPoint pview = [self convertPoint:pwindow fromView:nil];
//    NSPoint pworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pview]];
//    
//    if (btn == self.btnPan) {
//        if (self.customCursor != PANACTIVE) {
//            [[NSCursor closedHandCursor] set];
//            self.customCursor = PANACTIVE;
//        }
//        
//        if ([self.ball hitTest:pworld])
//            self.ballPressed = YES;
//        
//        self.prevmouseXY = pview;
//    }
//    
//    else if (btn == self.btnZoom) {
//        if (self.customCursor != ZOOM) {
//            [[NSCursor resizeUpDownCursor] set];
//            self.customCursor = ZOOM;
//        }
//        
//        self.prevmouseXY = pview;
//    }

    
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
        NSLog(@"start 1 build x initwhitsize semplice");
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
        NSLog(@"start 1 build x initwhitsize vero 1");
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        if (lpaths != NULL) {
            
            NSMutableArray * shapeNodes = [[NSMutableArray alloc] init];
            [lpaths enumerateObjectsUsingBlock:^(NSValue * pathVal, NSUInteger idx, BOOL *stop) {
                NSLog(@"start 1 build x initwhitsize vero 2 loop");
                [shapeNodes addObject:[[SKShapeNode alloc] init]];
                ((SKShapeNode *) shapeNodes[idx]).path = [pathVal pointerValue];
                ((SKShapeNode *) shapeNodes[idx]).lineWidth = 0.1;
                ((SKShapeNode *) shapeNodes[idx]).strokeColor = [SKColor blackColor];
                ((SKShapeNode *) shapeNodes[idx]).fillColor = [SKColor clearColor]; // FIXME: sarebbe meglio non riempisse proprio
                [((SKShapeNode *) shapeNodes[idx]) setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:((SKShapeNode *) shapeNodes[idx]).path]];
                
                NSLog(@"start 1 build x initwhitsize vero 3 prima figlio");
                [self addChild:((SKShapeNode *) shapeNodes[idx])];
                NSLog(@"start 1 build x initwhitsize vero 4 dopo figlio");
            }];
            
        }
        
        SKShapeNode * ball = [[SKShapeNode alloc] init];
//        CGPathRef bpath = CGPathCreateWithEllipseInRect(CGRectMake(ballPos.x - rad, ballPos.y - rad,
//                                                                   rad * 2, rad * 2),
//                                                        NULL);
        CGPathRef bpath = CGPathCreateWithEllipseInRect(CGRectMake(- rad, - rad,
                                                                   rad * 2, rad * 2),
                                                        NULL);
        NSLog(@"start 1 build x initwhitsize vero 5");
        ball.path = bpath;
        ball.lineWidth = 1.0;
        ball.strokeColor = [SKColor blackColor];
        NSLog(@"start 1 build x initwhitsize vero 6");
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
    NSLog(@"start 1 build x initwhitsize vero 7");
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
//- (void)rightMouseDown:(NSEvent *)theEvent {
//    [self.view rightMouseDown:theEvent];
//}
//- (void)rightMouseUp:(NSEvent *)theEvent {
//    [self.view rightMouseUp:theEvent];
//}

@end
