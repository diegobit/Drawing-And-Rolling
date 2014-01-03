//
//  DRRDock.m
//  Drawing
//
//  Created by Diego Giorgini on 14/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRDock.h"

@implementation DRRDrawingProperties

+ (DRRDrawingProperties *)initWithColor:(NSColor *)color drawingMode:(drawingmode_t)mode {
    DRRDrawingProperties * obj = [[DRRDrawingProperties alloc] init];
    if (obj) {
        [obj setColor:color];
        [obj setDrawingMode:mode];
    }
    return obj;
}

- (id)init {
    self = [super init];
    return self;
}

@end


@implementation DRRPathObj

- (id)initWithPath:(NSBezierPath *)p {
    self = [super init];
    if (self) {
        self.path = p;
    }
    return self;
}
//- (NSBezierPath *)getPoint;
//- (void)setPath:(NSBezierPath *)p;

@end



void makeDrawFreeButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {

    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * pencilpoint = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
    NSPoint bottomLeftL = NSMakePoint(frame.origin.x + frame.size.width * 0.20,
                                      frame.origin.y + frame.size.height * 0.75);
    NSPoint topRightL = NSMakePoint(frame.origin.x + frame.size.width * 0.75,
                                    frame.origin.y + frame.size.height * 0.20);
    NSPoint bottomControlL = NSMakePoint(frame.origin.x + frame.size.width * 0.30,
                                         frame.origin.y + frame.size.height * 0.35);
    NSPoint topControlL = NSMakePoint(frame.origin.x + frame.size.width * 0.65,
                                      frame.origin.y + frame.size.height * 0.65);
    
    NSPoint bottomLeftR = NSMakePoint(frame.origin.x + frame.size.width * 0.25,
                                      frame.origin.y + frame.size.height * 0.80);
    NSPoint topRightR = NSMakePoint(frame.origin.x + frame.size.width * 0.80,
                                    frame.origin.y + frame.size.height * 0.25);
    NSPoint bottomControlR = NSMakePoint(frame.origin.x + frame.size.width * 0.35,
                                         frame.origin.y + frame.size.height * 0.40);
    NSPoint topControlR = NSMakePoint(frame.origin.x + frame.size.width * 0.70,
                                      frame.origin.y + frame.size.height * 0.70);
    
    // Path matita
    [pencilpoint moveToPoint:bottomLeftL];
    [pencilpoint curveToPoint:topRightL controlPoint1:bottomControlL controlPoint2:topControlL];
    [pencilpoint lineToPoint:topRightR];
    [pencilpoint curveToPoint:bottomLeftR controlPoint1:topControlR controlPoint2:bottomControlR];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pencilpoint]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
}


void makeDrawLineButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * line = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
//    NSPoint bottom = NSMakePoint(frame.size.width * 0.22, frame.size.height * 0.77);
//    NSPoint top = NSMakePoint(frame.size.width * 0.88, frame.size.height * 0.23);
    NSPoint bottomleft = NSMakePoint(frame.origin.x + frame.size.width * 0.20, frame.origin.y + frame.size.height * 0.75);
    NSPoint bottomright = NSMakePoint(frame.origin.x + frame.size.width * 0.25, frame.origin.y + frame.size.height * 0.80);
    NSPoint topleft = NSMakePoint(frame.origin.x + frame.size.width * 0.75, frame.origin.y + frame.size.height * 0.20);
    NSPoint topright = NSMakePoint(frame.origin.x + frame.size.width * 0.80, frame.origin.y + frame.size.height * 0.25);
    
    // Path linea
    [line moveToPoint:bottomleft];
    [line lineToPoint:topleft];
    [line lineToPoint:topright];
    [line lineToPoint:bottomright];

    // Aggiungo i paths all'array paths e ad impostare le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:line]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
}

void makePanButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes) {
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * triangleLeft = [[NSBezierPath alloc] init];
    NSBezierPath * triangleTop = [[NSBezierPath alloc] init];
    NSBezierPath * triangleRight = [[NSBezierPath alloc] init];
    NSBezierPath * triangleBottom = [[NSBezierPath alloc] init];
    NSBezierPath * circle = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithOvalInRect:frame];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithOvalInRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness))];
    
    // Coordinate per l'interno
    NSPoint trLeftLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.14, frame.origin.y + frame.size.height * 0.50);
    NSPoint trLeftTop = NSMakePoint(frame.origin.x + frame.size.width * 0.27, frame.origin.y + frame.size.height * 0.37);
    NSPoint trLeftBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.27, frame.origin.y + frame.size.height * 0.63);
    
    NSPoint trTopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.36, frame.origin.y + frame.size.height * 0.27);
    NSPoint trTopTop = NSMakePoint(frame.origin.x + frame.size.width * 0.50, frame.origin.y + frame.size.height * 0.14);
    NSPoint trTopRight = NSMakePoint(frame.origin.x + frame.size.width * 0.63, frame.origin.y + frame.size.height * 0.27);
    
    NSPoint trRightBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.72, frame.origin.y + frame.size.height * 0.63);
    NSPoint trRightTop = NSMakePoint(frame.origin.x + frame.size.width * 0.72, frame.origin.y + frame.size.height * 0.37);
    NSPoint trRightRight = NSMakePoint(frame.origin.x + frame.size.width * 0.85, frame.origin.y + frame.size.height * 0.50);
    
    NSPoint trBottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.37, frame.origin.y + frame.size.height * 0.72);
    NSPoint trBottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.63, frame.origin.y + frame.size.height * 0.72);
    NSPoint trBottomBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.50, frame.origin.y + frame.size.height * 0.85);
    
    NSRect circleRect = NSMakeRect(frame.origin.x + frame.size.width * 0.40, frame.origin.y + frame.size.height * 0.40,
                               frame.size.width * 0.19, frame.size.height * 0.19);
    
    // Paths
    [triangleLeft moveToPoint:trLeftLeft];
    [triangleLeft lineToPoint:trLeftTop];
    [triangleLeft lineToPoint:trLeftBottom];
    
    [triangleTop moveToPoint:trTopLeft];
    [triangleTop lineToPoint:trTopTop];
    [triangleTop lineToPoint:trTopRight];
    
    [triangleRight moveToPoint:trRightBottom];
    [triangleRight lineToPoint:trRightTop];
    [triangleRight lineToPoint:trRightRight];
    
    [triangleBottom moveToPoint:trBottomLeft];
    [triangleBottom lineToPoint:trBottomRight];
    [triangleBottom lineToPoint:trBottomBottom];
    
    [circle appendBezierPathWithOvalInRect:circleRect];
    
    // Aggiungo i paths all'array paths e ad impostare le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleLeft]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleTop]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleRight]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleBottom]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:circle]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
}


void makeZoomButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes) {
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * lens = [[NSBezierPath alloc] init];
    NSBezierPath * innerLens = [[NSBezierPath alloc] init];
    NSBezierPath * handle = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithOvalInRect:frame];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithOvalInRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness))];
    
    // Coordinate per l'interno
    NSRect lensRect = NSMakeRect(frame.origin.x + frame.size.width * 0.22, frame.origin.y + frame.size.height * 0.22,
                                   frame.size.width * 0.38, frame.size.height * 0.38);
    NSRect innerLensRect = NSMakeRect(frame.origin.x + frame.size.width * 0.28, frame.origin.y + frame.size.height * 0.28,
                             frame.size.width * 0.26, frame.size.height * 0.26);
    NSPoint handleTopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.49, frame.origin.y + frame.size.height * 0.53);
    NSPoint handleTopRight = NSMakePoint(frame.origin.x + frame.size.width * 0.53, frame.origin.y + frame.size.height * 0.49);
    NSPoint handleBottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.74, frame.origin.y + frame.size.height * 0.70);
    NSPoint handleBottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.70, frame.origin.y + frame.size.height * 0.74);
    
    // Paths
    [lens appendBezierPathWithOvalInRect:lensRect];
    [innerLens appendBezierPathWithOvalInRect:innerLensRect];
    [handle moveToPoint:handleTopLeft];
    [handle lineToPoint:handleTopRight];
    [handle lineToPoint:handleBottomRight];
    [handle lineToPoint:handleBottomLeft];
//    [handle appendBezierPathWithArcFromPoint:handleBottomRight toPoint:handleBottomLeft radius:5];
    [handle lineToPoint:handleTopLeft];
    
    // Aggiungo i paths all'array paths e ad impostare le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:lens]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerLens]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:handle]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
}


void makeBackButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * arrow = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno.
    NSPoint arrowLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.18,
                                    frame.origin.y + frame.size.height * 0.38);
    NSPoint arrowTop = NSMakePoint(frame.origin.x + frame.size.width * 0.39,
                                   frame.origin.y + frame.size.height * 0.17);
    NSPoint arrowMiddleTop = NSMakePoint(frame.origin.x + frame.size.width * 0.40,
                                         frame.origin.y + frame.size.height * 0.28);
    NSPoint arrowMiddleTopCurve1 = NSMakePoint(frame.origin.x + frame.size.width * 0.70,
                                               frame.origin.y + frame.size.height * 0.30);
    NSPoint arrowMiddleTopCurve2 = NSMakePoint(frame.origin.x + frame.size.width * 0.94,
                                               frame.origin.y + frame.size.height * 0.48);
    NSPoint arrowTail = NSMakePoint(frame.origin.x + frame.size.width * 0.62,
                                    frame.origin.y + frame.size.height * 0.84);
    NSPoint arrowTailCurve1 = NSMakePoint(frame.origin.x + frame.size.width * 0.67,
                                               frame.origin.y + frame.size.height * 0.62);
    NSPoint arrowtailCurve2 = NSMakePoint(frame.origin.x + frame.size.width * 0.74,
                                               frame.origin.y + frame.size.height * 0.48);
    NSPoint arrowMiddleBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.40,
                                            frame.origin.y + frame.size.height * 0.48);
    NSPoint arrowBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.39,
                                      frame.origin.y + frame.size.height * 0.59);
    
    
    // Path matita
    [arrow moveToPoint:arrowLeft];
    [arrow lineToPoint:arrowTop];
    [arrow lineToPoint:arrowMiddleTop];
    [arrow curveToPoint:arrowTail controlPoint1:arrowMiddleTopCurve1 controlPoint2:arrowMiddleTopCurve2];
    [arrow curveToPoint:arrowMiddleBottom controlPoint1:arrowTailCurve1 controlPoint2:arrowtailCurve2];
    [arrow lineToPoint:arrowBottom];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:arrow]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
}




@implementation DRRDock

- (id)init {
    self = [super init];
    if (self)
        [self setDefaultItemProperties];
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.frame = frameRect;
        [self setDefaultItemProperties];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode cellClass:(Class)factoryId numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide {
    self = [super initWithFrame:frameRect mode:aMode cellClass:factoryId numberOfRows:rowsHigh numberOfColumns:colsWide];
    if (self)
        [self setDefaultItemProperties];
    return self;
}

- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode prototype:(NSCell *)aCell numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide {
    self = [super initWithFrame:frameRect mode:aMode prototype:aCell numberOfRows:rowsHigh numberOfColumns:colsWide];
    if (self)
        [self setDefaultItemProperties];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setDefaultItemProperties];
    return self;
}

- (void)setDefaultItemProperties {
    dockPrevResizeWasInLive = NO;
    self.prevSelectedCell = [self selectedCell];
//    SEL callMethod = @selector(callMyViewMethod:);
//    cellHighlighted = NSMakePoint(-1, -1);
}

//- (BOOL)preservesContentDuringLiveResize {
//    NSLog(@"pres - dock");
//    return YES;
//}

//- (void)highlightCell:(BOOL)flag atRow:(NSInteger)row column:(NSInteger)column {
//    [super highlightCell:flag atRow:row column:column];
//    [self setHighlightedCell:row atColumn:column];
//}
//
//- (NSPoint)getHighlightedCell {
//    return cellHighlighted;
//}
//
//- (void)setHighlightedCell:(NSInteger)row atColumn:(NSInteger)column {
//    cellHighlighted.x = column;
//    cellHighlighted.y = row;
//}
//
//- (BOOL)hasHighlightedCell {
//    NSPoint cell = [self getHighlightedCell];
//    if ((cell.x > -1) && (cell.y > -1))
//        return YES;
//    else
//        return NO;
//}

// metodi per ricevere e settare il rettangolo del controllo oppure la sua origine e le dimensioni
//- (NSPoint)getFrameOrigin { return self.frame.origin; }
//- (NSSize)getFrameSize    { return self.frame.size; }
//- (void)setFrameOrigin:(NSPoint)o {
//    NSSize temp = NSMakeSize(self.frame.size.width, self.frame.size.height);
//    self.frame = NSMakeRect(o.x, o.y, temp.width, temp.height);
//}
//- (void)setFrameSize:(NSSize)s    { self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, s.width, s.height); }
//- (NSSize)cellSize {
//    return self.controlView.bounds.size;
//}



// metodo che restituisce true se il punto passato è dentro al rettangolo del controllo
//- (BOOL)hitTest:(NSPoint)p {
//    return NSPointInRect(p, self.frame);
//}


- (void)mouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGDOCKMOUSECORR
    NSLog(@"+mouseDown Dock");
    #endif
    
//    if ([self hasHighlightedCell]) {
//        NSPoint cell = [self getHighlightedCell];
//        [self highlightCell:NO atRow:cell.y column:cell.x];
//    }
    [super mouseDown:theEvent];
    
    id cell = [self selectedCell];
    NSInteger row, column;
    [self getRow:&row column:&column ofCell:self.prevSelectedCell];
    if ([cell class] == [DRRActionButton class]) // TODO non mi convince...
        [self setState:NSOnState atRow:row column:column];
    else
        self.prevSelectedCell = cell;
    
    [self.dockdelegate updateCursor:self];
//    if (btn ==) {
//        statements
//    }
    
}

//- (void)mouseDragged { }
//
//- (void)mouseUp { }
//
//- (void)drawRect:(NSRect)dirtyRect { }

- (BOOL)inLiveResize {
    BOOL isInLive = [super inLiveResize];
    if (!isInLive) {
        if (dockPrevResizeWasInLive) {
            dockPrevResizeWasInLive = NO;
            [self setNeedsDisplay];
        }
    }
    else
        dockPrevResizeWasInLive = YES;
    
    return isInLive;
}

- (void)drawRect:(NSRect)dirtyRect {
    if ([self inLiveResize])
        [[NSGraphicsContext currentContext] setShouldAntialias: NO];
    
    [super drawRect:dirtyRect];
}

@end







@implementation DRRButton

+ (Class)cellClass {
	return [DRRButton class];
}

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes {
    self = [super init];
    if (self) {
        self.btnpaths = paths;
        self.btnmodes = modes;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
//    if (self) { }
    return self;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    #ifdef DEBUGDOCKDRAW
    NSLog(@"-drawInterior DRRButton");
    #endif
    
    //    NSColor * prevColor; ///// TODO salvare colore precedente
    if ([self isHighlighted]) {
        DRRDrawingProperties * border = (DRRDrawingProperties *) self.btnmodes[0];
        border.color = [NSColor grayColor];
    }
    else {
        DRRDrawingProperties * border = (DRRDrawingProperties *) self.btnmodes[0];
        border.color = [NSColor whiteColor];
    }
    
    [self.btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        NSBezierPath * path = pathobj.path;
        NSColor * color = ((DRRDrawingProperties *) self.btnmodes[idx]).color;
        
        if (idx == 0) {
            if ([self isHighlighted])
                color = [NSColor lightGrayColor];
            else if ([self state])
                color = [NSColor greenColor];
        }
        [color set];
        
        if (((DRRDrawingProperties *) self.btnmodes[idx]).drawingMode == FILL)
            [path fill];
        else
            [path stroke];
    }];

}

@end




@implementation DRRActionButton

+ (Class)cellClass {
	return [DRRActionButton class];
}

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes {
    self = [super init];
    if (self) {
        self.btnpaths = paths;
        self.btnmodes = modes;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    //    if (self) { }
    return self;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    #ifdef DEBUGDOCKDRAW
    NSLog(@"-drawInterior DRRActionButton");
    #endif
    
    //    NSColor * prevColor; ///// TODO salvare colore precedente
    if ([self isHighlighted]) {
        DRRDrawingProperties * border = (DRRDrawingProperties *) self.btnmodes[0];
        border.color = [NSColor grayColor];
    }
    else {
        DRRDrawingProperties * border = (DRRDrawingProperties *) self.btnmodes[0];
        border.color = [NSColor whiteColor];
    }
    
    [self.btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        NSBezierPath * path = pathobj.path;
        NSColor * color = ((DRRDrawingProperties *) self.btnmodes[idx]).color;
        
        if (idx == 0) {
            if ([self isHighlighted])
                color = [NSColor greenColor];
//            else if ([self state])
//                color = [NSColor greenColor];
        }
        [color set];
        
        if (((DRRDrawingProperties *) self.btnmodes[idx]).drawingMode == FILL)
            [path fill];
        else
            [path stroke];
    }];
    
}

@end

