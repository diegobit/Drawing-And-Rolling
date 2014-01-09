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
@end



@interface DRRDock : NSMatrix {
    BOOL dockPrevResizeWasInLive;
}

@property id prevSelectedCell;
@property id <dockToView> dockdelegate;

- (id)init;
- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode cellClass:(Class)factoryId numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode prototype:(NSCell *)aCell numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)setDefaultItemProperties;

//- (BOOL)inLiveResize;

//- (void)drawRect:(NSRect)dirtyRect;

- (void)mouseDown:(NSEvent *)theEvent;

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
