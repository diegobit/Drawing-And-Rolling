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
        
//        [self setPaused:YES];
        
        #ifdef DEBUGSCENE
        self.showsFPS = YES;
        self.showsNodeCount = YES;
        self.showsDrawCount = YES;
        #endif
        
    }
    return self;

}



- (void)buildLines:(NSMutableArray *)lines distanceReceiverOriginAndSenderOrigin:(NSSize)d scale:(CGFloat)sfactor{
    NSLog(@"5");
    DRRScene * nextScene = NULL;
    
    if ([lines count] > 0) {
        NSLog(@"6");
        // Creo il path delle linee per la scena
        CGMutablePathRef linesMutPath = CGPathCreateMutable();
        
        [lines enumerateObjectsUsingBlock:^(NSMutableArray * line, NSUInteger idx, BOOL *stop) {
            
            [line enumerateObjectsUsingBlock:^(NSValue * vpoint, NSUInteger idx, BOOL *stop) {
                NSPoint p = [vpoint pointValue];
                
                if (idx == 0)
                    CGPathMoveToPoint(linesMutPath, NULL, p.x, p.y);
                else
                    CGPathAddLineToPoint(linesMutPath, NULL, p.x, p.y);
            }];
            
        }];
        
        CGPathRef linesPath = CGPathCreateCopy(linesMutPath);
        
        // Creo la scena con le linee e il bordo per la simulazione fisica
        nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) linesPath:linesPath];
        
        [nextScene setPhysicsBody:[SKPhysicsBody bodyWithEdgeChainFromPath:linesPath]];
    }
    
    // Non ci sono linee nell'array, creo una scena vuota
    else
        nextScene = [[DRRScene alloc] initWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    
    NSLog(@"7");
    nextScene.scaleMode = SKSceneScaleModeAspectFit;
//    NSSize newSize = [self.]
//    nextScene.anchorPoint = CGPointMake(0.5, 0.5);
//    CGPoint pos = CGPointMake(200, 200);
//    [nextScene runAction:[SKAction moveTo:pos duration:0]];
//    nextScene.size = CGSizeMake(nextScene.size.width / sfactor,
//                                nextScene.size.height / sfactor);
//    [nextScene setAnchorPoint:CGPointMake((self.frame.size.width + d.width) / 2, (self.frame.size.height + d.height) / 2)];
//    [nextScene set]
    [nextScene runAction:[SKAction scaleTo:sfactor duration:0]];
//    [nextScene setScale:sfactor];

    [self presentScene:nextScene];
    nextScene = NULL; // FIXME
    NSLog(@"8");
}



- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self.scene setSize:NSSizeToCGSize(newSize)];
}



//- (void)drawRect:(NSRect)dirtyRect {
//    NSLog(@"sceneview draw");
//    [[NSColor clearColor] setFill];
//    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
//}



- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"skview");
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
        
        SKShapeNode * ball = [[SKShapeNode alloc] init];
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 100,100, 15, 0, M_PI*2, YES);
        ball.path = myPath;
        ball.lineWidth = 1.0;
        ball.fillColor = [SKColor blueColor];
        ball.strokeColor = [SKColor redColor];
//        ball.glowWidth = 0.5;
        
        [self addChild:ball];
    }
    return self;
}

- (id)initWithSize:(CGSize)size linesPath:(CGPathRef)lpath {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        SKShapeNode * lines = [[SKShapeNode alloc] init];
        lines.path = lpath;
        lines.lineWidth = 0.1;
        lines.strokeColor = [SKColor blackColor];
        lines.fillColor = [SKColor clearColor]; // FIXME: sarebbe meglio non riempisse proprio
        
        [self addChild:lines];
        
        
        
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
- (void)rightMouseDown:(NSEvent *)theEvent {
    [self.view rightMouseDown:theEvent];
}
- (void)rightMouseUp:(NSEvent *)theEvent {
    [self.view rightMouseUp:theEvent];
}

@end
