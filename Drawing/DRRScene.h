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

@property NSMutableArray * lines;

- (id)initWithFrame:(NSRect)frameRect;
//- (BOOL)isOpaque;

@end



@interface DRRScene : SKScene

@property NSMutableArray * lines;

- (id)initWithSize:(CGSize)size;
    
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
