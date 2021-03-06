//
//  DRRDock.h
//  Drawing
//
//  Created by Diego Giorgini on 14/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define llGray colorWithCalibratedRed:0.89 green:0.89 blue:0.89 alpha:1
#define ddBlue colorWithCalibratedRed:0.05 green:0.05 blue:0.1 alpha:1
#define ddBlue_legacy colorWithCalibratedRed:0.05 green:0.05 blue:0.1 alpha:1

//#define DEBUGDOCKDRAW
//#define DEBUGDOCKMOUSECORR

typedef enum drawingmodes {STROKENORMAL, STROKEALT, STROKEBOTH, FILLNORMAL, FILLALT, FILLBOTH} drawingmode_t;

@interface DRRPathObj : NSObject

@property NSBezierPath * path;

- (id)initWithPath:(NSBezierPath *)p;

@end



@interface DRRDrawingProperties : NSObject

@property NSColor * color;
@property drawingmode_t drawingMode;

+ (DRRDrawingProperties *)initWithColor:(NSColor *)color drawingMode:(drawingmode_t)mode;// altMode:(BOOL)flag;

- (id)init;

@end



void makePanButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes);
void makeZoomButton(NSRect frame, NSMutableArray * paths, NSMutableArray * modes);
void makeDrawFreeButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeDrawLineButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeBackButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeSaveButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeLoadButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeTrashButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makePlayButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);
void makeStopButton(NSRect frame, CGFloat roundness, NSMutableArray * paths, NSMutableArray * modes);



@interface DRRDockBar : NSView

- (BOOL)allowsVibrancy;

- (BOOL)preservesContentDuringLiveResize;

- (void)drawRect:(NSRect)dirtyRect;

- (void)mouseDown:(NSEvent *)theEvent;

@end



@protocol dockToView
- (void)updateCursor:(id)sender;
@end



@interface DRRDock : NSMatrix

@property (weak) id prevSelectCell;
@property (weak) id prevSelectCell_RMouse;
@property (weak) id prevSelectCell_playPause;
@property (weak) id <dockToView> dockdelegate;


- (id)init;
- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode cellClass:(Class)factoryId numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithFrame:(NSRect)frameRect mode:(NSMatrixMode)aMode prototype:(NSCell *)aCell numberOfRows:(NSInteger)rowsHigh numberOfColumns:(NSInteger)colsWide;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)setDefaultItemProperties;

//- (void)setFrameSize:(NSSize)newSize;
//- (BOOL)inLiveResize;

- (BOOL)preservesContentDuringLiveResize;
//- (void)setNeedsDisplay:(BOOL)flag;
//- (void)setNeedsDisplayInRect:(NSRect)invalidRect;

#ifdef DEBUGDOCKDRAW
- (void)drawRect:(NSRect)dirtyRect;
#endif

- (void)mouseDown:(NSEvent *)theEvent;

@end



@interface DRRButton : NSCell

@property NSMutableArray * btnpaths;
@property NSMutableArray * btnmodes;
@property BOOL altMode;
//@property NSInteger celltag;

+ (Class)cellClass;

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end



@interface DRRActionButton : NSActionCell

@property NSMutableArray * btnpaths;
@property NSMutableArray * btnmodes;
@property BOOL altMode;

+ (Class)cellClass;

- (id)initWithPaths:(NSMutableArray*)paths typeOfDrawing:(NSMutableArray*)modes;

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
