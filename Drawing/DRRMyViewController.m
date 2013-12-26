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


@implementation DRRMyViewController

- (id)initWithFrame:(NSRect)frameRect {
    
    #ifdef DEBUGINIT
    NSLog(@"initWithFrame myView");
    #endif

    self = [super initWithFrame:frameRect];
    if (self) {
        
//        controls = [[NSMutableArray alloc] init];
        
//        ctrlsz = NSRegularControlSize;
        
        
        
        [self setItemPropertiesToDefault]; ///// TODO proprietà?
    }
    return self;
}

- (void)awakeFromNib {
    
    #ifdef DEBUGINIT
    NSLog(@"awakeFromNib myView");
    #endif
    
    [super awakeFromNib];
    [self setItemPropertiesToDefault];
    viewPrevResizeWasInLive = NO;
    
    dock = [[DRRDock alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)
                                     mode:NSRadioModeMatrix
                                cellClass:[DRRButton class]
                             numberOfRows:1
                          numberOfColumns:2];
    [dock setCellSize:cellsize];
    
    cellpaths = [[NSMutableArray alloc] init];
    cellmodes = [[NSMutableArray alloc] init];
    makeDrawFreeButton(NSMakeRect(dock.frame.origin.x, dock.frame.origin.y, dock.cellSize.width, dock.cellSize.height), roundness, linewidth, cellpaths, cellmodes);
    DRRButton * btnDrawFree = [[DRRButton alloc] initWithPaths:cellpaths typeOfDrawing:cellmodes];
    
//    NSArray * array = [NSArray arrayWithObjects:btnDrawFree, btnDrawLine, nil];
//    [dock addRowWithCells:array];
    [dock putCell:btnDrawFree atRow:0 column:0];
    [dock sizeToCells];
    
    NSMutableArray * cp = [[NSMutableArray alloc] init];
    NSMutableArray * cm = [[NSMutableArray alloc] init];
    makeDrawLine(NSMakeRect(dock.frame.origin.x + (1 * dock.cellSize.width), dock.frame.origin.y + 1 * dock.cellSize.height, dock.cellSize.width, dock.cellSize.height), roundness, linewidth, cp, cm);
    DRRButton * btnDrawLine = [[DRRButton alloc] initWithPaths:cp typeOfDrawing:cm];
    [dock putCell:btnDrawLine atRow:0 column:1];
    [dock sizeToCells];
    
//    DRRButton * a1 = [dock cellAtRow:0 column:0];
//    DRRButton * a2 = [dock cellAtRow:0 column:1];
//    
//    NSArray * aaaa;
//    NSLog(@"pippi");
//    cellpaths = [[NSMutableArray alloc] init];
//    cellmodes = [[NSMutableArray alloc] init];
    
//    [dock putCell:btnDrawLine atRow:0 column:1];

    
    [self addSubview:dock];
//    [dock updateCell:[dock cellAtRow:0 column:0]];
//    [dock updateCell:[dock cellAtRow:0 column:1]];
//    [self setNeedsDisplay:YES];
//    [dock setNeedsDisplay:YES];

    
    //    NSCell * btnDrawLine = [[DRRbuttonDrawLine alloc] init];
    //    NSCell * btnMoveView = [[DRRbuttonMoveView alloc] init];
    //    NSCell * btnPlay = [[DRRbuttonDrawPlay alloc] init];
    //    NSCell * btnZoomSlider = [[DRRbuttonZoomSlider alloc] init];
    
//    
  
    
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    #ifdef DEBUGINIT
    NSLog(@"initWithCoder myView");
    #endif
    
    self = [super initWithCoder:aDecoder];
//    if (self) { }
    return self;
}

- (void)setItemPropertiesToDefault {
    #ifdef DEBUGINIT
    NSLog(@"setItemProperties myView");
    #endif
    
    // inizializzo l'array di linee disegnate e le proprietà
    linesContainer = [[NSMutableArray alloc] init];
    linesHistory = [[NSMutableArray alloc] init];
    pathLines = [NSBezierPath bezierPath];
    
    screenRect = [[NSScreen mainScreen] frame];
    
    // Dimensione bottoni della dock, spessore line del disegno interno. Rotondità tasti.
    cellsize = NSMakeSize(32, 32);
    linewidth = (cellsize.width + cellsize.height) / 32;
    if (linewidth < 1) { linewidth = 1; }
    roundness = 5;
    
    thisIsANewLine = YES;
    dirtyRect = NSMakeRect(0, 0, 1, 1);
}


- (NSRect)computeRect:(NSPoint)p1 secondPoint:(NSPoint)p2 moveBorder:(CGFloat)border {
    
    CGFloat x = MIN(p1.x, p2.x) - border; CGFloat y = MIN(p1.y, p2.y) - border;
    CGFloat raww = p2.x - p1.x; CGFloat rawh = p2.y - p1.y;
    CGFloat w = fabs(raww) + 2*border; CGFloat h = fabs(rawh) + 2*border;
    
    return NSMakeRect(x, y, w, h);
}


- (NSRect)computeRectFromArray:(NSMutableArray *)points moveBorder:(CGFloat)border {
    
    if (points != NULL) {
        NSInteger ptlen = [points count];
        switch (ptlen) {
            // 0 punti nell'array, ritorno un rettangolo vuoto
            case 0:
                NSLog(@"computeRectFromArray: l'array era vuoto, l'NSRect avrà componenti nulle");
                return NSMakeRect(0, 0, 0, 0);
                break;
            // Ritorno un rettangolo che contiene quel punto
            case 1: {
                NSPoint pt = [(DRRPointObj *) [points firstObject] getPoint];
                return NSMakeRect(pt.x - 1 - border, pt.y - 1 - border, pt.x + 1 + 2*border, pt.y + 1 + 2*border);
                break;
            }
            default: {
                NSPoint pt0 = [(DRRPointObj *) [points firstObject] getPoint];
                NSPoint pt1 = [(DRRPointObj *) [points objectAtIndex:1] getPoint];
                NSRect rect = [self computeRect:pt0 secondPoint:pt1 moveBorder:border];
                NSInteger i = 2;
                
                // se ho solo due punti mi fermo qui
                if (ptlen == 2)
                    return rect;
                
                // Per ogni punto oltre il secondo guardo se sta fuori o dentro il mio rettangolo e controllo una coordinata per volta
                for (i = 2; i < ptlen; i++) {
                    NSPoint pt = [(DRRPointObj *) [points objectAtIndex:i] getPoint];
                    
                    if ((rect.origin.x + rect.size.width) < pt.x)
                        rect.size.width = pt.x - rect.origin.x;
                    else if ((rect.origin.x) > pt.x)
                        rect.origin.x = pt.x;
                    
                    if ((rect.origin.y + rect.size.height) < pt.y)
                        rect.size.height = pt.y - rect.origin.y;
                    else if ((rect.origin.y) > pt.y)
                        rect.origin.y = pt.y;
                }
                ///// FIXME non funziona credo... nella rightmouseup nella removepoint chiamo questa ma non aggiorna la linea...
                
                return rect;
                break;
            }
        } // fine switch
    }
    else {
        NSLog(@"computeRectFromArray: puntatore array null, l'NSRect avrà componenti nulle");
        errno = EINVAL;
        return NSMakeRect(0, 0, 0, 0);
    }
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


- (void)removeLatestLine {
    if ([linesHistory count] > 0) {
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
//        }
        
        [linesHistory removeLastObject];
        
        // Invalido il contesto grafico nel rettanglo che contiene la linea
//        [self setNeedsDisplayInRect:[self computeRectFromArray:dirtyPoints moveBorder:2]];
        // TODO sarà più veloce calcolare il rettangolo o ridisegnare tutto?
    }
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

- (void)mouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDown");
    #endif
    leftpressed = YES;
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
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
                                     (screenRect.size.height) - (frameRelativeToScreen.origin.y + nearpoint.y));
        CGWarpMouseCursorPosition(newpos);
    }
    
    // ...no! Aggiungo una nuova linea e il punto ad essa. Includo il caso in cui la funzione abbia restituito un errore per camuffarlo a runtime
    else {
        thisIsANewLine = YES;
        prevmouseXY = pwindow;
        
        [self addEmptyLine];
        [self addPointToLatestLine:(&pview)];
        
        if (nearpointIdx.x == ARGERROR)
            perror("myViewController: mouseDown: findAdiacentVertex");
    }
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDragged");
    #endif
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    // Voglio evitare di avere troppi punti molto vicini, controllo la distanza tra questo punto e il precedente
    CGFloat d = [self distanceBetweenPoint:prevmouseXY andPoint:pview];
    
    if (d > 7) {
        atLeastOneStroke = YES;
        
        // Devo aggiungere i punti alla linea ancorata nella mouseDown senza crearne una nuova
        if (!thisIsANewLine)
            [self addPointToIdxLine:(&pview) idxLinesArray:nearpointIdx.x];
        // Creo nuova linea.
        else
            [self addPointToLatestLine:(&pview)];
        
        dirtyRect = [self computeRect:prevmouseXY secondPoint:pwindow moveBorder:2];
        [self setNeedsDisplayInRect:dirtyRect];
        
        #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
        [self setNeedsDisplayInRect:NSMakeRect(self.frame.size.width - 55, 0, self.frame.size.width, 50)];
        #endif
        
        prevmouseXY = pwindow;
    }
    
    else {
        #ifdef DEBUGLINES
        NSLog(@"Punto troppo vicino, lo ignoro");
        #endif
    }

}


- (void)mouseUp:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseUp");
    #endif
    
    leftpressed = NO;
//    NSPoint pwindow = [theEvent locationInWindow];
//    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
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
    }
    
    // altrimenti, solo se stavo disegnando una nuova linea, rimuovo quel punto dall'array linesContainer
    else if (thisIsANewLine) {
        [linesContainer removeLastObject];
    }
    
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    [self setNeedsDisplayInRect:NSMakeRect(self.frame.size.width - 55, 0, self.frame.size.width, 50)];
    #endif
    
//    thisIsANewLine = YES;
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
        // setNeedsDisplay chiamato da questo metodo
        [self removeLatestLine];
        [self setNeedsDisplay];
        rightpressed = NO;
    }
}


- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    [dock setNeedsDisplay];
}


- (void)setNeedsDisplayInRect:(NSRect)invalidRect {
    [super setNeedsDisplayInRect:invalidRect];
    
    if (CGRectIntersectsRect(dock.frame, invalidRect)) {
        [dock setNeedsDisplayInRect:invalidRect];
    }
}


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


- (void)drawRect:(NSRect)dirtyRect {
    
    #ifdef DEBUGDRAW
    NSLog(@"-drawRect myView");
    #endif
    #ifdef DEBUGLINES
    pathSinglePoint = [NSBezierPath bezierPath];
    #endif

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
    
//    [dock setBackgroundColor:[NSColor lightGrayColor]];
//    [dock setDrawsBackground:YES];
    
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





