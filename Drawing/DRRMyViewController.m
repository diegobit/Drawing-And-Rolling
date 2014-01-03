//
//  DRRMyViewController.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRMyViewController.h"


@implementation DRRSegmentIdx

- (id)initWithIndex:(NSInteger)iline indexTwo:(NSInteger)istartpt indexThree:(NSInteger)iendpt {
    self = [super init];
    if (self) {
        self.idxline = iline;
        self.idxstartpt = istartpt;
        self.idxendpt = iendpt;
    }
    return self;
}

@end


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
                                        if ((abs(endp.x - pt.x) <= PTDISTANCE) && (abs(endp.y - pt.y) <= PTDISTANCE) && !((abs(endp.x - pt.x) > PTDISTANCE*0.7) && (abs(endp.y - pt.y) > PTDISTANCE*0.7))) {
                                            *stop = YES; found = YES;
                                            doubleidx = NSMakePoint(idx, endidx);
                                        }
                                        // ...e punto iniziale
                                        else if ((abs(startp.x - pt.x) <= PTDISTANCE) && (abs(startp.y - pt.y) <= PTDISTANCE) && !((abs(startp.x - pt.x) > PTDISTANCE*0.7) && (abs(startp.y - pt.y) > PTDISTANCE*0.7))) {
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
        errno = EINVAL;
        return doubleidx;
    }
}

NSInteger fsign(CGFloat n) {
    if (n > 0) return 1;
    if (n < 0) return -1;
    return 0;
}


//@implementation superView:DRRMyViewController<dockDelegate>
//
//- (void)updateCursor:(id)sender {
//    
//}
//
//@end


@implementation DRRMyViewController

- (void)updateCursor:(id)sender {
    
    #ifdef DEBUGPROTOCOL
    NSLog(@"DRRMyViewController: Protocol DockToView: updateCursor");
    #endif
    
    DRRButton * btn = [dock selectedCell];
    
    if (btn == btnDrawFree) {
        if (customCursor != DRAW) {
            [[NSCursor arrowCursor] set];
            customCursor = DRAW;
            //        customCursorNext = DRAW;
        }
    }
    
    else if (btn == btnPan) {
        if (customCursor != PANWAIT) {
            [[NSCursor openHandCursor] set];
            customCursor = PANWAIT;
            //            customCursorNext = PANACTIVE;
        }
    }
    
    else if (btn == btnZoom) {
        if (customCursor != ZOOM) {
            [[NSCursor resizeUpDownCursor] set];
            customCursor = ZOOM;
            //            customCursorNext = ZOOM;
        }
    }
    
}

//- (void)removeLatestLineFromButton:(id)sender {
//    [self removeLatestLine];
//}



- (id)initWithFrame:(NSRect)frameRect {
    
    #ifdef DEBUGINIT
    NSLog(@"initWithFrame myView");
    #endif

    self = [super initWithFrame:frameRect];
//    if (self) { }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    #ifdef DEBUGINIT
    NSLog(@"initWithCoder myView");
    #endif
    
    self = [super initWithCoder:aDecoder];
//    if (self) { }
    return self;
}

- (void)awakeFromNib {
    
    #ifdef DEBUGINIT
    NSLog(@"awakeFromNib myView");
    #endif
    [super awakeFromNib];
    [self setItemPropertiesToDefault];
    
    dock = [[DRRDock alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)
                                     mode:NSRadioModeMatrix
                                cellClass:[DRRButton class]
                             numberOfRows:1
                          numberOfColumns:5];
    [dock setDockdelegate:self];
    [dock setCellSize:cellsize];
//    [dock setBackgroundColor:[NSColor lightGrayColor]]; // REMOVE
//    [dock setDrawsBackground:YES]; // REMOVE
    
    NSMutableArray * panPaths = [[NSMutableArray alloc] init];
    NSMutableArray * panModes = [[NSMutableArray alloc] init];
    makePanButton(NSMakeRect(dock.frame.origin.x, dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), panPaths, panModes);
    btnPan = [[DRRButton alloc] initWithPaths:panPaths typeOfDrawing:panModes];
    [dock putCell:btnPan atRow:0 column:0];
    [dock sizeToCells];
    
    NSMutableArray * zoomPaths = [[NSMutableArray alloc] init];
    NSMutableArray * zoomModes = [[NSMutableArray alloc] init];
    makeZoomButton(NSMakeRect(dock.frame.origin.x + 1 + (1 * dock.cellSize.width), dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), zoomPaths, zoomModes);
    btnZoom = [[DRRButton alloc] initWithPaths:zoomPaths typeOfDrawing:zoomModes];
    [dock putCell:btnZoom atRow:0 column:1];
    [dock sizeToCells];
    
    NSMutableArray * drawFreePaths = [[NSMutableArray alloc] init];
    NSMutableArray * drawFreeModes = [[NSMutableArray alloc] init];
    makeDrawFreeButton(NSMakeRect(dock.frame.origin.x + 2 + (2 * dock.cellSize.width), dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), roundness, drawFreePaths, drawFreeModes);
    btnDrawFree = [[DRRButton alloc] initWithPaths:drawFreePaths typeOfDrawing:drawFreeModes];
    [dock putCell:btnDrawFree atRow:0 column:2];
    [dock sizeToCells];
    [dock setState:NSOnState atRow:0 column:2];
    dock.prevSelectedCell = [dock cellAtRow:0 column:2];
    
    NSMutableArray * drawLinePaths = [[NSMutableArray alloc] init];
    NSMutableArray * drawLineModes = [[NSMutableArray alloc] init];
    makeDrawLineButton(NSMakeRect(dock.frame.origin.x + 3 + (3 * dock.cellSize.width), dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), roundness, drawLinePaths, drawLineModes);
    btnDrawLine = [[DRRButton alloc] initWithPaths:drawLinePaths typeOfDrawing:drawLineModes];
    [dock putCell:btnDrawLine atRow:0 column:3];
    [dock sizeToCells];
    
    NSMutableArray * backPaths = [[NSMutableArray alloc] init];
    NSMutableArray * backModes = [[NSMutableArray alloc] init];
    makeBackButton(NSMakeRect(dock.frame.origin.x + 4 + (4 * dock.cellSize.width), dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), roundness, backPaths, backModes);
    btnBack = [[DRRActionButton alloc] initWithPaths:backPaths typeOfDrawing:backModes];
    [dock putCell:btnBack atRow:0 column:4];
    [dock sizeToCells];
    SEL undo = @selector(removeLatestLine);
    [[dock cellAtRow:0 column:4] setAction:undo];
    [[dock cellAtRow:0 column:4] setTarget:self];

    
    [self addSubview:dock];
    [dock.dockdelegate updateCursor:self];
    
    //    NSCell * btnPlay = [[DRRbuttonDrawPlay alloc] init];
}

- (void)setItemPropertiesToDefault {
    
    #ifdef DEBUGINIT
    NSLog(@"setItemProperties myView");
    #endif
    
//    self.prevFrame = self.frame;
    viewPrevResizeWasInLive = NO;
    validLine = NO;
    customCursor = DRAW;
    maxZoomFactor = 4;
    minZoomFactor = 0.25;
    
    // inizializzo l'array di linee disegnate e le proprietà
    linesContainer = [[NSMutableArray alloc] init];
    linesHistory = [[NSMutableArray alloc] init];
    pathLines = [NSBezierPath bezierPath];
    
    screenRect = [[NSScreen mainScreen] frame];
    v2wTrans = [NSAffineTransform transform];
    v2wScale = [NSAffineTransform transform];
    w2vTrans = [NSAffineTransform transform];
    w2vScale = [NSAffineTransform transform];
    
    // Dimensione bottoni della dock, spessore line del disegno interno. Rotondità tasti.
    cellsize = NSMakeSize(32, 32);
    linewidth = (cellsize.width + cellsize.height) / 32;
    if (linewidth < 1) { linewidth = 1; }
    roundness = 8;
    
    thisIsANewLine = YES;
    dirtyRect = NSMakeRect(0, 0, 1, 1);
}


- (void) setFrameSize:(NSSize)newSize {
    
    #ifdef DEBUGMATRIX
    NSLog(@"myView:setFrameSize");
    #endif
    
    // Voglio utilizzare il centro della vista come punto di ancoraggio: calcolo la posizione del centro per entrambi i frame (corrente e futuro) e passo la differenza alla funzione di traslazione, penserà lei alla scalatura.
    NSPoint pview_before = NSMakePoint(self.frame.origin.x + self.frame.size.width / 2,
                                self.frame.origin.y + self.frame.size.height / 2);
    NSPoint pview_after = NSMakePoint(self.frame.origin.x + newSize.width / 2,
                                      self.frame.origin.y + newSize.height / 2);

    NSSize diff = NSMakeSize(pview_after.x - pview_before.x, pview_after.y - pview_before.y);

    [self move:NO translation:diff];

    [super setFrameSize:newSize];
    
}

- (NSRect)computeRect:(NSPoint)p1 secondPoint:(NSPoint)p2 moveBorder:(CGFloat)border {
    
    NSPoint bb = [w2vScale transformPoint:NSMakePoint(border, border)];
    CGFloat borderscaled = bb.x;
    
    CGFloat x = fmin(p1.x, p2.x) - borderscaled; CGFloat y = fmin(p1.y, p2.y) - borderscaled;
    CGFloat raww = p2.x - p1.x; CGFloat rawh = p2.y - p1.y;
    CGFloat w = fabs(raww) + 2*borderscaled; CGFloat h = fabs(rawh) + 2*borderscaled;
    
    return NSMakeRect(x, y, w, h);
}


- (void)addEmptyLine {
    // Aggiorno l'array di linee con una vuota e l'array per la cronologia delle linee
    NSMutableArray * line = [[NSMutableArray alloc] init];
    [linesContainer addObject:line];
}


- (CGFloat)distanceBetweenPoint:(NSPoint)p1 andPoint:(NSPoint)p2 {
    CGFloat dX = abs(p1.x - p2.x);
    CGFloat dY = abs(p1.y - p2.y);
    CGFloat d = sqrt((dX*dX) + (dY*dY)); ///// TODO migliora!
    
    return d;
}


- (void)addPointToLatestLine:(NSPoint*)p {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        NSInteger last = [linesContainer count] - 1;
        [linesContainer[last] addObject:pobj];
    }
    else
        errno = EINVAL;
}


- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx {
    if (p != NULL) {
        DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
        [linesContainer[idx] addObject:pobj];
    }
    else
        errno = EINVAL;
}


- (void)addLineToHistory {
    if (!thisIsANewLine) {
        NSInteger idxline = (NSInteger) nearpointIdx.x;
        NSInteger idxstart = (NSInteger) nearpointIdx.y;
        NSMutableArray * thisline = linesContainer[idxline];
        NSInteger lastpointidx = [thisline count] - 1;
        DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
        [linesHistory addObject:idxs];
    }
    else {
        NSInteger lastlineidx = [linesContainer count] - 1;
        NSInteger lastpointidx = [linesContainer[lastlineidx] count] - 1;
        DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
        [linesHistory addObject:idxs];
    }
}


- (void)removeLatestLine {
    if ([linesHistory count] > 0) {
        
        #ifdef DEBUGLINESHIST
        NSLog(@"removeLatestLine: c'è una limea da rimuovere");
        #endif
        
        DRRSegmentIdx * idxs = [linesHistory lastObject];
        NSMutableArray * line = linesContainer[idxs.idxline];
        NSInteger i = 0;
        NSMutableArray * dirtyPoints = [[NSMutableArray alloc] init];
        
        // Rimuovo un punto alla volta dall'array di linee e creo un array con quei punti per poi creare il rettangolo da ridisegnare
        for (i = idxs.idxendpt; i > idxs.idxstartpt; i--) {
            [dirtyPoints addObject:line[i]];
            [line removeObjectAtIndex:i];
        }
        // lo aggiungo sempre perchè devo ridisegnare anche il pezzo di linea che si unisce a quella precedente, se c'è
        [dirtyPoints addObject:line[idxs.idxstartpt]];
        // Non ho rimosso subito il punto di indice idxstartpt perchè se è una linea doppia allora quel punto serve per la linea dei punti di indici precedenti
        if (idxs.idxstartpt == 0) {
            [line removeObjectAtIndex:0];
        }
        
        if ([line count] == 0) {
            [linesContainer removeObjectAtIndex:idxs.idxline];
        }
        
        [linesHistory removeLastObject];
        
        [self setNeedsDisplay];
//        [self setNeedsDisplayInRect:[self computeRectFromArray:dirtyPoints moveBorder:1]]; //TODO sarà più veloce calcolare il rettangolo o ridisegnare tutto?
    }
    
    #ifdef DEBUGLINESHIST
    else
        NSLog(@"removeLatestLine: Nessuna una limea da rimuovere");
    #endif
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


//- (IBAction)cellPressed:(id)sender {   [sender setState:NSOnState]; }
//- (IBAction)cellPressedNoMore:(id)sender { [sender setState:NSOffState]; }

- (void)move:(BOOL)invalidate translation:(NSSize)mstep {
    NSPoint pview = self.frame.origin;
    NSPoint pworld = [v2wTrans transformPoint:[v2wScale transformPoint:pview]];
    NSPoint pviewmoved = NSMakePoint(pview.x + mstep.width, pview.y + mstep.height);
    NSPoint pworldmoved = [v2wTrans transformPoint:[v2wScale transformPoint:pviewmoved]];
    
    NSSize diff = NSMakeSize(pworldmoved.x - pworld.x, pworldmoved.y - pworld.y);
    
    [w2vTrans translateXBy:diff.width yBy:diff.height];
    [v2wTrans translateXBy:(-1 * diff.width) yBy:(-1 * diff.height)];
    
    if (invalidate)
        [self setNeedsDisplay];
}

- (BOOL)scale:(CGFloat)sstep maxZoom:(CGFloat)upperbound minZoom:(CGFloat)lowerbound {
    
    BOOL reachedUpperB = NO;
    BOOL reachedLowerB = NO;
    NSPoint scalefactor = [w2vScale transformPoint:NSMakePoint(sstep, sstep)];
    
    if (scalefactor.x >= upperbound)
        reachedUpperB = YES;
    else if (scalefactor.x <= lowerbound)
        reachedLowerB = YES;
    
    if ( (!reachedUpperB && !reachedLowerB) || (reachedUpperB && (sstep < 1)) || (reachedLowerB && (sstep > 1)) ) {
//        NSPoint pview = NSMakePoint(self.frame.origin.x + self.frame.size.width / 2,
//                                    self.frame.origin.y + self.frame.size.height / 2);
//        NSPoint pworld_before = [v2wScale transformPoint:pview];
//        
//        [w2vScale scaleBy:sstep];
//        [v2wScale scaleBy:(1 / sstep)];
//        
//        NSPoint pworld_after = [v2wScale transformPoint:pview];
//        NSSize diff = NSMakeSize(pworld_after.x - pworld_before.x, pworld_after.y - pworld_before.y);

        // Siccome la funzione di traslazione della matrice tiene conto della scalatura passando due paia di coordinate in coordinate mondo, allora passo alla funzione lo spostamento del centro con la scalatura in coordinate vista.
        NSPoint pview = NSMakePoint(self.frame.origin.x + self.frame.size.width / 2,
                                    self.frame.origin.y + self.frame.size.height / 2);
        NSPoint pworld = [v2wScale transformPoint:pview];

        [w2vScale scaleBy:sstep];
        [v2wScale scaleBy:(1 / sstep)];

        NSPoint pview_after = [w2vScale transformPoint:pworld];
        NSSize diff = NSMakeSize(pview.x - pview_after.x, pview.y - pview_after.y);

        
        
        [self move:NO translation:diff];
        
        [self setNeedsDisplay];
        
        return YES;
    }
    
    return NO;
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDown");
    #endif
    
    leftpressed = YES;
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview = [self convertPoint:pwindow fromView:nil];
//    NSPoint pbaseview = [w2v transformPoint:pview];
    NSPoint pworld = [v2wScale transformPoint:pview];
    pworld = [v2wTrans transformPoint:pworld];
    
    DRRButton * btn = [dock selectedCell];
    
    if (btn == btnDrawFree || btn == btnDrawLine) {

        if (customCursor != DRAW) {
            [[NSCursor arrowCursor] set];
            customCursor = DRAW;
//            customCursorNext = DRAW;
        }
        
        // controllo se il mouse è vicino ad un punto precedente...
        nearpointIdx = findAdiacentVertex(linesContainer, pworld);
        
        // ...si! Ancoro la nuova linea a quella.
        if (nearpointIdx.x != ARGERROR && nearpointIdx.x != NOTFOUND) {
            
            #ifdef DEBUGLINES
            NSLog(@"Trovato punto di ancoraggio");
            #endif
            
            thisIsANewLine = NO;
            NSPoint nearpoint = [linesContainer[(NSInteger)nearpointIdx.x][(NSInteger)nearpointIdx.y] getPoint];
            
            prevmouseXY = [w2vTrans transformPoint:nearpoint];
            prevmouseXY = [w2vScale transformPoint:prevmouseXY];
            
            // sposto il puntatore del mouse nella nuova posizione (coordinate schermo)
            NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
            NSPoint nearpointview = [w2vTrans transformPoint:nearpoint];
            nearpointview = [w2vScale transformPoint:nearpointview];
            NSPoint newpos = NSMakePoint(frameRelativeToScreen.origin.x + nearpointview.x,
                                         (screenRect.size.height) - (frameRelativeToScreen.origin.y + nearpointview.y));
            CGWarpMouseCursorPosition(newpos);
//            NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
//            NSPoint newpos = NSMakePoint(frameRelativeToScreen.origin.x + nearpoint.x,
//                                         (screenRect.size.height) - (frameRelativeToScreen.origin.y + nearpoint.y));
//            CGWarpMouseCursorPosition(newpos);
        }
        
        // ...no! Aggiungo una nuova linea e il punto ad essa. Includo il caso in cui la funzione abbia restituito un errore per camuffarlo a runtime
        else {
            thisIsANewLine = YES;
            prevmouseXY = pwindow;
            
            [self addEmptyLine];
            [self addPointToLatestLine:(&pworld)];
            
            if (nearpointIdx.x == ARGERROR)
                perror("myViewController: mouseDown: findAdiacentVertex");
        }
        
        if (btn == btnDrawLine) {
            prevTempPoint = pworld;
            tempPoint = pworld;
        }
        
    } // fine btnDrawFree || btnDrawLine
    
    else if (btn == btnPan) {
        if (customCursor != PANACTIVE) {
            [[NSCursor closedHandCursor] set];
            customCursor = PANACTIVE;
//            customCursorNext = PANACTIVE;
        }
        
        prevmouseXY = pwindow;
    }
    
    else if (btn == btnZoom) {
        if (customCursor != ZOOM) {
            [[NSCursor resizeUpDownCursor] set];
            customCursor = ZOOM;
//            customCursorNext = ZOOM;
        }
        
        prevmouseXY = pwindow;
    }
    
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    [self setNeedsDisplayInRect:NSMakeRect(self.frame.size.width - 55, 0, self.frame.size.width, 50)];
    #endif
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDragged");
    #endif
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    NSPoint pworld = [v2wScale transformPoint:pview];
    pworld = [v2wTrans transformPoint:pworld];
//    NSPoint pbaseview = [w2v transformPoint:pview];
    
    DRRButton * btn = [dock selectedCell];
    
    if (btn == btnDrawFree) {
        
        // Voglio evitare di avere troppi punti molto vicini, controllo la distanza tra questo punto e il precedente
        NSPoint prevmouseXYworld = [v2wTrans transformPoint:[v2wScale transformPoint:prevmouseXY]];
        CGFloat d = [self distanceBetweenPoint:prevmouseXYworld andPoint:pworld];
        
        if (d > 7) {
            atLeastOneStroke = YES;
            
            // Devo aggiungere i punti alla linea ancorata nella mouseDown senza crearne una nuova
            if (!thisIsANewLine)
                [self addPointToIdxLine:(&pworld) idxLinesArray:nearpointIdx.x];
            // Creo nuova linea.
            else
                [self addPointToLatestLine:(&pworld)];
            
            dirtyRect = [self computeRect:prevmouseXY secondPoint:pwindow moveBorder:1];
            [self setNeedsDisplayInRect:dirtyRect];
            
            prevmouseXY = pwindow;
        }
        
        else {
            #ifdef DEBUGLINES
            NSLog(@"Punto troppo vicino, lo ignoro");
            #endif
        }
        
    } // fine btnDrawFree
    
    else if (btn == btnDrawLine) {
        
        NSPoint prevmouseXYworld = [v2wTrans transformPoint:[v2wScale transformPoint:prevmouseXY]];
        CGFloat d = [self distanceBetweenPoint:prevmouseXYworld andPoint:pworld];
        if (d > 7) {
            prevTempPoint = tempPoint;
            tempPoint = pworld;
            validLine = YES;
        }
        else
            validLine = NO;

        NSPoint prevTempPointview = [w2vScale transformPoint:[w2vTrans transformPoint:prevTempPoint]];
        NSPoint tempPointview = [w2vScale transformPoint:[w2vTrans transformPoint:tempPoint]];
        
        CGRect r1 = NSRectToCGRect([self computeRect:prevmouseXY secondPoint:prevTempPointview moveBorder:1]);
        CGRect r2 = NSRectToCGRect([self computeRect:prevmouseXY secondPoint:tempPointview moveBorder:1]);
        dirtyRect = NSRectFromCGRect(CGRectUnion(r1, r2));
        [self setNeedsDisplayInRect:dirtyRect];
        
    } // fine btnDrawLine
    
    else if (btn == btnPan) {
//        if (customCursor == PANACTIVE) {
//            [[NSCursor closedHandCursor] set];
//            customCursor = PANWAIT;
//            customCursorNext = PANWAIT;
//        }
        
        NSSize diff = NSMakeSize(pwindow.x - prevmouseXY.x, pwindow.y - prevmouseXY.y);
        
        [self move:YES translation:diff];
        
        prevmouseXY = pwindow;
    }
    
    else if (btn == btnZoom) {

        CGFloat diff = pwindow.y - prevmouseXY.y;
        CGFloat s = 1;
        
        if (abs(diff) > 1) {
            
            if (diff > 0) {
                if (customCursor != ZOOMIN) {
                    [[NSCursor resizeUpCursor] set];
                    customCursor = ZOOMIN;
                }
                
                s = 1 + (diff * 0.005);
            }
            else {
                if (customCursor != ZOOMOUT) {
                    [[NSCursor resizeDownCursor] set];
                    customCursor = ZOOMOUT;
                }
                
                s = 1 - (diff * -1 * 0.005);
            }
            
            BOOL hasScaled = [self scale:s maxZoom:maxZoomFactor minZoom:minZoomFactor];
            
            if (!hasScaled) {
                [[NSCursor resizeUpDownCursor] set];
                customCursor = ZOOM;
            }
            
            prevmouseXY = pwindow;
            
        }
        
        
//            customCursorNext = ZOOM;
    }
    
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    [self setNeedsDisplayInRect:NSMakeRect(self.frame.size.width - 55, 0, self.frame.size.width, 50)];
    #endif

}


- (void)mouseUp:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseUp");
    #endif
    
    leftpressed = NO;
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    NSPoint pworld = [v2wScale transformPoint:pview];
    pworld = [v2wTrans transformPoint:pworld];
//    NSPoint pbaseview = [w2v transformPoint:pview];
    
    DRRButton * btn = [dock selectedCell];
    
    if (btn == btnDrawFree) {
        
        // Se è stato disegnato almeno un pezzo di linea allora lo aggiungo alla cronologia...
        if (atLeastOneStroke) {
            if (!thisIsANewLine) {
                NSInteger idxline = (NSInteger) nearpointIdx.x;
                NSInteger idxstart = (NSInteger) nearpointIdx.y;
                NSMutableArray * thisline = linesContainer[idxline];
                NSInteger lastpointidx = [thisline count] - 1;
                DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
                [linesHistory addObject:idxs];
            }
            else {
                NSInteger lastlineidx = [linesContainer count] - 1;
                NSInteger lastpointidx = [linesContainer[lastlineidx] count] - 1;
                DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
                [linesHistory addObject:idxs];
            }
            atLeastOneStroke = NO;
        }
        
        // altrimenti, solo se stavo disegnando una nuova linea, rimuovo quel punto dall'array linesContainer
        else if (thisIsANewLine) {
            [linesContainer removeLastObject];
        }
        
    }
    
    else if (btn == btnDrawLine) {
        
        if (validLine) {
            // Devo aggiungere i punti alla linea ancorata nella mouseDown senza crearne una nuova oppure creare una nuova linea e aggiungerla alla cronologia
            if (!thisIsANewLine) {
                [self addPointToIdxLine:(&pworld) idxLinesArray:nearpointIdx.x];
                
                NSInteger idxline = (NSInteger) nearpointIdx.x;
                NSInteger idxstart = (NSInteger) nearpointIdx.y;
                NSMutableArray * thisline = linesContainer[idxline];
                NSInteger lastpointidx = [thisline count] - 1;
                DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
                [linesHistory addObject:idxs];
            }
            
            else {
                [self addPointToLatestLine:(&pworld)];
                
                NSInteger lastlineidx = [linesContainer count] - 1;
                NSInteger lastpointidx = [linesContainer[lastlineidx] count] - 1;
                DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
                [linesHistory addObject:idxs];
            }
            
            dirtyRect = [self computeRect:prevmouseXY secondPoint:pwindow moveBorder:1];
            validLine = NO;
            [self setNeedsDisplayInRect:dirtyRect];
        }
        
        // altrimenti, solo se stavo disegnando una nuova linea, rimuovo quel punto dall'array linesContainer
        else if (thisIsANewLine) {
            [linesContainer removeLastObject];
        }
        
    }
    
    else if (btn == btnPan) {
        customCursor = PANWAIT;
        [[NSCursor openHandCursor] set];
    }
    
    else if (btn == btnZoom) {
        customCursor = ZOOM;
        [[NSCursor resizeUpDownCursor] set];
    }
    
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    [self setNeedsDisplayInRect:NSMakeRect(self.frame.size.width - 55, 0, self.frame.size.width, 50)];
    #endif
    
}


- (void)rightMouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+rightMouseDown");
    #endif
    
    if (!leftpressed) {
        rightpressed = YES;
        //TODO
    }
}


- (void)rightMouseUp:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+rightMouseUp");
    #endif
    
    if (rightpressed) {
        [self removeLatestLine];
//        [self setNeedsDisplay]; // TODO setneedsdisplay sarebbe meglio più selettivo, chiamato dalla remove
        rightpressed = NO;
    }
}


//- (void)setNeedsDisplay {
//    [super setNeedsDisplay];
////    [dock setNeedsDisplay];
//}


//- (void)setNeedsDisplayInRect:(NSRect)invalidRect {
//    [super setNeedsDisplayInRect:invalidRect];
//    
////    if (CGRectIntersectsRect(dock.frame, invalidRect)) {
////        [dock setNeedsDisplayInRect:invalidRect];
////    }
////    if ([dock]) {
////        [dock setNeedsDisplayInRect:invalidRect];
////    }
//
//}


//- (void)updateCursorM {
//    
//    DRRButton * btn = [dock selectedCell];
//    
//    if (btn == btnDrawFree) {
//        if (customCursor != DRAW) {
//        [[NSCursor arrowCursor] set];
//        customCursor = DRAW;
////        customCursorNext = DRAW;
//        }
//    }
//    
//    else if (btn == btnPan) {
//        if (customCursor != PANWAIT) {
//            [[NSCursor openHandCursor] set];
//            customCursor = PANWAIT;
////            customCursorNext = PANACTIVE;
//        }
//    }
//    
//    else if (btn == btnZoom) {
//        if (customCursor != ZOOM) {
//            [[NSCursor resizeUpDownCursor] set];
//            customCursor = ZOOM;
////            customCursorNext = ZOOM;
//        }
//    }
//
//}


- (BOOL)inLiveResize {
    BOOL isInLive = [super inLiveResize];
    if (!isInLive) {
        if (viewPrevResizeWasInLive) {
            viewPrevResizeWasInLive = NO;
            [self setNeedsDisplay];
        }
    }
    else
        viewPrevResizeWasInLive = YES;
    
    return isInLive;
}


- (void)drawRect:(NSRect)dirtRect {
    
    #ifdef DEBUGDRAW
    NSRect r = dirtRect;
    NSLog(@"-drawRect myView: o:%f^%f s:%f^%f", r.origin.x, r.origin.y,
                                                  r.size.width, r.size.height);
    #endif
    #ifdef DEBUGLINES
    pathSinglePoint = [NSBezierPath bezierPath];
    #endif

//    DRRButton * btn = [dock selectedCell];
    
//    if (btn == btnPan) {
//        if (leftpressed)
//            [[NSCursor closedHandCursor] set];
//        else
//            [[NSCursor openHandCursor] set];
//    }
//    else if (btn == btnZoom) {
//        [[NSCursor resizeUpDownCursor] set];
//    }
    
    [w2vScale concat];
    [w2vTrans concat];
    
    [[NSColor blackColor] set];
    
    if ([self inLiveResize]) {
        [[NSGraphicsContext currentContext] setShouldAntialias: NO];
        [pathLines setLineWidth: 1.2];
    }
    else
        [pathLines setLineWidth: 2];
    
    // per ogni linea del contenitore creo un path con NSBezierPath
    if ([linesContainer count] > 0) {
        [linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger iline, BOOL *stop1) {
            if ([line count] > 0) {
                // aggiungo ogni punto della linea al path
                [line enumerateObjectsUsingBlock:^(id point, NSUInteger ipoint, BOOL *stop2) {
                    NSPoint p = [point getPoint];
                    #ifdef DEBUGLINES
                    [pathSinglePoint appendBezierPathWithOvalInRect:NSMakeRect(p.x - 2, p.y - 2, 4, 4)];
                    #endif
                    
                    if (ipoint == 0)
                        [pathLines moveToPoint:p];
                    else
                        [pathLines lineToPoint:[point getPoint]];
                }];
                
                [[NSColor blackColor] set];
                [pathLines stroke];
                [pathLines removeAllPoints];
                
                #ifdef DEBUGLINES
                [[NSColor redColor] set]; [pathSinglePoint fill]; [pathSinglePoint removeAllPoints];
                #endif
            }
        }];
    }
    
    // disegno la linea retta temporanea
    if (validLine) {
        NSBezierPath * tempLine = [[NSBezierPath alloc] init];
        [tempLine setLineWidth:2];
        [[NSColor lightGrayColor] set];
        [tempLine moveToPoint:[v2wTrans transformPoint:[v2wScale transformPoint:prevmouseXY]]];
        [tempLine lineToPoint:tempPoint];
        [tempLine stroke];
    }
    
    [v2wTrans concat];
    [v2wScale concat];
    
    // DEBUG: scrivo il numero di elementi nell'array delle linee e in quello della cronologia
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    NSInteger lCont_len = [linesContainer count]; NSInteger lHist_len = [linesHistory count];
    NSString * lCont_str = [NSString stringWithFormat:@"%li", (long)lCont_len];
    NSString * lHist_str = [NSString stringWithFormat:@"%li", (long)lHist_len];
    [lCont_str drawInRect:NSMakeRect(self.frame.size.width - 52, 0, 20, 15) withAttributes:attr];
    [lHist_str drawInRect:NSMakeRect(self.frame.size.width - 22, 0, 40, 15) withAttributes:attr];
    #endif
    
//    if (CGRectIntersectsRect(dock.frame, dirtyRect)) {
//        [dock drawCellInside:[dock cellAtRow:0 column:0]];
//        [dock drawCellInside:[dock cellAtRow:0 column:1]];
    
//        [dock setNeedsDisplay:YES];
//        [dock selectCellAtRow:0 column:0];
//        [dock updateCell:[dock cellAtRow:0 column:0]];
//    }

//    [self setNeedsDisplayInRect:[controls[0] frame]];
//    [self updateCell:controls[0]];
//    [controls[0] drawFrame:[controls[0] frame] inView:self];
//    [self drawCellInside:btn1];
    
}

@end





