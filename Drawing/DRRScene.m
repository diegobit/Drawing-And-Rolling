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
        CGMutablePathRef bpath = CGPathCreateMutable();
        CGPathAddEllipseInRect(bpath, NULL, CGRectMake(-rad, -rad, rad*2, rad*2));
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



- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint)ballpos ballRadius:(CGFloat)rad {

    DRRScene * nextScene;
    
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
        
    }
    
    [self scaleScene:nextScene];
    [self moveScene:nextScene];
    
    
    // Creo la fisica globale
    nextScene.physicsWorld.gravity = CGVectorMake(0.0,-9.8);

    [self presentScene:nextScene];
//    nextScene = NULL; // FIXME
    
}



- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag {
    
    [super setFrameSize:newSize];
    
    [self.scene setSize:self.bounds.size];
    if (flag) {
        [self scaleScene:(DRRScene *)self.scene];
        [self moveScene:(DRRScene *)self.scene];
    }
    
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



- (void)mouseDown:(NSEvent *)theEvent {
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

