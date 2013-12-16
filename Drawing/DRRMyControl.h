//
//  DRRMyControl.h
//  Drawing
//
//  Created by Diego Giorgini on 10/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRRMyControl : NSCell

- (id)initWithFrame:(NSRect)frameRect;

@property NSRect frame;
- (NSPoint)getFrameOrigin;
- (NSSize)getFrameSize;
- (void)setFrameOrigin:(NSPoint)o;
- (void)setFrameSize:(NSSize)s;

- (BOOL)hitTest:(NSPoint)p;
//- (void)mouseDown:(NSEvent *)theEvent;
//- (void)mouseDragged:(NSEvent *)theEvent;
//- (void)mouseUp:(NSEvent *)theEvent;
//
//- (void)drawRect:(NSRect)dirtyRect;

@end


@interface DRRbuttonDrawFreely : DRRMyControl {
    // Un path per il bordo (serve per disegnarlo e per l'hitTest) e un path per il disegno al suo interno.
    NSBezierPath * border;
    NSBezierPath * innerborder;
    NSBezierPath * pencilpoint;
    NSBezierPath * pencilback;
    
    // Coordinate per il disegno del triangolo della punta della matita
    CGFloat leftX;
    CGFloat bottomY;
    CGFloat topY;
    CGFloat rightX;
    // Coordinate per il resto della matita
    NSPoint backTopLeft;
    NSPoint backBottomRight;
    // Spessore contorno matita
    CGFloat linewidth;
}

@property CGFloat roundness;

- (void)mouseDown:(NSEvent *)theEvent;
//- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end