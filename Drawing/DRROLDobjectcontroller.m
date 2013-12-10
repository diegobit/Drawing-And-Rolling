//
//  DRROLDobjectcontroller.m
//  Drawing
//
//  Created by Diego Giorgini on 10/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRROLDobjectcontroller.h"

@implementation DRROLDobjectcontroller

//@implementation DRRMyControl

// inizializza il controllo con un rettangolo
- (id)initWithFrame:(NSRect)frameRect {
    self = [super init];
    if (self) {
        [self setFrame:frameRect];
    }
    return self;
}

// metodi per ricevere e settare il rettangolo del controllo oppure la sua origine e le dimensioni
- (NSPoint)getFrameOrigin { return rect.origin; }
- (NSSize)getFrameSize { return rect.size; }
- (NSRect)getFrame { return rect; }
- (void)setFrameOrigin:(NSPoint)o { rect.origin = o; }
- (void)setFrameSize:(NSSize)s { rect.size = s; }
- (void)setFrame:(NSRect)r { rect = r; }

// metodo che restituisce true se il punto passato è dentro al rettangolo del controllo
- (BOOL)hitTest:(NSPoint)p {
    return NSPointInRect(p, rect);
}

- (void)mouseDown {
    
}

- (void)mouseDragged {
    
}

- (void)mouseUp {
    
}



- (void)drawRect:(NSRect)dirtyRect {
    
}



@end
