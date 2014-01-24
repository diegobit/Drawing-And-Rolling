//
//  DRRScene.h
//  Drawing
//
//  Created by Diego on 09/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DRRDock.h"
#include <dispatch/dispatch.h>

//#define DEBUGSCENE
//#define DEBUGPHYSICS

#define lGreen colorWithCalibratedRed:0.35 green:0.88 blue:0.11 alpha:1 // 88 224 12
typedef enum dir {LEFT, UP, DOWN, RIGHT, UPLEFT, UPRIGHT, DOWNLEFT, DOWNRIGHT} dir_t;



@interface DRRObjectNode : NSObject

@property SKShapeNode * nodeWithPhysics;
@property SKShapeNode * nodeWithNoPhysics;

+ (DRRObjectNode *)initWithNode:(SKShapeNode *)node andWithoutPhysics:(SKShapeNode *)nodeWithNoPhys;

- (id)init;

@end



@interface DRRPresenceNode : NSObject

@property BOOL active;
@property NSMutableArray * coordinates;

+ (DRRPresenceNode *)initWithState:(BOOL)flag coordinates:(NSMutableArray *)coord;

- (id)init;

//- (void)addNode:(SKShapeNode *)node;
//- (BOOL)isNodeActive:(NSInteger)key;
//- (NSPoint)getCoordinates:(NSInteger)key;

@end



@interface DRRLinesContainer : NSObject

@property NSInteger blockSize;
//@property NSSortDescriptor * ascendingOrder;
@property NSMutableArray * linesRightUp;
@property NSMutableArray * linesRightDown;
@property NSMutableArray * linesLeftUp;
@property NSMutableArray * linesLeftDown;
@property NSInteger nextFreeKey;

@property NSMutableArray * presenceArray;

- (id)init;

- (void)freeContainer;

//- (void)addKeyToBlock:(NSPoint);
- (void)addNode:(SKShapeNode *)node andWithPhysics:(SKShapeNode *)nodeWithPhysics;
- (SKShapeNode *)nodeByKey:(NSInteger)key wantsPhysics:(BOOL)flag;
/** Ritorna un array che contiene gli SKShapeNode che appaiono nei blocchi che contengono il rettangolo dato.
 *  I nodi trovati vengono segnati come attivi. Non vengono restituito nodi già attivi. */
- (NSMutableArray *)nodesByKeys:(NSMutableSet *)keys wantsPhysics:(BOOL)flag;
- (NSMutableSet *)keysInBlocksThatContainsRect:(CGRect)rect;
- (NSMutableArray *)blocksCoordFromRect:(CGRect)rect;
- (NSMutableArray *)blocksFromCoordinates:(NSMutableArray *)coordArray;
- (NSMapTable *)blockOfCoordinate:(NSPoint)point;
//- (NSMutableArray *)ArrayYOfIndex:(NSInteger)idx;

- (BOOL)isNodeActive:(NSInteger)key;
- (void)setNodesState:(BOOL)flag fromKeySet:(NSMutableSet *)set;

@end



@class DRRSceneView;



@interface DRRScene : SKScene

@property (weak) DRRSceneView * sceneView;
@property CGMutablePathRef pathLines;
@property SKNode * world;
@property SKNode * worldWithPhysics;
@property SKShapeNode * ball;
@property CGPoint prevPrevBallPos;
@property CGPoint prevBallPos;
@property CGSize distEdge;

@property DRRLinesContainer * linesContainer;
@property CGRect screenRect_world;
@property CGRect screenRect_world_phys;
//@property NSMutableSet * nextKeys;
//@property NSMutableSet * nextKeysPhys;
@property NSMutableArray * nextNodes;
@property NSMutableArray * nextNodesPhys;
//@property NSInteger updateWorldTreeCounter;
@property CGFloat prevPhysicsUpdateTime;
@property CGFloat PhysicsUpdateRequiredTime;
@property CGFloat blockSizeUnit;
@property BOOL firstdraw;
#ifdef DEBUGPHYSICS
@property SKNode * debugNode;
#endif

- (id)initWithSize:(CGSize)size linesPath:(NSMutableArray *)path ballPosition:(CGPoint)ballPos ballRadius:(CGFloat)rad;

- (BOOL)movingToAnEdge:(dir_t *)dir objPosition:(CGPoint)pos objVelocity:(CGVector *)vel;

- (void)update:(NSTimeInterval)currentTime;
- (void)didEvaluateActions;
- (void)didSimulatePhysics;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
//- (void)rightMouseDown:(NSEvent *)theEvent;
//- (void)rightMouseUp:(NSEvent *)theEvent;

@end



@interface DRRSceneView : SKView

//@property NSMutableArray * lines;
@property NSInteger maxLenLine;
@property NSPoint pan;
@property NSPoint panRuntime;
//@property CGVector initMove;
@property CGFloat scale;

- (id)initWithFrame:(NSRect)frameRect;
- (void)setItemPropertiesToDefault;
- (void)clearScene;

- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint)ballpos ballRadius:(CGFloat)rad;// move:(NSSize)mfactor scale:(CGFloat)sfactor;

- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag;
//- (void)setSceneFrameSizeAndMoveIt:(DRRScene *)scene newSize:(CGSize)newSize;
- (void)scaleUpdate:(CGFloat)step;
- (void)scaleScene:(DRRScene *)scene;
- (void)moveUpdate:(NSSize)move useRuntime:(BOOL)flag;
- (void)moveScene:(DRRScene *)scene /*useRuntime:(BOOL)flag*/;
//- (BOOL)isOpaque;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
//- (void)rightMouseDown:(NSEvent *)theEvent;
//- (void)rightMouseUp:(NSEvent *)theEvent;

@end



//@interface DRRLines : SKShapeNode
//
//@property NSMutableArray * linesContainer;
//@property NSMutableArray * linesHistory;
//
//- (id)init;
//- (id)initWithCoder:(NSCoder *)aDecoder;
//
//@end
