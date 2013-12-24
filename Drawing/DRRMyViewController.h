//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRPointObj.h"
//#import "DRRMyControl.h"
#import "DRRDock.h"

//#define DEBUGINIT
//#define DEBUGDRAW
//#define DEBUGLINES
//#define DEBUGLINESHIST
//#define DEBUGMOUSECORR

// costanti per indicare se una funzione: (1) non ha trovato l'elemento cercato; (2) parametro non valido
#define NOTFOUND -11
#define ARGERROR -10

// distanza tra due punti per essere considerati adiacenti
#define PTDISTANCE 12.0


@interface DRRSegmentIdx : NSObject

@property NSInteger idxline;
@property NSInteger idxstartpt;
@property NSInteger idxendpt;

- (id)initWithIndex:(NSInteger)iline indexTwo:(NSInteger)istartpt indexThree:(NSInteger)iendpt;

@end


/**
 *  Funzione che cerca nell'array di linee passato come parametro un punto che sia adiacente a pt.
 *  I punti tra cui si cerca sono i vertici di ogni linea dell'array.
 *  Per "adiacenti" si intende che i due punti sono ad una certa distanza limitata da PTDISTANCE
 *
 *  Restituisce una coppia di indici dentro un NSPoint:
 *      "x" è l'indice nell'array linesarr.
 *      "y" è l'indice del punto nella linea.
 */
NSPoint findAdiacentVertex(NSMutableArray * linesarr, NSPoint pt);


/**
 *  Parte principale dell'applicazione.
 */
@interface DRRMyViewController : NSControl {
    
//    IBOutlet NSController *controller;
    
    BOOL leftpressed;
    BOOL rightpressed;
    BOOL viewPrevResizeWasInLive;
    
    // coordinata precedente mouse per mouseDragged (ridisegno solo zona cambiata)
    // e coordinata iniziale del trascinamento per la cronologia
    NSPoint prevmouseXY;
    NSRect screenRect;
    
    // Matrice che gestisce i bottoni dell'interfaccia. Grandezza controllo. Rotondità del bordo dei tasti.
    // Spessore linea del disegno interno dei controlli.
    NSMatrix * dock;
    NSMutableArray * cellpaths;
    NSMutableArray * cellmodes;
    NSSize cellsize;
    CGFloat roundness;
    CGFloat linewidth;
    
    // array e altro per contenere i punti del mouse da convertire in linee
    NSMutableArray * linesContainer;
//    NSInteger last;
    NSMutableArray * BezierPathsToDraw;
    BOOL linesNeedDisplay;
    
    NSMutableArray * linesHistory;
//    BOOL lastPtOfLine;
//    BOOL firstPtOfLine;
//    NSInteger idxFirstPtOfLine;
    
    // Variabile booleana che indica se la linea che sto disegnando è nuova o verrà ancorata ad una vecchia
    BOOL thisIsANewLine;
    // Coppia di indici per individuare il punto a cui si ancorerà la nuova linea. Valido solo se vale thisIsANewLine
    NSPoint nearpointIdx;
    // Variabile booleana per sapere se è stata disegnta almeno una linea con i mouse dragged
    BOOL atLeastOneStroke;
    
    // path che contengono le linee da disegnare e i punti in cui viene rilevato il mouse
    NSRect dirtyRect;
    NSBezierPath * pathLines, * pathSinglePoint;
    
}

//- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view;

- (id)initWithFrame:(NSRect)frameRect;
- (void)awakeFromNib;
- (id)initWithCoder:(NSCoder *)aDecoder;

/** Restituisce il rettangolo che ha come vertici i due punti passati come parametro */
- (NSRect)computeRect:(NSPoint)p1 secondPoint:(NSPoint)p2 moveBorder:(CGFloat)border;
- (NSRect)computeRectFromArray:(NSMutableArray *)points moveBorder:(CGFloat)border;
- (void)addEmptyLine;
- (CGFloat)distanceBetweenPoint:(NSPoint)p1 andPoint:(NSPoint)p2;
- (void)addPointToLatestLine:(NSPoint*)p;
- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx;

//- (IBAction)cellPressed:(id)sender;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- (void)rightMouseUp:(NSEvent *)theEvent;

- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(NSRect)invalidRect;
- (BOOL)inLiveResize;
- (void)drawRect:(NSRect)dirtyRect;

@end





