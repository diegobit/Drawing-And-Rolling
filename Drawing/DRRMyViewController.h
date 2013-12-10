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
    
    NSMutableArray * controls;
    
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
    
    NSRect rect;
//    NSPoint origin;
//    NSSize size;
    
}

- (id)initWithSize:(NSSize)rectSize;

- (NSPoint)getFrameOrigin;
- (NSSize)getFrameSize;
- (NSRect)getFrame;
- (void)setFrameOrigin:(NSPoint)o;
- (void)setFrameSize:(NSSize)s;
- (void)setFrame:(NSRect)r;

- (BOOL)hitTest:(NSPoint)p;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)dirtyRect;


@end










