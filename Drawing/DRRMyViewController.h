//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRPointObj.h"

#define DEBUGMODE 0



NSRect computeRect(CGFloat x, CGFloat y, CGFloat w, CGFloat h, NSInteger border);



@interface DRRMyViewController : NSView {

    // coordinata precedente mouse per mouseDragged (ridisegno solo zona cambiata)
    NSPoint prevmouseXY;
    
    // array dei bottoni dell'interfaccia
    NSMutableArray * controls;
    
    // array e altro per contenere i punti del mouse da convertire in linee
    NSMutableArray * linesContainer;
    NSInteger last;
    NSMutableArray * BezierPathsToDraw;
    BOOL linesNeedDisplay;
    
    // path che contengono le linee da disegnare e i punti in cui viene rilevato il mouse
    NSBezierPath * pathLines, * pathSinglePoint;
    
}

- (id)initWithFrame:(NSRect)frameRect;
- (void)addEmptyLine;
- (void)addPointToLatestLine:(NSPoint*)p;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)dirtyRect;

@end










