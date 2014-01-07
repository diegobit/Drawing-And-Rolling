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


void makePanButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes);
void makeZoomButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes);
void makeDrawFreeButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeDrawLineButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeBackButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeSaveButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeLoadButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);


@protocol dockToView
- (void)updateCursor:(id)sender;
//- (void)callMyViewMethod:(id)sender;
@end



@interface DRRDock : NSMatrix {
//    id delegate;
    BOOL dockPrevResizeWasInLive;
//    NSPoint cellHighlighted;
}

@property id prevSelectedCell;
@property id <dockToView> dockdelegate;

- (id)init;
- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode cellClass:(Class)factoryId numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode prototype:(NSCell *)aCell numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)setDefaultItemProperties;

//- (BOOL)preservesContentDuringLiveResize;
//- (void)highlightCell:(BOOL)flag atRow:(NSInteger)row column:(NSInteger)column;
//- (NSPoint)getHighlightedCell;
//- (void)setHighlightedCell:(NSInteger)row atColumn:(NSInteger)column;
//- (BOOL)hasHighlightedCell;

//@property (readonly) NSRect frame;
//- (NSPoint)getFrameOrigin;
//- (NSSize)getFrameSize;
//- (void)setFrameOrigin:(NSPoint)o;
//- (void)setFrameSize:(NSSize)s;

//- (BOOL)hitTest:(NSPoint)p;
- (void)mouseDown:(NSEvent *)theEvent;
//- (void)mouseDragged:(NSEvent *)theEvent;
//- (void)mouseUp:(NSEvent *)theEvent;
//
//- (void)drawRect:(NSRect)dirtyRect;

@end



@interface DRRButton : NSCell

@property NSMutableArray * btnpaths;
@property NSMutableArray * btnmodes;

+ (Class)cellClass;

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end



@interface DRRActionButton : NSActionCell

@property NSMutableArray * btnpaths;
@property NSMutableArray * btnmodes;

+ (Class)cellClass;

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
