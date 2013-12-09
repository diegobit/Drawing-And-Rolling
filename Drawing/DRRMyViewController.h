//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DRRPointObj : NSObject {
    NSPoint point;
}

- (id)initWithPoint:(NSPoint *)p;
//- (BOOL)isEmpty;
- (NSPoint)getPoint;
- (void)setPoint:(NSPoint *)p;

@end



NSRect computeRect(CGFloat x, CGFloat y, CGFloat w, CGFloat h, NSInteger border);



@interface DRRMyViewController : NSView {
    
    NSPoint prevmouseXY;
    //    NSRect prevbounds;
    
    NSMutableArray * linesContainer;
    NSInteger last;
    NSMutableArray * BezierPathsToDraw;
    
    BOOL linesNeedDisplay;
    
}

@end


@interface DRRMyCustomView

@end