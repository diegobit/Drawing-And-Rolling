//
//  DRRMyControl.m
//  Drawing
//
//  Created by Diego Giorgini on 10/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRMyControl.h"

@implementation DRRMyControl

// inizializza il controllo con un rettangolo
- (id)initWithFrame:(NSRect)frameRect {
    self = [super init];
    if (self) {
        self.frame = frameRect;
    }
    return self;
}

// metodi per ricevere e settare il rettangolo del controllo oppure la sua origine e le dimensioni
- (NSPoint)getFrameOrigin { return self.frame.origin; }
- (NSSize)getFrameSize    { return self.frame.size; }
- (void)setFrameOrigin:(NSPoint)o { self.frame = NSMakeRect(o.x, o.y, self.frame.size.width, self.frame.size.height); }
- (void)setFrameSize:(NSSize)s    { self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, s.width, s.height); }

// metodo che restituisce true se il punto passato è dentro al rettangolo del controllo
- (BOOL)hitTest:(NSPoint)p {
    return NSPointInRect(p, self.frame);
}

//- (void)mouseDown {
//    
//}
//
//- (void)mouseDragged {
//    
//}
//
//- (void)mouseUp {
//    
//}
//
//
//
//- (void)drawRect:(NSRect)dirtyRect {
//    
//}

@end


@implementation DRRbuttonDrawFreely

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:self.frame xRadius:self.roundness yRadius:self.roundness];
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(self.frame.origin.x + 3, self.frame.origin.y + 3, self.frame.size.width - 6, self.frame.size.height - 6) xRadius:self.roundness yRadius:self.roundness];
    
    // Path matita
    [pencilpoint moveToPoint:NSMakePoint(leftX, bottomY)];
    [pencilpoint lineToPoint:NSMakePoint(leftX, topY)];
    [pencilpoint lineToPoint:NSMakePoint(rightX, bottomY)];
    [pencilback moveToPoint:NSMakePoint(leftX, topY)];
    [pencilback lineToPoint:backTopLeft];
    [pencilback lineToPoint:backBottomRight];
    
    // Coordinate per il disegno del triangolo della matita.
    leftX = self.frame.size.width * 0.23;
    bottomY = self.frame.size.height * 0.23;
    topY = self.frame.size.height * 0.33;
    rightX = self.frame.size.width * 0.33;
    backTopLeft = NSMakePoint(self.frame.size.width * 0.71, self.frame.size.height * 0.81);
    backBottomRight = NSMakePoint(self.frame.size.width * 0.81, self.frame.size.height * 0.71);
    // Contorno matita.
    linewidth = (self.frame.size.width + self.frame.size.height) / 100;
    if (linewidth < 1) { linewidth = 1; }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent { [self setState:NSOnState]; }
//- (void)mouseDragged { }
- (void)mouseUp:(NSEvent *)theEvent { [self setState:NSOffState]; }

- (void)drawRect:(NSRect)dirtyRect {
    NSLog(@"draw-buttonDRawFreely"); /////DELETE
    NSColor * prevColor; ///// TODO salvare colore precedente
    
    [border setLineWidth: linewidth];
    
    // Disegno il bordo esterno e poi il riempimento
    [[NSColor whiteColor] set];
    [border fill];
    
    if (self.state) [[NSColor redColor] set];
    else            [[NSColor blackColor] set];
    [innerborder fill];

    // Disegno la punta della matita e poi il resto
    [[NSColor whiteColor] set];
    [pencilpoint fill];
    [pencilback stroke];
}


@end
