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


@interface DRRSceneView : SKView

//@property NSMutableArray * lines;

- (id)initWithFrame:(NSRect)frameRect;

- (void)buildLines:(NSMutableArray *)lines distanceReceiverOriginAndSenderOrigin:(NSSize)d scale:(CGFloat)sfactor;

- (void)setFrameSize:(NSSize)newSize;
//- (BOOL)isOpaque;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
//- (void)rightMouseDown:(NSEvent *)theEvent;
//- (void)rightMouseUp:(NSEvent *)theEvent;

@end



@interface DRRScene : SKScene

@property CGMutablePathRef pathLines;

//- (void)update:(NSTimeInterval)currentTime;
- (id)initWithSize:(CGSize)size linesPath:(CGPathRef)path;
//- (id)initWithSize:(CGSize)size linesPathFromNSBezierPath:(NSBezierPath *)path;

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
