//
//  DRROLDobjectcontroller.h
//  Drawing
//
//  Created by Diego Giorgini on 10/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRROLDobjectcontroller : NSObjectController {

//@interface DRRMyControl : NSObjectController {
    
    NSRect rect;
    //    NSPoint origin;
    //    NSSize size;
    
}

- (id)initWithSize:(NSSize)rectSize;

- (NSPoint)getFrameOrigin;
- (NSSize)getFrameSize;
- (NSRect)getFrame;
- (void)setFrameOrigin:(NSPoint)o;
- (void)setFrameSize:(NSSize)s;
- (void)setFrame:(NSRect)r;

- (BOOL)hitTest:(NSPoint)p;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)dirtyRect;


@end
