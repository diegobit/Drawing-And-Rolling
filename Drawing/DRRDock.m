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
    NSBezierPath * pencilback = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + 3, frame.origin.y + 3, frame.size.width - 6, frame.size.height - 6) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
    CGFloat leftX = frame.size.width * 0.22;
    CGFloat bottomY = frame.size.height * 0.77;
    CGFloat topY = frame.size.height * 0.63;
    CGFloat rightX = frame.size.width * 0.36;
    NSPoint backTopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.68, frame.origin.y + frame.size.height * 0.17);
    NSPoint backBottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.83, frame.origin.y + frame.size.height * 0.32);
    
    // Path matita
    [pencilpoint moveToPoint:NSMakePoint(frame.origin.x + leftX, frame.origin.y + bottomY)];
    [pencilpoint lineToPoint:NSMakePoint(frame.origin.x + leftX, frame.origin.y + topY - 1)];
    [pencilpoint lineToPoint:NSMakePoint(frame.origin.x + rightX + 1, frame.origin.y + bottomY)];
    [pencilback moveToPoint:NSMakePoint(frame.origin.x + leftX + 1, frame.origin.y + topY - 1)];
    [pencilback lineToPoint:backTopLeft];
    [pencilback lineToPoint:backBottomRight];
    [pencilback lineToPoint:NSMakePoint(frame.origin.x + rightX + 1, frame.origin.y + bottomY - 1)];
    
    // Comincio ad aggiungere i paths all'array paths e ad impostare le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pencilpoint]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pencilback]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:STROKE]];
    
}


void makeDrawLine(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes) {
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * line = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + 3, frame.origin.y + 3, frame.size.width - 6, frame.size.height - 6) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
//    NSPoint bottom = NSMakePoint(frame.size.width * 0.22, frame.size.height * 0.77);
//    NSPoint top = NSMakePoint(frame.size.width * 0.88, frame.size.height * 0.23);
    NSPoint bottomleft = NSMakePoint(frame.size.width * 0.20, frame.size.height * 0.75);
    NSPoint bottomright = NSMakePoint(frame.size.width * 0.25, frame.size.height * 0.80);
    NSPoint topleft = NSMakePoint(frame.size.width * 0.75, frame.size.height * 0.20);
    NSPoint topright = NSMakePoint(frame.size.width * 0.80, frame.size.height * 0.25);
    
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

// inizializza il controllo con un rettangolo
- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.frame = frameRect;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

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
- (BOOL)hitTest:(NSPoint)p {
    return NSPointInRect(p, self.frame);
}

//- (void)mouseDown { }
//
//- (void)mouseDragged { }
//
//- (void)mouseUp { }
//
//- (void)drawRect:(NSRect)dirtyRect { }

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
    
    [btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        NSBezierPath * path = pathobj.path;
        [((DRRDrawingProperties *) btnmodes[idx]).color set];
        if (((DRRDrawingProperties *) btnmodes[idx]).drawingMode == FILL) {
            [path fill];
        }
        else
            [path stroke];
        
            ///// TODO path secondo tipo di linea
    }];
}


@end
