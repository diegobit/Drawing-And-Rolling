//
//  DRRScene.h
//  Drawing
//
//  Created by Diego on 09/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DRRDock.h"

#define DEBUGSCENE

#define lGreen colorWithCalibratedRed:0.35 green:0.88 blue:0.11 alpha:1 // 88 224 12
typedef enum dir {LEFT, UP, DOWN, RIGHT, UPLEFT, UPRIGHT, DOWNLEFT, DOWNRIGHT} dir_t;


@interface DRRScene : SKScene

@property CGMutablePathRef pathLines;
@property SKNode * world;
@property SKShapeNode * ball;
@property CGPoint prevBallPos;
@property CGPoint ballPosView;
@property CGSize distEdge;
@property CGFloat fixedTimeBetweenFrames;

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
@property NSPoint pan;
@property CGFloat scale;

- (id)initWithFrame:(NSRect)frameRect;
- (void)setItemPropertiesToDefault;

- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint)ballpos ballRadius:(CGFloat)rad;// move:(NSSize)mfactor scale:(CGFloat)sfactor;

- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag;
//- (void)setSceneFrameSizeAndMoveIt:(DRRScene *)scene newSize:(CGSize)newSize;
- (void)scaleUpdate:(CGFloat)step;
- (void)scaleScene:(DRRScene *)scene;
- (void)moveUpdate:(NSSize)move;
- (void)moveScene:(DRRScene *)scene;
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
