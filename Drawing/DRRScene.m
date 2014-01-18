//
//  DRRScene.m
//  Drawing
//
//  Created by Diego on 09/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import "DRRScene.h"



@implementation DRRScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
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
//        CGPathRef bpath = CGPathCreateWithEllipseInRect(CGRectMake(- rad, - rad, rad * 2, rad * 2), NULL);
        CGMutablePathRef bpath = CGPathCreateMutable();
        CGPathAddEllipseInRect(bpath, NULL, CGRectMake(-rad, -rad, rad*2, rad*2));
//        CGMutablePathRef scalespath = CGPathCreateMutable();
//        CGPathMoveToPoint(bpath, NULL, -rad * 7/10, -rad);
//        CGPathAddLineToPoint(bpath, NULL, 0, -rad);
        CGPathMoveToPoint(bpath, NULL, -rad/2, 0);
        CGPathAddLineToPoint(bpath, NULL, rad/2, 0);
        CGPathMoveToPoint(bpath, NULL, 0, -rad/2);
        CGPathAddLineToPoint(bpath, NULL, 0, rad/2);
        
        
        ball.path = bpath;
        CGPathRelease(bpath);
        ball.lineWidth = 0.5;
        ball.fillColor = [SKColor llGray];
        ball.strokeColor = [SKColor blackColor];
        
        [self addChild:ball];
        [ball setPosition:ballPos];
        [ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:rad]];
        [ball.physicsBody setFriction:0.4];
        
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




@implementation DRRSceneView

- (id)initWithFrame:(NSRect)frameRect {
    
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self setItemPropertiesToDefault];
        
        [self setWantsLayer:YES];
        
        DRRScene * tempScene = [[DRRScene alloc] initWithSize:self.bounds.size];
        [self presentScene:tempScene];
//        [self setPaused:YES];

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

- (void)setItemPropertiesToDefault {
    self.scale = 1;
    self.pan = NSMakePoint(0, 0);
    [self.scene setPaused:YES];
    [self setHidden:YES];
}



- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint)ballpos ballRadius:(CGFloat)rad { // move:(NSSize)mfactor scale:(CGFloat)sfactor {

//    DRRScene * tempScene;
    DRRScene * nextScene;
//    [self presentScene:tempScene];
    
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
        nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width,
                                                              self.bounds.size.height)
                                         linesPath:linesPaths
                                      ballPosition:CGPointMake(ballpos.x, ballpos.y)
                                        ballRadius:rad];
        nextScene.scaleMode = SKSceneScaleModeAspectFill;
//        [self setSceneFrameSizeAndMoveIt:nextScene newSize:CGSizeMake(self.bounds.size.width / self.scale,
//                                                                      self.bounds.size.height / self.scale)];
//        CGVector diff = CGVectorMake(self.pan.width, self.pan.height);
//        [nextScene runAction:[SKAction moveBy:diff duration:0]];
        
//        [nextScene setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:linesPath]];
    }
    
    // Non ci sono linee nell'array, creo una scena vuota con la palla (se c'è)
    else {

        if (ballpos.x != 0 && ballpos.y != 0) {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width,
                                                                  self.bounds.size.height)
                                             linesPath:NULL
                                          ballPosition:ballpos
                                            ballRadius:rad];
        }
        else {
            nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width,
                                                                  self.bounds.size.height)];
        }
        nextScene.scaleMode = SKSceneScaleModeAspectFill;
        
//        CGVector diff = CGVectorMake(self.pan.width, self.pan.height);
//        [nextScene runAction:[SKAction moveBy:diff duration:0]];
//        self.pan = NSMakeSize(0, 0);
    }
    
//    [self scaleScene:nextScene newSize:CGSizeMake(self.bounds.size.width / self.scale,
//                                                  self.bounds.size.height / self.scale)];
//    [nextScene runAction:[SKAction scaleBy:self.scale duration:0]];
    [self scaleScene:nextScene];
    [self moveScene:nextScene];
    
    
    // Creo la fisica globale
    nextScene.physicsWorld.gravity = CGVectorMake(0.0,-9.8);
//    nextScene.physicsWorld.contactDelegate = self;
    
    
    
    
//    // Cero e posiziono la palla e imposto la sua fisica
//    SKShapeNode * ball =

    [self presentScene:nextScene];
//    [self.scene setSpeed:1];
//    nextScene = NULL; // FIXME
}



- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag {
    
//    NSPoint pview_before = NSMakePoint(CGFloat x, CGFloat y)
    [super setFrameSize:newSize];
    
    [self.scene setSize:self.bounds.size];
//    [self scaleScene:(DRRScene *)self.scene newSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    if (flag) {
        [self scaleScene:(DRRScene *)self.scene];
        [self moveScene:(DRRScene *)self.scene];
    }
//    else
//        [self moveScene:(DRRScene *)self.scene useRelative:NO];
    
}

- (void)scaleUpdate:(CGFloat)step {
    self.scale *= step;
}

- (void)scaleScene:(DRRScene *)scene {

    [scene runAction:[SKAction scaleTo:self.scale duration:0]];
    
}

- (void)moveUpdate:(NSSize)move {
    self.pan = NSMakePoint(self.pan.x + move.width,
                           self.pan.y + move.height);
}

- (void)moveScene:(DRRScene *)scene {

    NSPoint diff = NSMakePoint(self.pan.x * self.scale, self.pan.y * self.scale);
    [scene runAction:[SKAction moveTo:diff duration:0]];
    
}


//- (void)drawRect:(NSRect)dirtyRect {
//    NSLog(@"sceneview draw");
//    [[NSColor clearColor] setFill];
//    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
//}



- (void)mouseDown:(NSEvent *)theEvent {
    
    
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

