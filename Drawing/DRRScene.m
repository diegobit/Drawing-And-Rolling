//
//  DRRScene.m
//  Drawing
//
//  Created by Diego on 09/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import "DRRScene.h"

static const uint32_t ballCategory      =  0x1 << 0;
static const uint32_t lineCategory      =  0x1 << 1;
static const uint32_t emptyCategory      =  0x1 << 1;



@implementation DRRObjectNode

+ (DRRObjectNode *)initWithNode:(SKShapeNode *)node andWithoutPhysics:(SKShapeNode *)nodeWithNoPhys {
    DRRObjectNode * obj = [[DRRObjectNode alloc] init];
    if (obj) {
        obj.nodeWithPhysics = node;
        obj.nodeWithNoPhysics = nodeWithNoPhys;
    }
    return obj;
}

- (id)init {
    self = [super init];
    return self;
}

@end



@implementation DRRPresenceNode

+ (DRRPresenceNode *)initWithState:(BOOL)flag coordinates:(NSMutableArray *)coord{
    DRRPresenceNode * obj = [[DRRPresenceNode alloc] init];
    if (obj) {
        obj.active = flag;
        obj.coordinates = coord;
    }
    return obj;
}



- (id)init {
    self = [super init];
    return self;
}
     
@end



@implementation DRRLinesContainer

- (id)init {
    if (self = [super init]) {
        self.blockSize = 200;
        self.linesRightUp = [[NSMutableArray alloc] init];
        self.linesRightDown = [[NSMutableArray alloc] init];
        self.linesLeftUp = [[NSMutableArray alloc] init];
        self.linesLeftDown = [[NSMutableArray alloc] init];
        self.presenceArray = [[NSMutableArray alloc] init];
        self.nextFreeKey = 0;
    }
    return self;
}



- (void)addNode:(SKShapeNode *)node andWithPhysics:(SKShapeNode *)nodeWithPhysics {
//    NSString * key = [NSString stringWithFormat:@"%ld", [self.presenceArray count]];
    NSString * key = [NSString stringWithFormat:@"%ld", self.nextFreeKey];
    self.nextFreeKey++;
    node.name = key;
    
    // Calcolo il rettangolo che contiene il path del nodo e da quello i blocchi che lo contengono
    CGRect rect = CGPathGetBoundingBox(node.path);
    NSMutableArray * blocksCoord = [self blocksCoordFromRect:rect];
    // aggiungo al presenceArray un elemento (chiave: indice array) con stato corrente e con tutte le coordinate a cui lo posso trovare
    [self.presenceArray addObject:[DRRPresenceNode initWithState:NO coordinates:blocksCoord]];
    
    // scorro i blocchi relativi al nodo corrente, aggiungo il nodo al blocco.
    [blocksCoord enumerateObjectsUsingBlock:^(NSValue * pointV, NSUInteger idx, BOOL *stop) {
        NSPoint point = [pointV pointValue];
        NSMapTable * block = [self blockOfCoordinate:point];
        DRRObjectNode * objNode = [[DRRObjectNode alloc] init];
        objNode.nodeWithPhysics = nodeWithPhysics;
        objNode.nodeWithNoPhysics = node;
        
        [block setObject:objNode forKey:key];
    }];
}

- (SKShapeNode *)nodeByKey:(NSInteger)key wantsPhysics:(BOOL)flag {
    DRRPresenceNode * pNode = self.presenceArray[key];
    NSPoint point = [pNode.coordinates[0] pointValue];
    NSMapTable * block = [self blockOfCoordinate:point];
    DRRObjectNode * node = [block objectForKey:[NSString stringWithFormat:@"%ld", key]];
    
    if (flag)
        return node.nodeWithPhysics;
    else
        return node.nodeWithNoPhysics;
}

- (NSMutableArray *)nodesByKeys:(NSMutableSet *)keys wantsPhysics:(BOOL)flag {
    NSMutableArray * nodes = [[NSMutableArray alloc] init];
    
    [keys enumerateObjectsUsingBlock:^(NSString * keyString, BOOL *stop) {
        NSInteger key = [keyString integerValue];
        DRRPresenceNode * pNode = self.presenceArray[key];
        NSPoint point = [pNode.coordinates[0] pointValue];
        NSMapTable * block = [self blockOfCoordinate:point];
        DRRObjectNode * node = [block objectForKey:keyString];
        
        if (flag)
            [nodes addObject:node.nodeWithPhysics];
        else
            [nodes addObject:node.nodeWithNoPhysics];
    }];
    
    return nodes;
}

- (NSMutableSet *)keysInBlocksThatContainsRect:(CGRect)rect {
    NSMutableSet * keys = [[NSMutableSet alloc] init];
    
    // Aggiungo tutte le chiavi di tutti i blocchi che appaiono nel rettagolo dato. No duplicati
    NSMutableArray * blocksCoord = [self blocksCoordFromRect:rect];
    [blocksCoord enumerateObjectsUsingBlock:^(NSValue * pointV, NSUInteger idx, BOOL *stop) {
        NSMapTable * block = [self blockOfCoordinate:[pointV pointValue]];
        NSArray * nextKeys = [block.keyEnumerator allObjects];
        [keys addObjectsFromArray:nextKeys];
    }];
    
    return keys;
}

- (NSMutableArray *)blocksCoordFromRect:(CGRect)rect {
    NSMutableArray * blocks = [[NSMutableArray alloc] init];
    NSInteger i, j;
    
    NSPoint blockLowLeft = NSMakePoint(floor(rect.origin.x / self.blockSize), floor(rect.origin.y / self.blockSize));
    NSInteger rightEdge = floor((rect.origin.x + rect.size.width) / self.blockSize);
    NSInteger upperEdge = floor((rect.origin.y + rect.size.height) / self.blockSize);
    
    for (i = blockLowLeft.x; i <= rightEdge; i++) {
        for (j = blockLowLeft.y; j <= upperEdge; j++) {
            [blocks addObject:[NSValue valueWithPoint:NSMakePoint(i, j)]];
        }
    }
    return blocks;
}


- (NSMutableArray *)blocksFromCoordinates:(NSMutableArray *)coordArray {
    NSMutableArray * blocks = [[NSMutableArray alloc] init];
    
    [coordArray enumerateObjectsUsingBlock:^(NSValue * pointV, NSUInteger idx, BOOL *stop) {
        NSMapTable * block = [self blockOfCoordinate:[pointV pointValue]];
        [blocks addObject:block];
    }];
    
    return blocks;
}

- (NSMapTable *)blockOfCoordinate:(NSPoint)point {
    NSInteger pX, pY;
    NSInteger diff;
    // alloco array nei quadranti 1 o 4
    if (point.x >= 0) {
        pX = point.x;
        if (point.y >= 0) {
            pY = point.y;
            for (diff = point.x - [self.linesRightUp count]; diff >= 0; diff--) {
                [self.linesRightUp addObject:[[NSMutableArray alloc] init]];
            }
            for (diff = point.y - [self.linesRightUp[pX] count]; diff >= 0; diff--) {
                [self.linesRightUp[pX] addObject:[[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                                           valueOptions:NSMapTableStrongMemory
                                                                               capacity:1]];
            }
        }
        else {
            pY = fabs(point.y + 1);
            for (diff = point.x - [self.linesRightDown count]; diff >= 0; diff--) {
                [self.linesRightDown addObject:[[NSMutableArray alloc] init]];
            }
            for (diff = fabs(point.y - 1) - [self.linesRightDown[pX] count]; diff >= 0; diff--) {
                [self.linesRightDown[pX] addObject:[[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                                             valueOptions:NSMapTableStrongMemory
                                                                                 capacity:1]];
            }
        }
    }
    
    // alloco array nei quadranti 2 o 3
    else {
        pX = fabs(point.x + 1);
        if (point.y >= 0) {
            pY = point.y;
            for (diff = fabs(point.x - 1) - [self.linesLeftUp count]; diff >= 0; diff--) {
                [self.linesLeftUp addObject:[[NSMutableArray alloc] init]];
            }
            for (diff = point.y - [self.linesLeftUp[pX] count]; diff >= 0; diff--) {
                [self.linesLeftUp[pX] addObject:[[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                                          valueOptions:NSMapTableStrongMemory
                                                                              capacity:1]];
            }
        }
        else {
            pY = fabs(point.y + 1);
            for (diff = fabs(point.x - 1) - [self.linesLeftDown count]; diff >= 0; diff--) {
                [self.linesLeftDown addObject:[[NSMutableArray alloc] init]];
            }
            for (diff = fabs(point.y - 1) - [self.linesLeftDown[pX] count]; diff >= 0; diff--) {
                [self.linesLeftDown[pX] addObject:[[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                                                            valueOptions:NSMapTableStrongMemory
                                                                                capacity:1]];
            }
        }
    }
    if (point.x >= 0 && point.y >= 0)
        return self.linesRightUp[pX][pY];
    else if (point.x >= 0)
        return self.linesRightDown[pX][pY];
    else if (point.y >= 0)  // point.x < 0
        return self.linesLeftUp[pX][pY];
    else                    // point.x < 0 && point.y < 0
        return self.linesLeftDown[pX][pY];
    
}



- (BOOL)isNodeActive:(NSInteger)key {
    DRRPresenceNode * pNode = self.presenceArray[key];
    return pNode.active;
}

- (void)setNodesState:(BOOL)flag fromKeySet:(NSMutableSet *)set {
    [set enumerateObjectsUsingBlock:^(NSString * keyString, BOOL *stop) {
        [self.presenceArray[[keyString integerValue]] setActive:flag];
    }];
}



@end



@implementation DRRScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.prevBallPos = CGPointMake(0, 0);
        self.distEdge = CGSizeMake(self.frame.size.width / 2, self.size.height / 2);
        self.linesContainer = [[DRRLinesContainer alloc] init];
//        self.prevScreenRect_world = CGRectMake(0, 0, 1, 1);
        self.screenRect_world = CGRectMake(0, 0, 1, 1);
        self.screenRect_world_phys = CGRectMake(0, 0, 1, 1);
        self.nextNodes = [[NSMutableArray alloc] init];
        self.nextNodesPhys = [[NSMutableArray alloc] init];
        self.blockSizeUnit = self.linesContainer.blockSize * 0.99;
//        self.updateWorldTreeCounter = 5;
        self.PhysicsUpdateRequiredTime = 0.083;
        self.prevPhysicsUpdateTime = 0;
//        self.firstdraw = YES;
//        self.fixedTimeBetweenFrames = 1/60;
    }
    return self;
}

- (id)initWithSize:(CGSize)size linesPath:(NSMutableArray *)lpaths ballPosition:(CGPoint)ballPos ballRadius:(CGFloat)rad {
   
    if (self = [self initWithSize:size]) {

//        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
//        self.prevBallPos = CGPointMake(0, 0);
//        self.distEdge = CGSizeMake(self.frame.size.width / 2, self.size.height / 2);
//        self.fixedTimeBetweenFrames = 1/60;
        
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
        self.ball.physicsBody.categoryBitMask = ballCategory;
        self.ball.physicsBody.collisionBitMask = /*emptyCategory;*/ lineCategory;
        [self.ball.physicsBody setFriction:0.4];
        
        if (lpaths != NULL) {
            
//            NSMutableArray * linesNodes = [[NSMutableArray alloc] init];
            self.world = [[SKNode alloc] init];
            self.worldWithPhysics = [[SKNode alloc] init];
            [self addChild:self.world];
            [self addChild:self.worldWithPhysics];
            
            [lpaths enumerateObjectsUsingBlock:^(NSValue * pathVal, NSUInteger idx, BOOL *stop) {
//                [linesNodes addObject:[[SKShapeNode alloc] init]];
                SKShapeNode * currNodePhys = [[SKShapeNode alloc] init];
                SKShapeNode * currNode = [[SKShapeNode alloc] init];
                
                currNode.path = [pathVal pointerValue];
                currNodePhys.path = [pathVal pointerValue];
                CGPathRelease([pathVal pointerValue]);
                currNode.lineWidth = 0.1;
                currNode.strokeColor = [SKColor blackColor];
                currNodePhys.strokeColor = [SKColor clearColor];
                currNode.fillColor = [SKColor clearColor];
                currNodePhys.fillColor = [SKColor /*colorWithCalibratedRed:1 green:1 blue:1 alpha:0.3*/clearColor];
                
                [currNodePhys setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:currNodePhys.path]];
//                currNode.physicsBody.restitution = 0.3;
                currNodePhys.physicsBody.dynamic = NO;
                currNodePhys.physicsBody.resting = YES;
                currNodePhys.physicsBody.categoryBitMask = lineCategory;
                currNodePhys.physicsBody.collisionBitMask = /*emptyCategory;*/ ballCategory;
                
                // Aggiungo il nodo al contenitore di linee per aggiungere all'albero della scena solo quelle che servono
                [self.linesContainer addNode:currNode andWithPhysics:currNodePhys];
                
//                [self.world addChild:currNode];
            }];
            
            self.screenRect_world_phys = CGRectMake(self.ball.position.x - self.blockSizeUnit,
                                                    self.ball.position.y - self.blockSizeUnit,
                                                    self.blockSizeUnit * 2,
                                                    self.blockSizeUnit * 2);
            NSMutableSet * nextKeysPhys = [self.linesContainer keysInBlocksThatContainsRect:self.screenRect_world_phys];
            [nextKeysPhys enumerateObjectsUsingBlock:^(NSString * key, BOOL *stop) {
                SKShapeNode * node = [self.linesContainer nodeByKey:[key integerValue] wantsPhysics:YES];
                [self.worldWithPhysics addChild:node];
                [node.physicsBody setResting:YES];
            }];
            
            self.screenRect_world = CGRectMake(self.ball.position.x - self.blockSizeUnit * 3,
                                               self.ball.position.y - self.blockSizeUnit * 1.5,
                                               self.blockSizeUnit * 6,
                                               self.blockSizeUnit * 3);
            NSMutableSet * nextKeys = [self.linesContainer keysInBlocksThatContainsRect:self.screenRect_world];
            [nextKeys enumerateObjectsUsingBlock:^(NSString * key, BOOL *stop) {
                [self.world addChild:[self.linesContainer nodeByKey:[key integerValue] wantsPhysics:NO]];
            }];
            
            self.firstdraw = YES;
        }
        
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
//    [super update:currentTime];
    
    // Ogni 10 frame aggiorno il sottoalbero del mondo che contiene le linee
//    if (self.updateWorldTreeCounter == 5) {
//        self.updateWorldTreeCounter = 0;
    if (currentTime - self.prevPhysicsUpdateTime > self.PhysicsUpdateRequiredTime) {
//        NSLog(@"%f - %f", currentTime, self.prevPhysicsUpdateTime);
        self.prevPhysicsUpdateTime = currentTime;
        
        if (!self.firstdraw) {
            
            [self.worldWithPhysics removeAllChildren];
            [self.nextNodesPhys enumerateObjectsUsingBlock:^(SKShapeNode * node, NSUInteger idx, BOOL *stop) {
                [self.worldWithPhysics addChild:node];
                [node.physicsBody setResting:YES];
            }];
            
            [self.world removeAllChildren]; // TODO fare meglio
            [self.nextNodes enumerateObjectsUsingBlock:^(SKShapeNode * node, NSUInteger idx, BOOL *stop) {
                [self.world addChild:node];
            }];
            
        }
        else {
            self.firstdraw = NO;
//            self.sceneView = (DRRSceneView *) self.view;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            NSInteger ballDirRight = -1;
            NSInteger ballDirUp = -1;
            if (self.ball.physicsBody.velocity.dx > 0)
                ballDirRight = 1;
            if (self.ball.physicsBody.velocity.dy > 0)
                ballDirUp = 1;
            
            CGPoint newOrigin;
            if (ballDirUp == 1)
                newOrigin = CGPointMake(self.ball.position.x - ballDirRight,
                                        self.ball.position.y - ballDirUp);
            else
                newOrigin = CGPointMake(self.ball.position.x - ballDirRight,
                                        self.ball.position.y - ballDirUp - self.blockSizeUnit);
            
            self.screenRect_world_phys = CGRectMake(newOrigin.x,
                                                    newOrigin.y,
                                                    self.blockSizeUnit,
                                                    self.blockSizeUnit);
            NSMutableSet * nextKeysPhys = [self.linesContainer keysInBlocksThatContainsRect:self.screenRect_world_phys];
            [self.nextNodesPhys removeAllObjects];
            [nextKeysPhys enumerateObjectsUsingBlock:^(NSString * key, BOOL *stop) {
                SKShapeNode * node = [self.linesContainer nodeByKey:[key integerValue] wantsPhysics:YES];
                [self.nextNodesPhys addObject:node];
            }];
            
            if (self.sceneView == nil)
                self.sceneView = (DRRSceneView *) self.view; // TODO: trovare un punto migliore
            self.screenRect_world = CGRectMake(self.ball.position.x - self.blockSizeUnit * 3 / self.sceneView.scale,
                                               self.ball.position.y - self.blockSizeUnit * 1.5 / self.sceneView.scale,
                                               self.blockSizeUnit * 6 / self.sceneView.scale,
                                               self.blockSizeUnit * 3 / self.sceneView.scale);

            NSMutableSet * nextKeys = [self.linesContainer keysInBlocksThatContainsRect:self.screenRect_world];
            [self.nextNodes removeAllObjects];
            [nextKeys enumerateObjectsUsingBlock:^(NSString * key, BOOL *stop) {
                SKShapeNode * node = [self.linesContainer nodeByKey:[key integerValue] wantsPhysics:NO];
                [self.nextNodes addObject:node];
            }];
            
        });
            
//        }
        
    }
    
//    else
//        self.updateWorldTreeCounter++;
    
}

- (void)didEvaluateActions {
    
//    [super didEvaluateActions];
    
    self.prevPrevBallPos = self.prevBallPos;
    self.prevBallPos = self.ball.position;
    
}

- (void)didSimulatePhysics {
    
//    [super didSimulatePhysics];
    
    if (self.ball.position.x != 0 || self.ball.position.y != 0) {
//        DRRSceneView * sceneView = (DRRSceneView *) self.view;
        CGFloat myScale = ((DRRSceneView *) self.view).scale * 1.01;
        
        CGVector move = CGVectorMake((self.prevBallPos.x - self.ball.position.x),
                                     (self.prevBallPos.y - self.ball.position.y));
        
        [self runAction:[SKAction moveBy:CGVectorMake(move.dx * myScale,
                                                      move.dy * myScale)
                                duration:0.3]];
        [(DRRSceneView *)self.view moveUpdate:NSMakeSize(move.dx, move.dy) useRuntime:YES];
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
    self.panRuntime = NSMakePoint(0, 0);
//    self.initMove = CGVectorMake(0, 0);
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

//    nextScene.physicsWorld.speed = 1;
    [self presentScene:nextScene];
//    nextScene = NULL; // FIXME
    
}



- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag {
    
    [super setFrameSize:newSize];
    
    [self.scene setSize:self.bounds.size];
    if (flag) {
        
//        NSPoint diff = NSMakePoint(self.panRuntime.x * self.scale, self.panRuntime.y * self.scale);
//        [self.scene runAction:[SKAction moveTo:CGPointMake(diff.x + self.initMove.dx, diff.y + self.initMove.dy) duration:0]];
        
//        [self scaleScene:(DRRScene *)self.scene];
//        [self moveScene:(DRRScene *)self.scene];
    }
    
}

- (void)scaleUpdate:(CGFloat)step {
    self.scale *= step;
}

- (void)scaleScene:(DRRScene *)scene {

    [scene runAction:[SKAction scaleTo:self.scale duration:0]];
    
}

- (void)moveUpdate:(NSSize)move useRuntime:(BOOL)flag {
    
    
    
    if (flag)
        self.panRuntime = NSMakePoint(self.panRuntime.x + move.width,
                                      self.panRuntime.y + move.height);
    else {
        self.pan = NSMakePoint(self.pan.x + move.width,
                               self.pan.y + move.height);
        self.panRuntime = self.pan;
    }
    
}

- (void)moveScene:(DRRScene *)scene /*useRuntime:(BOOL)flag*/ {
//    NSPoint diff;
    
//    if (flag)
//        diff = NSMakePoint(self.panRuntime.x * self.scale, self.panRuntime.y * self.scale);
//    else
    NSPoint diff = NSMakePoint(self.panRuntime.x * self.scale, self.panRuntime.y * self.scale);
    
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

