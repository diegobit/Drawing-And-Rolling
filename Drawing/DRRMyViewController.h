//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRPointObj.h"
#import "DRRMyControl.h"

#define DEBUGMODE 0

// costanti per indicare se una funzione: (1) non ha trovato l'elemento cercato; (2) parametro non valido
#define NOTFOUND -11
#define ARGERROR -10

// distanza tra due punti per essere considerati adiacenti
#define PTDISTANCE 20.0


/**
 *  Restituisce il rettangolo che ha come vertici i due punti passati come parametro
 */
NSRect computeRect(NSPoint p1, NSPoint p2, NSInteger border);


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

    // coordinata precedente mouse per mouseDragged (ridisegno solo zona cambiata)
    NSPoint prevmouseXY;
    
    // array dei bottoni dell'interfaccia
    NSMutableArray * controls;
    NSSize ctrlsize;
    
    // array e altro per contenere i punti del mouse da convertire in linee
    NSMutableArray * linesContainer;
    NSInteger last;
    NSMutableArray * BezierPathsToDraw;
    BOOL linesNeedDisplay;
    
    // Variabile booleana che indica se la linea che sto disegnando è nuova o verrà ancorata ad una vecchia
    BOOL thisIsANewLine;
    // Coppia di indici per individuare il punto a cui si ancorerà la nuova linea. Valido solo se vale thisIsANewLine
    NSPoint nearpointIdx;
    
    // path che contengono le linee da disegnare e i punti in cui viene rilevato il mouse
    NSBezierPath * pathLines, * pathSinglePoint;
    
}

//- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view;

- (id)initWithFrame:(NSRect)frameRect;
- (void)addEmptyLine;
- (void)addPointToLatestLine:(NSPoint*)p;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)dirtyRect;

@end










