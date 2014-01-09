//
//  DRRMyViewController.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRDock.h"

//#define DEBUGINIT
//#define DEBUGDRAW
//#define DEBUGLINES
//#define DEBUGLINESHIST
//#define DEBUGMATRIX
//#define DEBUGMOUSECORR
//#define DEBUGPROTOCOL

// costanti per indicare se una funzione:
#define NOTFOUND -11    // non ha trovato l'elemento cercato
#define ARGERROR -10    // parametro non valido

#define PTDISTANCE 12.0 // distanza tra due punti per essere considerati adiacenti



typedef enum customcursor {PANWAIT, PANACTIVE, ZOOM, ZOOMIN, ZOOMOUT, DRAW} customcursor_t;



@interface DRRSegmentIdx : NSObject

@property NSInteger idxline;
@property NSInteger idxstartpt;
@property NSInteger idxendpt;

- (id)initWithIndex:(NSInteger)iline indexTwo:(NSInteger)istartpt indexThree:(NSInteger)iendpt;

@end



@interface DRRMyViewController : NSControl <dockToView> {
    
    /// Indica se il tasto sinistro del mouse è premuto nel momento del controllo.
    BOOL leftpressed;
    /// Indica se il tasto destro del mouse è premuto nel momento del controllo.
    BOOL rightpressed;
    /// Indica se l'ultimo rididegno della vista era un ridimensionamento.
    BOOL viewPrevResizeWasInLive;
    /// coordinata precedente del mouse per mouseDragged.
    NSPoint prevmouseXY;
    /// Rettangolo dello schermo.
    NSRect screenRect;
    customcursor_t customCursor;
    
    NSAffineTransform * v2wTrans;
    NSAffineTransform * v2wScale;
    NSAffineTransform * w2vTrans;
    NSAffineTransform * w2vScale;
    
    CGFloat maxZoomFactor;
    CGFloat minZoomFactor;
    
    // Matrice che gestisce i bottoni dell'interfaccia. Grandezza controllo. Rotondità del bordo dei tasti.
    // Spessore linea del disegno interno dei controlli.
    DRRDock * dock;
    NSSize cellsize;
    CGFloat roundness;
    CGFloat linewidth;
    
    DRRButton * btnPan;
    DRRButton * btnZoom;
    DRRButton * btnDrawFree;
    DRRButton * btnDrawLine;
    DRRActionButton * btnBack;
    DRRActionButton * btnSave;
    DRRActionButton * btnLoad;
    
    NSString * filesavename; // ultimo nome file inserito dall'utente durante il salvataggio
    NSArray * fileTypes; // array di stringhe con le estensioni per salvare la mappa
    
    /// array e altro per contenere i punti del mouse da convertire in linee
    NSMutableArray * linesContainer;
    NSMutableArray * BezierPathsToDraw;
    NSMutableArray * linesHistory;
    
    /// Variabile booleana che indica se la linea che sto disegnando è nuova o verrà ancorata ad una vecchia
    BOOL thisIsANewLine;
    /// Coppia di indici per individuare il punto a cui si ancorerà la nuova linea. Valido solo se vale thisIsANewLine
    NSPoint nearpointIdx;
    /// Variabile booleana per sapere se è stata disegnata almeno una linea con i mouse dragged della mano libera
    BOOL atLeastOneStroke;
    /// Variabile temporanea dove tenere il punto durante il drawLine della linea retta
    NSPoint tempPoint;
    NSPoint prevTempPoint;
    /// Variabile booleana per sapere se la linea temporanea della linea retta è valida
    BOOL validLine;
    
    /// path che contiene le linee da disegnare e i punti in cui viene rilevato il mouse
    NSRect dirtyRect;
    NSBezierPath * pathLines, * pathSinglePoint; //, * pathNearPoint;
    
}

- (id)initWithFrame:(NSRect)frameRect;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)awakeFromNib;
- (void)setItemPropertiesToDefault;

- (void)saveToFile;
- (void)loadFromFile;

/*! Trova i punti adiacenti al punto passato come parametro. Cerca tra le linee già disegnate (LinesContainer). Controlla solo i vertici delle linee.
 \param pt il punto da cercare.
 \returns una coppia di indici dentro un NSPoint:
            "x" è l'indice nell'array linesarr;
            "y" è l'indice del punto nella linea;
 */
- (NSPoint)findAdiacentVertex:(NSPoint) pt;
/*! Calcola il rettangolo contenente i due punti passati come parametri.
 \param p1 Il primo dei due punti.
 \param p2 L'altro punto.
 \param border Indica quanto deve essere ridimensionato il rettangolo: positivo ingrandisce, negativo rimpicciolisce.
 \returns il rettangolo calcolato.
 */
- (NSRect)computeRect:(NSPoint)p1 secondPoint:(NSPoint)p2 moveBorder:(CGFloat)border;
/*! Calcola la distanza tra due punti.
 \param p1 Il primo dei due punti.
 \param p2 L'altro punto.
 \returns Il valore della distanza.
 */
- (CGFloat)distanceBetweenPoint:(NSPoint)p1 andPoint:(NSPoint)p2;

/** Metodi per aggiungere linee da disegnare e rimuoverle */
- (void)addEmptyLine;
- (void)addPointToLatestLine:(NSPoint*)p;
- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx;
- (void)addLineToHistory;
- (void)removeLatestLine;

- (void)move:(BOOL)invalidate translation:(NSSize)mstep;
- (BOOL)scale:(CGFloat)sstep maxZoom:(CGFloat)upperbound minZoom:(CGFloat)lowerbound;
- (void)updateCursor:(id)sender;

- (void)setFrameSize:(NSSize)newSize;
- (BOOL)inLiveResize;

- (void)drawRect:(NSRect)dirtyRect;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- (void)rightMouseUp:(NSEvent *)theEvent;

@end


