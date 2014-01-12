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
    
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self setWantsLayer:YES];
        
        DRRScene * scene = [DRRScene sceneWithSize:CGSizeMake(frameRect.size.width, frameRect.size.height)];
        scene.scaleMode = SKSceneScaleModeFill;
        [self presentScene:scene];
        
//        [self setPaused:YES];
        
        #ifdef DEBUGSCENE
        self.showsFPS = YES;
        self.showsNodeCount = YES;
        self.showsDrawCount = YES;
        #endif
        
    }
    return self;

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return self;
}



- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self.scene setSize:NSSizeToCGSize(newSize)];
}



- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"sceneview draw");
    [[NSColor clearColor] setFill];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}



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
- (void)rightMouseDown:(NSEvent *)theEvent {
    [self.superview rightMouseDown:theEvent];
}
- (void)rightMouseUp:(NSEvent *)theEvent {
    [self.superview rightMouseUp:theEvent];
}

@end



@implementation DRRScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        SKShapeNode * ball = [[SKShapeNode alloc] init];
        CGMutablePathRef myPath = CGPathCreateMutable();
        
//        CGAffineTransform m = CGAffineTransformIdentity;
//        
//        m = CGAffineTransformScale(m, 3, 3);
        CGPathAddArc(myPath, NULL, 100,100, 15, 0, M_PI*2, YES);
        ball.path = myPath;
        ball.lineWidth = 1.0;
        ball.fillColor = [SKColor blueColor];
        ball.strokeColor = [SKColor redColor];
        ball.glowWidth = 0.5;
        
        [self addChild:ball];
        
        
        SKShapeNode *yourline = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, 100.0, 100.0);
        CGPathAddLineToPoint(pathToDraw, NULL, 50.0, 50.0);
        CGPathAddLineToPoint(pathToDraw, NULL, 40.0, 50.0);
        CGPathMoveToPoint(pathToDraw, NULL, 40.0, 60.0);
        CGPathAddLineToPoint(pathToDraw, NULL, 40.0, 70.0);

        yourline.path = pathToDraw;
        [yourline setStrokeColor:[NSColor redColor]];
        [self addChild:yourline];
        
        
        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        [self addChild:myLabel];
    }
    return self;
}




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
