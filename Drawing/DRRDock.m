//
//  DRRDock.m
//  Drawing
//
//  Created by Diego Giorgini on 14/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRDock.h"

@implementation DRRDrawingProperties

+ (DRRDrawingProperties *)initWithColor:(NSColor *)color drawingMode:(drawingmode_t)mode { // altMode:(BOOL)flag{
    DRRDrawingProperties * obj = [[DRRDrawingProperties alloc] init];
    if (obj) {
        obj.color = color;
        obj.drawingMode = mode;
//        obj.shouldDrawInNormalMode = flag;
//        obj.shouldDrawInAltMode = flag;
    }
    return obj;
}

- (id)init {
    self = [super init];
//    if (self) {
//        DRRDrawingProperties * obj = [[DRRDrawingProperties alloc] init];
//        obj.color = [NSColor blackColor];
//        obj.drawingMode = STROKEBOTH;
////        obj.shouldDrawAlsoInAltMode = NO;
//    }
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

@end



void makeDrawFreeButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {

    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1); // TODO: sistemare la dimensione, forse i paths, però dovelo rimpicciolire così non va bene (per turri i bottoni)
    
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
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pencilpoint]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}


void makeDrawLineButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * line = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:roundness yRadius:roundness];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno della matita.
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
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:line]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}


void makePanButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
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
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleLeft]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleTop]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleRight]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:triangleBottom]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:circle]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
}


void makeZoomButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
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
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:lens]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerLens]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:handle]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
}


void makeBackButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
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
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:arrow]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}


void makeSaveButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * container = [[NSBezierPath alloc] init];
    NSBezierPath * arrow = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno.
    NSPoint contExt_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.20,
                                          frame.origin.y + frame.size.height * 0.30);
    NSPoint contExt_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.20,
                                             frame.origin.y + frame.size.height * 0.75);
    NSPoint contExt_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.79,
                                              frame.origin.y + frame.size.height * 0.75);
    NSPoint contExt_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.79,
                                           frame.origin.y + frame.size.height * 0.30);
    
    NSPoint contInt_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.28,
                                          frame.origin.y + frame.size.height * 0.30);
    NSPoint contInt_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.28,
                                             frame.origin.y + frame.size.height * 0.64);
    NSPoint contInt_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.71,
                                              frame.origin.y + frame.size.height * 0.64);
    NSPoint contInt_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.71,
                                           frame.origin.y + frame.size.height * 0.30);
    
    NSPoint arrowBack_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.43,
                                            frame.origin.y + frame.size.height * 0.16);
    NSPoint arrowBack_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.56,
                                             frame.origin.y + frame.size.height * 0.16);
    NSPoint arrowBack_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.56,
                                                frame.origin.y + frame.size.height * 0.38);
    NSPoint arrowBack_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.43,
                                               frame.origin.y + frame.size.height * 0.38);
    NSPoint arrowPoint_Left = NSMakePoint(frame.origin.x + frame.size.width * 0.33,
                                          frame.origin.y + frame.size.height * 0.38);
    NSPoint arrowPoint_bottom = NSMakePoint(frame.origin.x + frame.size.width * 0.495,
                                            frame.origin.y + frame.size.height * 0.59);
    NSPoint arrowPoint_Right = NSMakePoint(frame.origin.x + frame.size.width * 0.66,
                                           frame.origin.y + frame.size.height * 0.38);
    
    // Path freccia
    [container moveToPoint:contExt_bottomLeft];
    [container lineToPoint:contExt_topLeft];
    [container lineToPoint:contInt_topLeft];
    [container lineToPoint:contInt_bottomLeft];
    [container lineToPoint:contInt_bottomRight];
    [container lineToPoint:contInt_topRight];
    [container lineToPoint:contExt_topRight];
    [container lineToPoint:contExt_bottomRight];

    [arrow moveToPoint:arrowBack_bottomLeft];
    [arrow lineToPoint:arrowBack_topLeft];
    [arrow lineToPoint:arrowBack_topRight];
    [arrow lineToPoint:arrowBack_bottomRight];
    [arrow lineToPoint:arrowPoint_Right];
    [arrow lineToPoint:arrowPoint_bottom];
    [arrow lineToPoint:arrowPoint_Left];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:container]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];

    [paths addObject:[[DRRPathObj alloc] initWithPath:arrow]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}


void makeLoadButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * container = [[NSBezierPath alloc] init];
    NSBezierPath * arrow = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno.
    NSPoint contExt_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.20,
                                          frame.origin.y + frame.size.height * 0.30);
    NSPoint contExt_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.20,
                                             frame.origin.y + frame.size.height * 0.75);
    NSPoint contExt_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.79,
                                              frame.origin.y + frame.size.height * 0.75);
    NSPoint contExt_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.79,
                                           frame.origin.y + frame.size.height * 0.30);
    
    NSPoint contInt_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.28,
                                          frame.origin.y + frame.size.height * 0.30);
    NSPoint contInt_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.28,
                                             frame.origin.y + frame.size.height * 0.64);
    NSPoint contInt_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.71,
                                              frame.origin.y + frame.size.height * 0.64);
    NSPoint contInt_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.71,
                                           frame.origin.y + frame.size.height * 0.30);
    
    NSPoint arrowBack_topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.43,
                                            frame.origin.y + frame.size.height * 0.36);
    NSPoint arrowBack_topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.56,
                                             frame.origin.y + frame.size.height * 0.36);
    NSPoint arrowBack_bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.56,
                                                frame.origin.y + frame.size.height * 0.58);
    NSPoint arrowBack_bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.43,
                                               frame.origin.y + frame.size.height * 0.58);
    NSPoint arrowPoint_Left = NSMakePoint(frame.origin.x + frame.size.width * 0.33,
                                          frame.origin.y + frame.size.height * 0.36);
    NSPoint arrowPoint_Top = NSMakePoint(frame.origin.x + frame.size.width * 0.495,
                                            frame.origin.y + frame.size.height * 0.15);
    NSPoint arrowPoint_Right = NSMakePoint(frame.origin.x + frame.size.width * 0.66,
                                           frame.origin.y + frame.size.height * 0.36);
    
    // Path freccia
    [container moveToPoint:contExt_bottomLeft];
    [container lineToPoint:contExt_topLeft];
    [container lineToPoint:contInt_topLeft];
    [container lineToPoint:contInt_bottomLeft];
    [container lineToPoint:contInt_bottomRight];
    [container lineToPoint:contInt_topRight];
    [container lineToPoint:contExt_topRight];
    [container lineToPoint:contExt_bottomRight];
    
    [arrow moveToPoint:arrowBack_bottomLeft];
    [arrow lineToPoint:arrowBack_topLeft];
    [arrow lineToPoint:arrowPoint_Left];
    [arrow lineToPoint:arrowPoint_Top];
    [arrow lineToPoint:arrowPoint_Right];
    [arrow lineToPoint:arrowBack_topRight];
    [arrow lineToPoint:arrowBack_bottomRight];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:container]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:arrow]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}



void makePlayButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * play = [[NSBezierPath alloc] init];
    NSBezierPath * pauseLeft = [[NSBezierPath alloc] init];
    NSBezierPath * pauseRight = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno.
    NSPoint playTop = NSMakePoint(frame.origin.x + frame.size.width * 0.35,
                                  frame.origin.y + frame.size.height * 0.26);
    NSPoint playRight = NSMakePoint(frame.origin.x + frame.size.width * 0.69,
                                  frame.origin.y + frame.size.height * 0.49);
    NSPoint playBottom = NSMakePoint(frame.origin.x + frame.size.width * 0.35,
                                  frame.origin.y + frame.size.height * 0.72);
    
    NSPoint pauseLeft_TopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.34,
                                            frame.origin.y + frame.size.height * 0.27);
    NSPoint pauseLeft_TopRight = NSMakePoint(frame.origin.x + frame.size.width * 0.44,
                                             frame.origin.y + frame.size.height * 0.27);
    NSPoint pauseLeft_BottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.44,
                                                frame.origin.y + frame.size.height * 0.71);
    NSPoint pauseLeft_BottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.34,
                                               frame.origin.y + frame.size.height * 0.71);
    
    NSPoint pauseRight_TopLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.55,
                                             frame.origin.y + frame.size.height * 0.27);
    NSPoint pauseRight_TopRight = NSMakePoint(frame.origin.x + frame.size.width * 0.65,
                                              frame.origin.y + frame.size.height * 0.27);
    NSPoint pauseRight_BottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.65,
                                                 frame.origin.y + frame.size.height * 0.71);
    NSPoint pauseRight_BottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.55,
                                                frame.origin.y + frame.size.height * 0.71);
    
    // Path
    [play moveToPoint:playTop];
    [play lineToPoint:playRight];
    [play lineToPoint:playBottom];
    
    [pauseLeft moveToPoint:pauseLeft_BottomLeft];
    [pauseLeft lineToPoint:pauseLeft_TopLeft];
    [pauseLeft lineToPoint:pauseLeft_TopRight];
    [pauseLeft lineToPoint:pauseLeft_BottomRight];
    [pauseRight moveToPoint:pauseRight_BottomLeft];
    [pauseRight lineToPoint:pauseRight_TopLeft];
    [pauseRight lineToPoint:pauseRight_TopRight];
    [pauseRight lineToPoint:pauseRight_BottomRight];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:play]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLNORMAL]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pauseLeft]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLALT]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:pauseRight]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLALT]];

}



void makeStopButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes) {
    
    frame = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
    
    NSBezierPath * border = [[NSBezierPath alloc] init];
    NSBezierPath * innerborder = [[NSBezierPath alloc] init];
    NSBezierPath * stop = [[NSBezierPath alloc] init];
    
    // Path per il bordo
    [border appendBezierPathWithRoundedRect:frame xRadius:(roundness + 2) yRadius:(roundness + 2)];
    CGFloat bthickness = fmin(frame.size.width, frame.size.height) * 0.08;
    [innerborder appendBezierPathWithRoundedRect:NSMakeRect(frame.origin.x + bthickness, frame.origin.y + bthickness, frame.size.width - (2 * bthickness), frame.size.height - (2 * bthickness)) xRadius:roundness yRadius:roundness];
    
    // Coordinate per il disegno interno.
    NSPoint topLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.30,
                                  frame.origin.y + frame.size.height * 0.29);
    NSPoint topRight = NSMakePoint(frame.origin.x + frame.size.width * 0.69,
                                   frame.origin.y + frame.size.height * 0.29);
    NSPoint bottomRight = NSMakePoint(frame.origin.x + frame.size.width * 0.69,
                                      frame.origin.y + frame.size.height * 0.69);
    NSPoint bottomLeft = NSMakePoint(frame.origin.x + frame.size.width * 0.30,
                                     frame.origin.y + frame.size.height * 0.69);

    // Path
    [stop moveToPoint:topLeft];
    [stop lineToPoint:topRight];
    [stop lineToPoint:bottomRight];
    [stop lineToPoint:bottomLeft];
    
    // Aggiungo i paths all'array paths e imposto le preferenze di disegno in modes
    [paths addObject:[[DRRPathObj alloc] initWithPath:border]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:innerborder]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor ddBlue] drawingMode:FILLBOTH]];
    
    [paths addObject:[[DRRPathObj alloc] initWithPath:stop]];
    [modes addObject:[DRRDrawingProperties initWithColor:[NSColor llGray] drawingMode:FILLBOTH]];
    
}




@implementation DRRDockBar

//- (void)setFrameSize:(NSSize)newSize {
//    
//    NSSize prevSize = self.frame.size;
//    [super setFrameSize:newSize];
//    
//    if ([self inLiveResize]) {
//        NSRect rects[4];
//        NSInteger count;
//        
//        [self getRectsExposedDuringLiveResize:rects count:&count];
//        if (prevSize.height - newSize.height < 0) {
//            while (count-- > 0)
//                [self setNeedsDisplayInRect:rects[count]];
//        }
//    }
//    else {
//        [super setNeedsDisplay:YES];
//    }
//    
//}

//- (void) awakeF

- (BOOL)preservesContentDuringLiveResize {
    return YES;
}

//- (void)setNeedsDisplay:(BOOL)flag {
//    if (flag) {
////        NSRect bottomRect = NSMakeRect(self.frame.origin.x, self.frame.origin.y,
////                                       self.frame.size.width, self.superview.)
//    }
//    
//    [super setNeedsDisplay:NO];
//}
//
//- (void)setNeedsDisplayInRect:(NSRect)invalidRect {
//    
//}



//- (void)setFrameSize:(NSSize)newSize {
//    [super setFrameSize:newSize];
//    
//    CGFloat heightBetweenDockAndTop = (self.frame.size.height - self.dock.frame.size.height);
//    [self.dock setFrameOrigin:NSMakePoint(self.dock.frame.origin.x,
//                                          self.frame.origin.y + (heightBetweenDockAndTop / 2))];
//}



- (void)drawRect:(NSRect)dirtyRect {
    
    #ifdef DEBUGDOCKDRAW
    NSLog(@"-drawRect dockBar");
    #endif
    
    // Coloro lo sfondo
    [[NSColor llGray] set];
    NSRectFill(NSMakeRect(dirtyRect.origin.x,
                          dirtyRect.origin.y,
                          dirtyRect.size.width - 1,
                          dirtyRect.size.height));
    
    // Coloro la linea del bordo a destra
    [[NSColor lightGrayColor] set];
    NSRectFill(NSMakeRect(dirtyRect.origin.x + dirtyRect.size.width - 1,
                          dirtyRect.origin.y,
                          1,
                          dirtyRect.size.height));
}



- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
}

@end



//<##>
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
//    dockPrevResizeWasInLive = NO;
    self.prevSelectCell_playPause = [self selectedCell];
    self.prevSelectCell = [self selectedCell];
    self.prevSelectCell_RMouse = [self selectedCell];
    [self setWantsLayer:YES];
}


//- (void)setFrameSize:(NSSize)newSize {
////    [super setFrameSize:newSize];
//    
//    CGFloat heightBetweenDockAndTop = fabs(newSize.height - self.frame.size.height);
//    [self setFrameOrigin:NSMakePoint(self.frame.origin.x,
//                                     self.superview.frame.origin.y + heightBetweenDockAndTop)];
//    [self setNeedsDisplay:YES];
//}

//- (BOOL)inLiveResize {
//    BOOL isInLive = [super inLiveResize];
//    if (!isInLive) {
//        if (dockPrevResizeWasInLive) {
//            dockPrevResizeWasInLive = NO;
//            [self setNeedsDisplay];
//        }
//    }
//    else
//        dockPrevResizeWasInLive = YES;
//    
//    return isInLive;
//}

- (BOOL)preservesContentDuringLiveResize {
    return YES;
}

//- (void)setNeedsDisplay:(BOOL)flag {
//    
//}
//
//- (void)setNeedsDisplayInRect:(NSRect)invalidRect {
//    if (self.count == 0)
//        [super setNeedsDisplayInRect:invalidRect];
//    
//}

#ifdef DEBUGDOCKDRAW
- (void)drawRect:(NSRect)dirtyRect {
//    if ([self inLiveResize])
//        [[NSGraphicsContext currentContext] setShouldAntialias: NO];
    NSLog(@"-drawInterior DRRDock");
    
    [super drawRect:dirtyRect];
    
}
#endif



//- (void)setState:(NSInteger)value atRow:(NSInteger)row column:(NSInteger)col {
//    [super setState:value atRow:row column:col];
//    
//    NSCell * selectedcell = [self cellAtRow:row column:col];
//    if ([selectedcell allowsMixedState]) {
//        if ([selectedcell state] == NSOnState)
//            [selectedcell setState:NSMixedState];
//        else if ([selectedcell state] == NSMixedState)
//            [selectedcell setState:NSOnState];
//    }
//}



- (void)mouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGDOCKMOUSECORR
    NSLog(@"+mouseDown Dock");
    #endif
    
    [super mouseDown:theEvent];
    
    id cell = [self selectedCell];
    NSInteger row, column;
    [self getRow:&row column:&column ofCell:self.prevSelectCell];
    if ([cell class] == [DRRActionButton class]) // TODO non mi convince...
        [self setState:NSOnState atRow:row column:column];
    else
        self.prevSelectCell = cell;
    
    [self.dockdelegate updateCursor:self];

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
        self.altMode = NO;
    }
    return self;
}



- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    #ifdef DEBUGDOCKDRAW
    NSLog(@"-drawInterior DRRButton");
    #endif
    
    // per ogni path del bottone...
    [self.btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        
        drawingmode_t mode = ((DRRDrawingProperties *) self.btnmodes[idx]).drawingMode;
        BOOL altModeActive = NO;
        BOOL normalModeActive = YES;
        BOOL wouldDrawNormal = (mode == FILLNORMAL || mode == STROKENORMAL);
        BOOL wouldDrawAlt = (mode == FILLALT || mode == STROKEALT);
        BOOL wouldDrawBoth = (mode == FILLBOTH || mode == STROKEBOTH);
        
        // ... controllo come lo devo disegnare
        if ( (!self.altMode && (wouldDrawBoth || wouldDrawNormal)) ) {
            normalModeActive = YES;
            altModeActive = NO;
        }
        else if (self.altMode && (wouldDrawBoth || wouldDrawAlt)){
            normalModeActive = NO;
            altModeActive = YES;
        }
        else {
            normalModeActive = NO;
            altModeActive = NO;
        }
        
        NSBezierPath * path = pathobj.path;
        NSColor * color = ((DRRDrawingProperties *) self.btnmodes[idx]).color;
        
        if (idx == 0 && normalModeActive) {
            if ([self state] == NSOnState)
                color = [NSColor greenColor];
            else if ([self isHighlighted])
                color = [NSColor yellowColor];
        }
        
        else if (idx > 0) {
            // Voglio riempire di bianco solo il grigio llGray, non eventuali altri colori del bottone (esempio: il riempimento nero della lente dello zoom)
            CGFloat red, green, blue, alpha, redLLG, greenLLG, blueLLG, alphaLLG, redDDB, greenDDB, blueDDB, alphaDDB;
            [color getRed:&red green:&green blue:&blue alpha:&alpha];
            [[NSColor llGray] getRed:&redLLG green:&greenLLG blue:&blueLLG alpha:&alphaLLG]; // TODO: far diventare trasparente l'interno dei bottoni così si vede lo sfondo della dockBar
            [[NSColor ddBlue] getRed:&redDDB green:&greenDDB blue:&blueDDB alpha:&alphaDDB];
            
            if (wouldDrawNormal && self.altMode && red == redDDB && green == greenDDB && blue == blueDDB && alpha == alphaDDB) {
                color = [NSColor lightGrayColor];
            }
            
            if ((normalModeActive || altModeActive)
                && red == redLLG && green == greenLLG && blue == blueLLG && alpha == alphaLLG
                && ([self isHighlighted] || [self state] == NSOnState)
                )
                    color = [NSColor whiteColor];
        }
        
        [color set];
        
        BOOL shouldDraw = YES;
        if (idx > 1 && !normalModeActive && !altModeActive)
            shouldDraw = NO;
        
        if (shouldDraw) {
            if (mode == FILLBOTH || mode == FILLNORMAL || mode == FILLALT)
                [path fill];
            else
                [path stroke];
        }
        
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
        self.altMode = NO;
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
    
    // per ogni path del bottone...
    [self.btnpaths enumerateObjectsUsingBlock:^(DRRPathObj * pathobj, NSUInteger idx, BOOL *stop) {
        
        drawingmode_t mode = ((DRRDrawingProperties *) self.btnmodes[idx]).drawingMode;
        BOOL altModeActive = NO;
        BOOL normalModeActive = YES;
        BOOL wouldDrawNormal = (mode == FILLNORMAL || mode == STROKENORMAL);
        BOOL wouldDrawAlt = (mode == FILLALT || mode == STROKEALT);
        BOOL wouldDrawBoth = (mode == FILLBOTH || mode == STROKEBOTH);
        
        // ... controllo come lo devo disegnare
        if ( (!self.altMode && (wouldDrawBoth || wouldDrawNormal)) ) {
            normalModeActive = YES;
            altModeActive = NO;
        }
        else if (self.altMode && (wouldDrawBoth || wouldDrawAlt)){
            normalModeActive = NO;
            altModeActive = YES;
        }
        else {
            normalModeActive = NO;
            altModeActive = NO;
        }

            NSBezierPath * path = pathobj.path;
            NSColor * color = color = ((DRRDrawingProperties *) self.btnmodes[idx]).color;
            
            if (idx == 0 && (normalModeActive || altModeActive)) {
                if ([self state] == NSOnState)
                    color = [NSColor greenColor];
                else if ([self isHighlighted])
                    color = [NSColor yellowColor];
            }
            
            else if (idx > 0) {
                // Voglio riempire di bianco solo il grigio llGray, non eventuali altri colori del bottone (esempio: il riempimento nero della lente dello zoom)
                CGFloat red, green, blue, alpha, redLLG, greenLLG, blueLLG, alphaLLG, redDDB, greenDDB, blueDDB, alphaDDB;
                [color getRed:&red green:&green blue:&blue alpha:&alpha];
                [[NSColor llGray] getRed:&redLLG green:&greenLLG blue:&blueLLG alpha:&alphaLLG]; // TODO: far diventare trasparente l'interno dei bottoni così si vede lo sfondo della dockBar
                [[NSColor ddBlue] getRed:&redDDB green:&greenDDB blue:&blueDDB alpha:&alphaDDB];
                
                if (wouldDrawNormal && self.altMode && red == redDDB && green == greenDDB && blue == blueDDB && alpha == alphaDDB) {
                    //                if (![self isHighlighted] && ![self state] == NSOnState)
                    color = [NSColor lightGrayColor];
                }
                
                if ((normalModeActive || altModeActive)
                    && red == redLLG && green == greenLLG && blue == blueLLG && alpha == alphaLLG
                    && ([self isHighlighted] || [self state] == NSOnState)
                    )
                    color = [NSColor whiteColor];
            }
            
            [color set];
            
            BOOL shouldDraw = YES;
            if (idx > 1 && !normalModeActive && !altModeActive)
                shouldDraw = NO;
        
            if (shouldDraw) {
                if (mode == FILLBOTH || mode == FILLNORMAL || mode == FILLALT)
                    [path fill];
                else
                    [path stroke];
            }
        
    }];
    
}

@end