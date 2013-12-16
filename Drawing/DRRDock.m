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
    DRRDrawingProperties * obj = [DRRDrawingProperties init];
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



void makeDrawFreeButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes) {

    NSBezierPath * border;
    NSBezierPath * innerborder;
    NSBezierPath * pencilpoint;
    NSBezierPath * pencilback;
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + 3, frame.origin.y + 3, frame.size.width - 6, frame.size.height - 6) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
    CGFloat leftX = frame.size.width * 0.23;
    CGFloat bottomY = frame.size.height * 0.23;
    CGFloat topY = frame.size.height * 0.33;
    CGFloat rightX = frame.size.width * 0.33;
    NSPoint backTopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.71, frame.origin.y + frame.size.height * 0.81);
    NSPoint backBottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.81, frame.origin.y + frame.size.height * 0.71);
    
    // Path matita
    [pencilpoint moveToPoint:NSMakePoint(frame.origin.x + leftX, frame.origin.y + bottomY)];
    [pencilpoint lineToPoint:NSMakePoint(frame.origin.x + leftX, frame.origin.y + topY)];
    [pencilpoint lineToPoint:NSMakePoint(frame.origin.x + rightX, frame.origin.y + bottomY)];
    [pencilback moveToPoint:NSMakePoint(frame.origin.x + leftX, frame.origin.y + topY)];
    [pencilback lineToPoint:backTopLeft];
    [pencilback lineToPoint:backBottomRight];
    
    // Comincio ad aggiungere i paths all'array paths e ad impostare le preferenze di disegno in modes
    [paths addObject:border];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:innerborder];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor blackColor] drawingMode:FILL]];
    
    [paths addObject:pencilpoint];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:FILL]];
    
    [paths addObject:pencilback];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor whiteColor] drawingMode:STROKE]];
    
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
- (NSPoint)getFrameOrigin { return self.frame.origin; }
- (NSSize)getFrameSize    { return self.frame.size; }
- (void)setFrameOrigin:(NSPoint)o { self.frame = NSMakeRect(o.x, o.y, self.frame.size.width, self.frame.size.height); }
- (void)setFrameSize:(NSSize)s    { self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, s.width, s.height); }
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

- (id)initWithSize:(NSSize)size paths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes {
    self = [super init];
    
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
    NSLog(@"draw-buttonDRawFreely"); /////DELETE
    //    NSColor * prevColor; ///// TODO salvare colore precedente
    
    [paths enumerateObjectsUsingBlock:^(NSBezierPath * path, NSUInteger idx, BOOL *stop) {
        [((DRRDrawingProperties *) modes[idx]).color set];
        if (((DRRDrawingProperties *) modes[idx]).drawingMode == FILL) {
            [path fill];
        }
        else
            [path stroke];
            ///// TODO path secondo tipo di linea
    }];
    
    
}


@end
