//
//  DRRDock.h
//  Drawing
//
//  Created by Diego Giorgini on 14/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#define DEBUGDOCKDRAW
//#define DEBUGDOCKMOUSECORR

typedef enum drawingmodes {STROKE, FILL} drawingmode_t;

@interface DRRPathObj : NSObject

@property NSBezierPath * path;

- (id)initWithPath:(NSBezierPath *)p;
//- (NSBezierPath *)getPoint;
//- (void)setPath:(NSBezierPath *)p;

@end



@interface DRRDrawingProperties : NSObject

@property NSColor * color;
@property drawingmode_t drawingMode;

+ (DRRDrawingProperties *)initWithColor:(NSColor *)color drawingMode:(drawingmode_t)mode;

- (id)init;

@end



void makeDrawFreeButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes);
void makeDrawLineButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes);
void makePanButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes);
void makeZoomButton(NSRect frame, CGFloat roundness, CGFloat linewidth, NSMutableArray * paths, NSMutableArray * modes);

@interface DRRDock : NSMatrix {
    BOOL dockPrevResizeWasInLive;
    NSPoint cellHighlighted;
}

- (id)init;
- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode cellClass:(Class)factoryId numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode prototype:(NSCell *)aCell numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)setDefaultItemProperties;

- (void)highlightCell:(BOOL)flag atRow:(NSInteger)row column:(NSInteger)column;
- (NSPoint)getHighlightedCell;
- (void)setHighlightedCell:(NSInteger)row atColumn:(NSInteger)column;
- (BOOL)hasHighlightedCell;

//@property (readonly) NSRect frame;
//- (NSPoint)getFrameOrigin;
//- (NSSize)getFrameSize;
//- (void)setFrameOrigin:(NSPoint)o;
//- (void)setFrameSize:(NSSize)s;

//- (BOOL)hitTest:(NSPoint)p;
//- (void)mouseDown:(NSEvent *)theEvent;
//- (void)mouseDragged:(NSEvent *)theEvent;
//- (void)mouseUp:(NSEvent *)theEvent;
//
//- (void)drawRect:(NSRect)dirtyRect;

@end



@interface DRRButton : NSCell {
    
    NSMutableArray * btnpaths;
    NSMutableArray * btnmodes;
//    // Un path per il bordo (serve per disegnarlo e per l'hitTest) e un path per il disegno al suo interno.
//    NSBezierPath * border;
//    NSBezierPath * innerborder;
//    NSBezierPath * pencilpoint;
//    NSBezierPath * pencilback;
//    
//    // Coordinate per il disegno del triangolo della punta della matita
//    CGFloat leftX;
//    CGFloat bottomY;
//    CGFloat topY;
//    CGFloat rightX;
//    // Coordinate per il resto della matita
//    NSPoint backTopLeft;
//    NSPoint backBottomRight;
//    // Spessore contorno matita
//    CGFloat linewidth;
}

//@property NSSize size;
//@property CGFloat roundness;
+ (Class)cellClass;

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes;

//- (id)setPathsToDraw:(NSMutableArray *)paths;
//
//- (id)setPathsDrawingMode:(NSMutableArray *)mode;
//
//- (void)mouseDown:(NSEvent *)theEvent;
////- (void)mouseDragged:(NSEvent *)theEvent;
//- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;


@end
