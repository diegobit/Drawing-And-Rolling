//
//  DRRMyViewController.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRMyViewController.h"

///// TODO il doubleidx non serve :(

NSRect computeRect(NSPoint p1, NSPoint p2, NSInteger border) {
    
    CGFloat x = MIN(p1.x, p2.x) - border; CGFloat y = MIN(p1.y, p2.y) - border;
    CGFloat raww = p2.x - p1.x; CGFloat rawh = p2.y - p1.y;
    CGFloat w = ABS(raww) + 2*border; CGFloat h = ABS(rawh) + 2*border;
    
    return NSMakeRect(x, y, w, h);
}



NSPoint findAdiacentVertex(NSMutableArray * linesarr, NSPoint pt) {
    __block NSPoint doubleidx;
    __block BOOL found = NO;
    if (linesarr != NULL) {
        if ([linesarr count] > 0) {
            // comincio il ciclo: per ogni oggetto dell'array (NSMutableArray di NSPoint)...
            [linesarr enumerateObjectsWithOptions:NSEnumerationReverse
                                    usingBlock:^(id line, NSUInteger idx, BOOL *stop) {
                                        
                                        // ...cerco i punti i cui indici sono il primo e l'ultimo della linea
                                        NSInteger endidx = [line count] - 1;
                                        NSPoint startp = [line[0] getPoint];
                                        NSPoint endp = [line[endidx] getPoint];
                                        
                                        // e controllo la loro distanza dal mio punto: punto finale...
                                        if ((abs(endp.x - pt.x) <= PTDISTANCE) && (abs(endp.y - pt.y) <= PTDISTANCE)) {
                                            *stop = YES; found = YES;
                                            doubleidx = NSMakePoint(idx, endidx);
                                        }
                                        // ...e punto iniziale
                                        else if ((abs(startp.x - pt.x) <= PTDISTANCE) && (abs(startp.y - pt.y) <= PTDISTANCE)) {
                                            *stop = YES; found = YES;
                                            
                                            // rigiro l'array in modo da poter continuare la linea aggiungendo punti alla fine
                                            DRRPointObj * temp;
                                            NSInteger i, j;
                                            for (i = 0, j = [line count] - 1; i < j; i++, j--) {
                                                temp = line[i];
                                                line[i] = line[j];
                                                line[j] = temp;
                                            }
                                            
                                            doubleidx = NSMakePoint(idx, endidx);
                                        }
                                    }];
        }
        
        // arrivo qui solo se l'array delle linee è vuoto oppure se non ho trovato un punto adiacente al mio
        if (!found) doubleidx.x = NOTFOUND;
        return doubleidx;

    }
    else {
        doubleidx.x = ARGERROR;
        errno = 0; ///// TODO errno
        return doubleidx;
    }
}


@implementation DRRMyViewController


- (NSSize)screenSize {
    
    NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    NSInteger screenCount = [screenArray count];
    NSInteger i  = 0;
    
    for (i = 0; i < screenCount; i++)
    {
        NSScreen *screen = [screenArray objectAtIndex: i];
        screenRect = [screen visibleFrame];
    }
    
    return screenRect.size;
}

//NSRect frameRelativeToWindow = [self convertRect:myView.bounds toView:nil];
//NSRect frameRelativeToScreen = [self.window convertRectToScreen:frameInWindow];

//- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view {
//	NSPoint windowPoint = [view convertPoint:point toView:nil];
//    NSPoint screenPoint = [[view window] convertBaseToScreen:windowPoint];
//	
//	return screenPoint;
//}

//- (void)moveMouseToScreenPoint:(NSPoint)point
//{
//	CGPoint cgPoint = NSPointToCGPoint(point);
//    
//	CGSetLocalEventsSuppressionInterval(0.0);
//	CGWarpMouseCursorPosition(cgPoint);
//	CGSetLocalEventsSuppressionInterval(0.25);
//}



- (void)awakeFromNib {
    [self setItemPropertiesToDefault];
    NSLog(@"awakeFromNib");

    ///// TODO bottoni !
    
    
    
    
    
}



- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSLog(@"initWithFrame myViewController");
        /////TODO array controlli?      // inizializzo l'array dei controlli e li alloco
        
        // inizializzo l'array di linee disegnate e le proprietà
        linesContainer = [[NSMutableArray alloc] init];
        last = -1;
        [self setItemPropertiesToDefault];
    }
    return self;
}



- (void)setItemPropertiesToDefault {
    ///// TODO più proprietà di default?
}

//- (void)setLayoutDefault {    //    [self setBounds:[super bounds]];  //    [self setFrame:[super frame]]; //}



- (void)addEmptyLine {
    NSMutableArray * line = [[NSMutableArray alloc] init];
    [linesContainer addObject:line];
    last++;
    // controllare alloc? FIXME
}


- (void)addPointToLatestLine:(NSPoint*)p {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        
        [linesContainer[last] addObject:pobj];
    }
    else
        errno = 0; ///// TODO errno
}


- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        [linesContainer[idx] addObject:pobj];
    }
    else
        errno = 0; ///// TODO errno
}


- (void)mouseDown:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    prevmouseXY = pwindow;
    
    // controllo se il mouse è vicino ad un punto precedente...
    nearpointIdx = findAdiacentVertex(linesContainer, pview);
    
    // ...si! Ancoro la nuova linea a quella.
    if (nearpointIdx.x != ARGERROR && nearpointIdx.x != NOTFOUND) {
        thisIsANewLine = NO;
        NSPoint nearpoint = [linesContainer[(NSInteger)nearpointIdx.x][(NSInteger)nearpointIdx.y] getPoint];
        prevmouseXY = nearpoint;
        
        // sposto il puntatore del mouse nella nuova posizione (coordinate schermo)
        NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
        NSPoint newpos = NSMakePoint(frameRelativeToScreen.origin.x + nearpoint.x,
                                     frameRelativeToScreen.origin.y + self.window.frame.size.height - nearpoint.y);
        CGWarpMouseCursorPosition(newpos);
    }
    
    // ...no! Aggiungo una nuova linea e il punto ad essa.
    else if (nearpointIdx.x == NOTFOUND) {
        thisIsANewLine = YES;
        [self addEmptyLine];
        [self addPointToLatestLine:(&pview)];
    }
    
    else
        perror("myViewController: mouseDown: findAdiacentVertex");
    
    
    
    //    [self drawRect:([self bounds])];
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    // Devo aggiungere i punti a quella linea ancorata nella mouseDown senza crearne una nuova
    if (!thisIsANewLine)
        [self addPointToIdxLine:(&pview) idxLinesArray:nearpointIdx.x];
    
    // Creo nuova linea.
    else
        [self addPointToLatestLine:(&pview)];

    NSRect dirtyRect = computeRect(prevmouseXY, pwindow, 2);
    [self setNeedsDisplayInRect:dirtyRect];
        
    prevmouseXY = pwindow;
    
}


- (void)mouseUp:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    [self addPointToLatestLine:(&pview)];
    NSRect dirtyRect = computeRect(prevmouseXY, pwindow, 2);
    [self setNeedsDisplayInRect:dirtyRect];
    
    prevmouseXY = pwindow;
    
}


- (void)drawRect:(NSRect)dirtyRect {
    
    //    if (!NSEqualRects(prevbounds, [self bounds])) {
    //        [self setLayoutDefault];
    //    }
    NSLog(@"draw");
    NSColor * black = [NSColor blackColor];
    NSColor * white = [NSColor whiteColor];
    NSColor * red = [NSColor redColor];
    
    [white set];
    NSRectFill(dirtyRect);
    
    //    NSGraphicsContext * g = [NSGraphicsContext currentContext];
    //    CGContextRef gport = [g graphicsPort];
//    NSBezierPath *path = [NSBezierPath bezierPath];
    pathLines = [NSBezierPath bezierPath];
    if (DEBUGMODE) { pathSinglePoint = [NSBezierPath bezierPath]; }
    [pathLines setLineWidth: 2];
    [black set];
    
//    srand(time(NULL));
    
    // per ogni linea del contenitore creo un path con NSBezierPath
    if ([linesContainer count] > 0) {
        [linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger iline, BOOL *stop1) {
            if ([line count] > 0) {
                // aggiungo ogni punto della linea al path
                [line enumerateObjectsUsingBlock:^(id point, NSUInteger ipoint, BOOL *stop2) {
                    NSPoint p = [point getPoint];
                    if (DEBUGMODE) {
                        [pathSinglePoint appendBezierPathWithOvalInRect:NSMakeRect(p.x - 1.5, p.y - 1.5, 3, 3)];
                    }
                    
                    if (ipoint == 0)
                        [pathLines moveToPoint:p];
                    else {
//                        NSPoint p = [point getPoint];
//                        NSInteger r1 = rand() % 20; NSInteger r2 = rand() % 20;
//                        NSPoint pc1 = NSMakePoint(p.x + r1, p.y - r2);
//                        NSPoint pc2 = NSMakePoint(p.x - r1, p.y + r2);
//                        [path curveToPoint:p controlPoint1:pc1 controlPoint2:pc2];
                        [pathLines lineToPoint:[point getPoint]];
                    }
                }];
                
                [black set];
                [pathLines stroke];
                if (DEBUGMODE) {
                    [red set];
                    [pathSinglePoint fill];
                    [pathSinglePoint removeAllPoints];
                }
                [pathLines removeAllPoints];
//                [self setNeedsDisplay:YES];
            }
        }];
    }

    [super drawRect:dirtyRect];
    
//      prevbounds = [self bounds];
    
}

@end






