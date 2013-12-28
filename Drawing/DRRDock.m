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



void makeDrawFreeButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes) {

    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * pencilpoint = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
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


void makeDrawLine(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes) {
    
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
    cellHighlighted = NSMakePoint(-1, -1);
}

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


//- (void)mouseDown { }
//
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
        btnpaths = paths;
        btnmodes = modes;
    }
//    // Path per il bordo
//    [border appendBezierPathWithRoundedRect:self.frame xRadius:self.roundness yRadius:self.roundness];
//    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(self.frame.origin.x + 3, self.frame.origin.y + 3, self.frame.size.width - 6, self.frame.size.height - 6) xRadius:self.roundness yRadius:self.roundness];
//    
//    // Path matita
//    [pencilpoint moveToPoint:NSMakePoint(leftX, bottomY)];
//    [pencilpoint lineToPoint:NSMakePoint(leftX, topY)];
//    [pencilpoint lineToPoint:NSMakePoint(rightX, bottomY)];
//    [pencilback moveToPoint:NSMakePoint(leftX, topY)];
//    [pencilback lineToPoint:backTopLeft];
//    [pencilback lineToPoint:backBottomRight];
//    
//    // Coordinate per il disegno del triangolo della matita.
//    leftX = self.frame.size.width * 0.23;
//    bottomY = self.frame.size.height * 0.23;
//    topY = self.frame.size.height * 0.33;
//    rightX = self.frame.size.width * 0.33;
//    backTopLeft = NSMakePoint(self.frame.size.width * 0.71, self.frame.size.height * 0.81);
//    backBottomRight = NSMakePoint(self.frame.size.width * 0.81, self.frame.size.height * 0.71);
//    // Contorno matita.
//    linewidth = (self.frame.size.width + self.frame.size.height) / 100;
//    if (linewidth < 1) { linewidth = 1; }
    
    
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
//    if (self) { }
    return self;
}

//- (void)mouseDown:(NSEvent *)theEvent { [self setState:NSOnState]; }
////- (void)mouseDragged { }
//- (void)mouseUp:(NSEvent *)theEvent { [self setState:NSOffState]; }

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    #ifdef DEBUGDRAWDOCK
    NSLog(@"draw-buttonDRawFreely");
    #endif
    
    //    NSColor * prevColor; ///// TODO salvare colore precedente
    if ([self isHighlighted]) {
        DRRDrawingProperties * border = (DRRDrawingProperties *) btnmodes[0];
        border.color = [NSColor lightGrayColor];
    }
    
    [btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        NSBezierPath * path = pathobj.path;
        [((DRRDrawingProperties *) btnmodes[idx]).color set];
        if (((DRRDrawingProperties *) btnmodes[idx]).drawingMode == FILL)
            [path fill];
        else
            [path stroke];

    }];
}


@end
