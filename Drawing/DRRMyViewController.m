//
//  DRRMyViewController.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRMyViewController.h"



NSRect computeRect(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, NSInteger border) {
    
    CGFloat x = MIN(x1, x2) - border; CGFloat y = MIN(y1, y2) - border;
    CGFloat raww = x2 - x1; CGFloat rawh = y2 - y1;
    CGFloat w = ABS(raww) + 2*border; CGFloat h = ABS(rawh) + 2*border;
    
    return NSMakeRect(x, y, w, h);
}



@implementation DRRMyViewController

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        //        [self setItemPropertiesToDefault];
        linesContainer = [[NSMutableArray alloc] init];
        last = -1;
        //      lineToDraw = [[NSMutableArray alloc] init];
    }
    return self;
}


//- (void)setItemPropertiesToDefault {
//    // FIXME troppe proprietà
//}



//- (void)setLayoutDefault {
//    [self setBounds:[super bounds]];
//    [self setFrame:[super frame]];
//}



- (void)addEmptyLine {
    NSMutableArray * line = [[NSMutableArray alloc] init];
    [linesContainer addObject:line];
    last++;
    // controllare alloc? FIXME
}


- (void)addPointToLatestLine:(NSPoint*)p {
    //    if (pt != NULL) {
    DRRPointObj * pobj = [[DRRPointObj alloc] initWithPoint:p];
    
    [linesContainer[last] addObject:pobj];
    //    }
}


- (void)mouseDown:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    prevmouseXY = pwindow;
    
    [self addEmptyLine];
    [self addPointToLatestLine:(&pview)];
    //    [self drawRect:([self bounds])];
    
}


- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    [self addPointToLatestLine:(&pview)];
    NSRect dirtyRect = computeRect(prevmouseXY.x, prevmouseXY.y, pwindow.x, pwindow.y, 0);
    [self setNeedsDisplayInRect:dirtyRect];
    
    prevmouseXY = pwindow;
    
}


- (void)mouseUp:(NSEvent *)theEvent {
    
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview   = [self convertPoint:pwindow fromView:nil];
    
    [self addPointToLatestLine:(&pview)];
    NSRect dirtyRect = computeRect(prevmouseXY.x, prevmouseXY.y, pwindow.x, pwindow.y, 0);
    [self setNeedsDisplayInRect:dirtyRect];
    
    prevmouseXY = pwindow;
    
}


- (void)drawRect:(NSRect)dirtyRect {
    
    //    if (!NSEqualRects(prevbounds, [self bounds])) {
    //        [self setLayoutDefault];
    //    }
    
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    //rettangolo DELETE
    [[NSColor redColor] set];
    NSRect r = NSMakeRect(5, 5, 30, 30);
    NSRectFill(r);
    
    //    NSGraphicsContext * g = [NSGraphicsContext currentContext];
    //    CGContextRef gport = [g graphicsPort];
    NSBezierPath * path = [NSBezierPath bezierPath];
    [path setLineWidth: 2];
    [[NSColor blackColor] set];
    
//    srand(time(NULL));
    
    // per ogni linea del contenitore creo un path con NSBezierPath
    if ([linesContainer count] > 0) {
        [linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger iline, BOOL *stop1) {
            if ([line count] > 0) {
                // aggiungo ogni punto della linea al path
                [line enumerateObjectsUsingBlock:^(id point, NSUInteger ipoint, BOOL *stop2) {
                    if (ipoint == 0)
                        [path moveToPoint:[point getPoint]];
                    else {
//                        NSPoint p = [point getPoint];
//                        NSInteger r1 = rand() % 20; NSInteger r2 = rand() % 20;
//                        NSPoint pc1 = NSMakePoint(p.x + r1, p.y - r2);
//                        NSPoint pc2 = NSMakePoint(p.x - r1, p.y + r2);
//                        [path curveToPoint:p controlPoint1:pc1 controlPoint2:pc2];
                        [path lineToPoint:[point getPoint]];
                    }
                }];
                
                [path stroke];
                [self setNeedsDisplay:YES];
                [path removeAllPoints];
            }
        }];
    }
    
    [super drawRect:dirtyRect];
    
//      prevbounds = [self bounds];
    
}

@end



@implementation DRRMyControl

- (id)initWithSize:(NSSize)rectSize {
    self = [super init];
    if (self) {
        [self setSize:rectSize];
    }
    return self;
}


- (NSSize)getSize {
    return size;
}


- (void)setSize:(NSSize)rectSize {
    size = rectSize;
}



@end

