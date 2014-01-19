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
        self.prevBallPos = CGPointMake(0, 0);
        self.distEdge = CGSizeMake(self.frame.size.width * 2/5, self.size.height * 2/5);
        self.fixedTimeBetweenFrames = 1/60;
    }
    return self;
}

- (id)initWithSize:(CGSize)size linesPath:(NSMutableArray *)lpaths ballPosition:(CGPoint)ballPos ballRadius:(CGFloat)rad {
   
    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.prevBallPos = CGPointMake(0, 0);
        self.distEdge = CGSizeMake(self.frame.size.width / 3, self.size.height / 3);
        self.fixedTimeBetweenFrames = 1/60;
        
        if (lpaths != NULL) {
            
            NSMutableArray * linesNodes = [[NSMutableArray alloc] init];
            self.world = [[SKNode alloc] init];
            [self addChild:self.world];
            [lpaths enumerateObjectsUsingBlock:^(NSValue * pathVal, NSUInteger idx, BOOL *stop) {
                
                [linesNodes addObject:[[SKShapeNode alloc] init]];
                ((SKShapeNode *) linesNodes[idx]).path = [pathVal pointerValue];
                ((SKShapeNode *) linesNodes[idx]).lineWidth = 0.1;
                ((SKShapeNode *) linesNodes[idx]).strokeColor = [SKColor blackColor];
                ((SKShapeNode *) linesNodes[idx]).fillColor = [SKColor clearColor]; // FIXME: sarebbe meglio non riempisse proprio
                [((SKShapeNode *) linesNodes[idx]) setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:((SKShapeNode *) linesNodes[idx]).path]];
                
                
                [self.world addChild:((SKShapeNode *) linesNodes[idx])];
            }];
            
        }
        
        self.ball = [[SKShapeNode alloc] init];
        CGMutablePathRef bpath = CGPathCreateMutable();
        CGPathAddEllipseInRect(bpath, NULL, CGRectMake(-rad, -rad, rad*2, rad*2));
        CGPathMoveToPoint(bpath, NULL, -rad/2, 0);
        CGPathAddLineToPoint(bpath, NULL, rad/2, 0);
        CGPathMoveToPoint(bpath, NULL, 0, -rad/2);
        CGPathAddLineToPoint(bpath, NULL, 0, rad/2);
        
        
        self.ball.path = bpath;
        CGPathRelease(bpath);
        self.ball.lineWidth = 0.5;
        self.ball.fillColor = [SKColor llGray];
        self.ball.strokeColor = [SKColor blackColor];
        
        [self addChild:self.ball];
        [self.ball setPosition:ballPos];
        self.prevBallPos = self.ball.position;
        [self.ball setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:rad]];
        [self.ball.physicsBody setFriction:0.4];
        
    }

    return self;
}



- (BOOL)movingToAnEdge:(dir_t *)dir objPosition:(CGPoint)pos objVelocity:(CGVector *)vel {
    CGFloat dX = self.distEdge.width; CGFloat dY = self.distEdge.height;
    BOOL ret = NO;
    
    // vel potrebbe essere NULL, per ora mi interessa solo vedere se pos è vicino al bordo e sapere quale
    if (dir != NULL) {
        
        ret = YES;
        
        if (pos.x < dX && pos.y < dY)
            *dir = DOWNLEFT;
        else if (pos.x < dX && self.frame.size.height - pos.y < dY)
            *dir = UPLEFT;
        else if (self.frame.size.width - pos.x < dX && pos.y < dY)
            *dir = DOWNRIGHT;
        else if (self.frame.size.width - pos.x < dX && self.frame.size.height - pos.y < dY)
            *dir = UPRIGHT;
        else if (pos.x < dX)
            *dir = LEFT;
        else if (pos.y < dY)
            *dir = DOWN;
        else if (self.frame.size.width - pos.x < dX)
            *dir = RIGHT;
        else if (self.frame.size.height - pos.y < dY)
            *dir = UP;
        else
            ret = NO;
        
        // vel != NULL, voglio sapere SOLO se mi sto muovendo verso quel bordo, altrimenti ritorno NO
        if (ret && vel != NULL) {
            if (!(((*dir == DOWNLEFT || *dir == LEFT || *dir == UPLEFT) && vel->dx < 0) ||
                  ((*dir == UPLEFT || *dir == UP || *dir == UPRIGHT) && vel->dy > 0) ||
                  ((*dir == UPRIGHT || *dir == RIGHT || *dir == DOWNRIGHT) && vel->dx > 0) ||
                  ((*dir == DOWNRIGHT || *dir == DOWN || *dir == DOWNLEFT) && vel->dy < 0)
                 )
               )
                ret = NO;
        }
        
        return ret;
    }
    
    // dir e vel sono null, mi interessa solo vedere se pos è vicino al bordo
    else if ((pos.x < dX) ||
             (self.frame.size.width - pos.x < dX) ||
             (pos.y < dY) ||
             (self.frame.size.height - pos.y < dY)
            )
        ret = YES;
    
    return ret;
}



- (void)update:(NSTimeInterval)currentTime {
    
    [super update:currentTime];
    
    //    CGVector ballshift = CGVectorMake(self.prevBallPos.x - self.ball.position.x,
    //                                      self.prevBallPos.y - self.ball.position.y);
    //    if (ballshift.dx != 0 || ballshift.dy != 0) {
    //        self.prevBallPos = self.ball.position;
    //        [self runAction:[SKAction moveBy:ballshift duration:0.5]];
    //    }
}

- (void)didEvaluateActions {
    
    [super didEvaluateActions];
    
    DRRSceneView * sceneView = (DRRSceneView *) self.view;
    self.prevBallPos = CGPointMake((self.ball.position.x + sceneView.pan.x) * sceneView.scale,
                                   (self.ball.position.y + sceneView.pan.y) * sceneView.scale);

}

- (void)didSimulatePhysics {
    
    if (self.ball.position.x != 0 || self.ball.position.y != 0) {
        dir_t dir = LEFT;
        CGVector vel = self.ball.physicsBody.velocity;
        DRRSceneView * sceneView = (DRRSceneView *) self.view;
        self.ballPosView = CGPointMake((self.ball.position.x + sceneView.pan.x) * sceneView.scale,
                                       (self.ball.position.y + sceneView.pan.y) * sceneView.scale);
        
        [super didSimulatePhysics];

        if ([self movingToAnEdge:&dir objPosition:self.ballPosView objVelocity:&vel]) {
//            NSLog(@"SI!!");
            //        self.ball.physicsBody.velocity;
            //        CGVector ballshift = CGVectorMake(self.prevBallPos.x - self.ball.position.x,
            //                                          self.prevBallPos.y - self.ball.position.y);
//            CGVector ballshift = CGVectorMake(vel.dx / - 60,
//                                              vel.dy / - 60);
//            if (ballshift.dx != 0 || ballshift.dy != 0) {
                //            self.prevBallPos = self.ball.position;
            [self runAction:[SKAction moveBy:CGVectorMake(self.prevBallPos.x - self.ballPosView.x,
                                                          self.prevBallPos.y - self.ballPosView.y)
                                    duration:0.3]];
            
//            self.prevBallPos = self.ballPosView;
                //            self.position = CGPointMake(self.position.x + ballshift.dx, self.position.y + ballshift.dy);
//            }
        }
    }
    
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

