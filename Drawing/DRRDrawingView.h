//
//  DRRDrawingView.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "DRRDock.h"
#import "DRRScene.h"

//#define DEBUGINIT
//#define DEBUGDRAW
//#define DEBUGLINES
//#define DEBUGLINESHIST
//#define DEBUGMATRIX
//#define DEBUGMOUSECORR
//#define DEBUGPROTOCOL

// costanti per indicare se una funzione:
#define NOTFOUND -11    // non ha trovato l'elemento cercato
//#define ARGERROR -10    // parametro non valido

#define PTDISTANCE 12.0 // distanza tra due punti per essere considerati adiacenti



typedef enum customcursor {PANWAIT, PANACTIVE, PANBALL, ZOOM, ZOOMIN, ZOOMOUT, DRAW} customcursor_t;



@interface DRRSegmentIdx : NSObject

@property NSInteger idxline;
@property NSInteger idxstartpt;
@property NSInteger idxendpt;

- (id)initWithIndex:(NSInteger)iline indexTwo:(NSInteger)istartpt indexThree:(NSInteger)iendpt;

@end



@interface DRRBall : NSObject

@property NSPoint center;
@property NSRect rect;
@property CGFloat radius;
@property BOOL isAlreadyPlaced;
@property BOOL isAlreadyTempPlaced;
@property NSBezierPath * circle;

//- (NSPoint)getCenter;
- (id)init;
- (id)initWithRadius:(CGFloat)r;
- (BOOL)hitTest:(NSPoint)p;
- (void)setCenterPosition:(NSPoint)p;

@end



@interface DRRDrawingView : NSView <dockToView> {
    IBOutlet DRRDockBar * dockBar;
}
    
/// Indica se il tasto sinistro del mouse è premuto nel momento del controllo.
@property BOOL leftpressed;
/// Indica se il tasto destro del mouse è premuto nel momento del controllo.
@property BOOL rightpressed;
@property BOOL ballPressed;
/// Indica se l'ultimo ridisegno della vista era un ridimensionamento.
@property BOOL viewPrevResizeWasInLive;
@property BOOL prevInLiveMovement;
@property BOOL inLiveMovement;
/// coordinata precedente del mouse per mouseDragged.
@property NSPoint prevmouseXY;
/// Rettangolo dello schermo.
@property NSRect screenRect;
/// Frame della scena: vista completa meno i bottoni
@property NSRect sceneRect;
@property DRRSceneView * sceneView;
@property customcursor_t customCursor;

@property NSAffineTransform * v2wTrans;
@property NSAffineTransform * v2wScale;
@property NSAffineTransform * w2vTrans;
@property NSAffineTransform * w2vScale;
@property NSSize w2vTransFactor;
@property CGFloat w2vScaleFactor;

@property CGFloat maxZoomFactor;
@property CGFloat minZoomFactor;

// Matrice che gestisce i bottoni dell'interfaccia. Grandezza controllo. Rotondità del bordo dei tasti.
// Spessore linea del disegno interno dei controlli.
//@property IBOutlet DRRDockBar * dockBar;
@property DRRDock * dock;
@property NSSize cellsize;
@property CGFloat roundness;
@property CGFloat linewidth;

//@property NSColor * dockBackgroundColor;
@property DRRButton * btnPan;
@property DRRButton * btnZoom;
@property DRRButton * btnDrawFree;
@property DRRButton * btnDrawLine;
@property DRRActionButton * btnBack;
@property DRRActionButton * btnSave;
@property DRRActionButton * btnLoad;
@property DRRActionButton * btnPlay;
@property DRRActionButton * btnPause;
@property DRRActionButton * btnStop;

@property NSString * filesavename; // ultimo nome file inserito dall'utente durante il salvataggio
@property NSArray * fileTypes; // array di stringhe con le estensioni per salvare la mappa

/// array e altro per contenere i punti del mouse da convertire in linee
@property NSMutableArray * linesContainer;
@property NSMutableArray * BezierPathsToDraw;
@property NSMutableArray * linesHistory;
@property DRRBall * ball;
@property BOOL linesContainerHasChanged;

/// Variabile booleana che indica se la linea che sto disegnando è nuova o verrà ancorata ad una vecchia
@property BOOL thisIsANewLine;
/// Coppia di indici per individuare il punto a cui si ancorerà la nuova linea. Valido solo se vale thisIsANewLine
@property NSPoint nearpointIdx;
/// Variabile booleana per sapere se è stata disegnata almeno una linea con i mouse dragged della mano libera
@property BOOL atLeastOneStroke;
/// Variabile temporanea dove tenere il punto durante il drawLine della linea retta
@property NSPoint tempPoint;
@property NSPoint prevTempPoint;
/// Variabile booleana per sapere se la linea temporanea della linea retta è valida
@property BOOL validLine;

/// path che contiene le linee da disegnare e i punti in cui viene rilevato il mouse
@property NSRect dirtyRect;
@property NSBezierPath * pathLines;
@property NSBezierPath * pathSinglePoint; //, * pathNearPoint;
@property NSBezierPath * pathBall;

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

- (void)move:(NSSize)mstep invalidate:(BOOL)flag;
- (BOOL)scale:(CGFloat)sstep maxZoom:(CGFloat)upperbound minZoom:(CGFloat)lowerbound;
- (void)updateCursor:(id)sender;

- (void)setFrameSize:(NSSize)newSize;
- (BOOL)inLiveResize;
- (BOOL)inLivePanOrScale;
- (void)setNeedsDisplay:(BOOL)flag;
- (void)setNeedsDisplayInRect:(NSRect)invalidRect;

- (void)drawRect:(NSRect)dirtyRect;

- (void)startOrPauseScene;
- (void)stopScene;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- (void)rightMouseUp:(NSEvent *)theEvent;

@end


