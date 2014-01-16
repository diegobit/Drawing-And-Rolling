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



@interface DRRScene : SKScene

@property CGMutablePathRef pathLines;

//- (void)update:(NSTimeInterval)currentTime;
- (id)initWithSize:(CGSize)size linesPath:(NSMutableArray *)path ballPosition:(CGPoint)ballPos ballRadius:(CGFloat)rad;
//- (id)initWithSize:(CGSize)size linesPathFromNSBezierPath:(NSBezierPath *)path;

@end



@interface DRRSceneView : SKView

//@property NSMutableArray * lines;
@property NSSize pan;
@property NSSize panRelative;
@property CGFloat scale;
@property CGFloat scaleRelative;

- (id)initWithFrame:(NSRect)frameRect;
- (void)setItemPropertiesToDefault;

- (void)buildSceneContent:(NSMutableArray *)lines ballPosition:(NSPoint *)ballpos ballRadius:(CGFloat)rad;// move:(NSSize)mfactor scale:(CGFloat)sfactor;

- (void)setFrameSize:(NSSize)newSize isActive:(BOOL)flag;
//- (void)setSceneFrameSizeAndMoveIt:(DRRScene *)scene newSize:(CGSize)newSize;
- (void)scaleUpdate:(CGFloat)step;
- (void)scaleScene:(DRRScene *)scene useRelative:(BOOL)flag;
//- (void)scaleScene:(DRRScene *)scene newSize:(CGSize)newSize useRelative:(BOOL)flag;
- (void)moveUpdate:(NSSize)move;
- (void)moveScene:(DRRScene *)scene useRelative:(BOOL)flag;
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
