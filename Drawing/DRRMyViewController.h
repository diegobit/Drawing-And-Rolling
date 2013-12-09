//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRPointObj.h"



NSRect computeRect(CGFloat x, CGFloat y, CGFloat w, CGFloat h, NSInteger border);



@interface DRRMyViewController : NSView {

    NSPoint prevmouseXY;
    
    NSMutableArray * linesContainer;
    NSInteger last;
    NSMutableArray * BezierPathsToDraw;
    
    BOOL linesNeedDisplay;
    
}

- (id)initWithFrame:(NSRect)frameRect;
- (void)addEmptyLine;
- (void)addPointToLatestLine:(NSPoint*)p;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)dirtyRect;

@end



@interface DRRMyControl : NSObjectController {
    
    NSSize size;
    
}

- (id)initWithSize:(NSSize)rectSize;
- (NSSize)getSize;
//- (NSPoint)getFrameOrigin; //- (NSRect)getFrame; //- (void)setFrameOrigin:(NSPoint)o; //- (void)setFrame:(NSRect)r;
- (void)setSize:(NSSize)rectSize;



@end










