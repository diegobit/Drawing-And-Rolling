//
//  DRRDrawingView.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRDrawingView.h"



@implementation DRRSegmentIdx

- (id)initWithIndex:(NSInteger)iline indexTwo:(NSInteger)istartpt indexThree:(NSInteger)iendpt {
    
    self = [super init];
    if (self) {
        self.idxline = iline;
        self.idxstartpt = istartpt;
        self.idxendpt = iendpt;
    }
    return self;
    
}

@end



@implementation DRRBall

//- (NSPoint)getCenter {
//    return self.center;
//}
- (id)init {
    self = [super init];
    if (self) {
        self.radius = 1;
        self.center = NSMakePoint(0, 0);
        self.circle = [[NSBezierPath alloc] init];
    }
    return self;
}

- (id)initWithRadius:(CGFloat)r {
    self = [super init];
    if (self) {
        self.radius = r;
        self.center = NSMakePoint(0, 0);
        self.circle = [[NSBezierPath alloc] init];
    }
    return self;
}

- (void)setCenterPosition:(NSPoint)p {
    self.center = p;
    self.rect = NSMakeRect(p.x - self.radius, p.y - self.radius,
                           self.radius * 2, self.radius * 2);
    [self.circle removeAllPoints];
    [self.circle appendBezierPathWithOvalInRect:self.rect];
}

- (BOOL)hitTest:(NSPoint)p {
    return [self.circle containsPoint:p];
}

@end



@implementation DRRDrawingView

- (id)initWithFrame:(NSRect)frameRect {
    
    #ifdef DEBUGINIT
    NSLog(@"initWithFrame myView");
    #endif

    self = [super initWithFrame:frameRect];
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    #ifdef DEBUGINIT
    NSLog(@"initWithCoder myView");
    #endif
    
    self = [super initWithCoder:aDecoder];
    return self;
    
}

- (void)awakeFromNib {
    
    #ifdef DEBUGINIT
    NSLog(@"awakeFromNib myView");
    #endif
    
    [super awakeFromNib];
    [self setWantsLayer:YES];
    self.ball = [[DRRBall alloc] initWithRadius:BALLRADIUS];
    
    // Dimensione bottoni della dock, spessore line del disegno interno. Rotondità tasti.
    self.cellsize = NSMakeSize(40, 40);
    self.linewidth = (self.cellsize.width + self.cellsize.height) / 32;
    if (self.linewidth < 1) self.linewidth = 1;
    self.roundness = (self.cellsize.width + self.cellsize.height) / 8;
    
    [self setItemPropertiesToDefault];
    
    self.linesContainerHasChanged = NO;
    
    // nome base salvataggio file. Estensioni
    self.filesavename = @"map";
    self.fileTypes = [NSArray arrayWithObjects:@"dsf", nil];
    
    // Creo la dock e i bottoni
    self.dock = [[DRRDock alloc] initWithFrame:NSMakeRect(1, 0, 1, 1)
                                          mode:NSRadioModeMatrix
                                     cellClass:[DRRButton class]
                                  numberOfRows:10
                               numberOfColumns:1];
    [self.dock setDockdelegate:self];
    [self.dock setCellSize:self.cellsize];
    
    NSMutableArray * panPaths = [[NSMutableArray alloc] init];
    NSMutableArray * panModes = [[NSMutableArray alloc] init];
    makePanButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y, self.dock.cellSize.width, self.dock.cellSize.height), panPaths, panModes);
    self.btnPan = [[DRRButton alloc] initWithPaths:panPaths typeOfDrawing:panModes];
    [self.dock putCell:self.btnPan atRow:0 column:0];
    
    NSMutableArray * zoomPaths = [[NSMutableArray alloc] init];
    NSMutableArray * zoomModes = [[NSMutableArray alloc] init];
    makeZoomButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 1 + (1 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), zoomPaths, zoomModes);
    self.btnZoom = [[DRRButton alloc] initWithPaths:zoomPaths typeOfDrawing:zoomModes];
    [self.dock putCell:self.btnZoom atRow:1 column:0];
    
    NSMutableArray * drawFreePaths = [[NSMutableArray alloc] init];
    NSMutableArray * drawFreeModes = [[NSMutableArray alloc] init];
    makeDrawFreeButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 2 + (2 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, drawFreePaths, drawFreeModes);
    self.btnDrawFree = [[DRRButton alloc] initWithPaths:drawFreePaths typeOfDrawing:drawFreeModes];
    [self.dock putCell:self.btnDrawFree atRow:2 column:0];
    [self.dock setState:NSOnState atRow:2 column:0];
    self.dock.prevSelectCell = [self.dock selectedCell];
    self.dock.prevSelectCell_RMouse = [self.dock selectedCell];
    self.dock.prevSelectCell_playPause = [self.dock selectedCell];
    
    NSMutableArray * drawLinePaths = [[NSMutableArray alloc] init];
    NSMutableArray * drawLineModes = [[NSMutableArray alloc] init];
    makeDrawLineButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 3 + (3 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, drawLinePaths, drawLineModes);
    self.btnDrawLine = [[DRRButton alloc] initWithPaths:drawLinePaths typeOfDrawing:drawLineModes];
    [self.dock putCell:self.btnDrawLine atRow:3 column:0];
    
    NSMutableArray * backPaths = [[NSMutableArray alloc] init];
    NSMutableArray * backModes = [[NSMutableArray alloc] init];
    makeBackButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 4 + (4 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, backPaths, backModes);
    self.btnBack = [[DRRActionButton alloc] initWithPaths:backPaths typeOfDrawing:backModes];
    SEL undo = @selector(removeLatestLine);
    [self.btnBack setAction:undo];
    [self.btnBack setTarget:self];
    [self.dock putCell:self.btnBack atRow:4 column:0];

    NSMutableArray * savePaths = [[NSMutableArray alloc] init];
    NSMutableArray * saveModes = [[NSMutableArray alloc] init];
    makeSaveButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 5 + (5 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, savePaths, saveModes);
    self.btnSave = [[DRRActionButton alloc] initWithPaths:savePaths typeOfDrawing:saveModes];
    SEL save = @selector(saveToFile);
    [self.btnSave setAction:save];
    [self.btnSave setTarget:self];
    [self.dock putCell:self.btnSave atRow:5 column:0];

    NSMutableArray * loadPaths = [[NSMutableArray alloc] init];
    NSMutableArray * loadModes = [[NSMutableArray alloc] init];
    makeLoadButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 6 + (6 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, loadPaths, loadModes);
    self.btnLoad = [[DRRActionButton alloc] initWithPaths:loadPaths typeOfDrawing:loadModes];
    SEL load = @selector(loadFromFile);
    [self.btnLoad setAction:load];
    [self.btnLoad setTarget:self];
    [self.dock putCell:self.btnLoad atRow:6 column:0];
    
    NSMutableArray * trashPaths = [[NSMutableArray alloc] init];
    NSMutableArray * trashModes = [[NSMutableArray alloc] init];
    makeTrashButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 7 + (7 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, trashPaths, trashModes);
    self.btnTrash = [[DRRActionButton alloc] initWithPaths:trashPaths typeOfDrawing:trashModes];
    SEL trash = @selector(resetMap);
    [self.btnTrash setAction:trash];
    [self.btnTrash setTarget:self];
    [self.dock putCell:self.btnTrash atRow:7 column:0];
    
    NSMutableArray * playPaths = [[NSMutableArray alloc] init];
    NSMutableArray * playModes = [[NSMutableArray alloc] init];
    makePlayButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 8 + (8 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, playPaths, playModes);
    self.btnPlay = [[DRRActionButton alloc] initWithPaths:playPaths typeOfDrawing:playModes];
    SEL play_pause = @selector(startOrPauseScene);
    [self.btnPlay setAction:play_pause];
    [self.btnPlay setTarget:self];
    [self.dock putCell:self.btnPlay atRow:8 column:0];
    [self.dock setKeyCell:self.btnPlay]; // Cella da premere con la barra spazio
    
    NSMutableArray * stopPaths = [[NSMutableArray alloc] init];
    NSMutableArray * stopModes = [[NSMutableArray alloc] init];
    makeStopButton(NSMakeRect(self.dock.frame.origin.x, self.dock.frame.origin.y + 9 + (9 * self.dock.cellSize.height), self.dock.cellSize.width, self.dock.cellSize.height), self.roundness, stopPaths, stopModes);
    self.btnStop = [[DRRActionButton alloc] initWithPaths:stopPaths typeOfDrawing:stopModes];
    SEL stop = @selector(stopScene);
    [self.btnStop setAction:stop];
    [self.btnStop setTarget:self];
    [self.dock putCell:self.btnStop atRow:9 column:0];
    
    [self.dock sizeToCells];
    
    CGFloat heightBetweenDockAndTop = (self.frame.size.height - self.dock.frame.size.height);
    [self.dock setFrameOrigin:NSMakePoint(self.dock.frame.origin.x,
                                          self.frame.origin.y + (heightBetweenDockAndTop / 2))];
    
    [dockBar addSubview:self.dock];
    [self.dock.dockdelegate updateCursor:self];
    
    [self.window setMinSize:NSMakeSize(self.dock.frame.size.height / 4,
                                       self.dock.frame.size.height + self.dock.cellSize.height)];
    
    // Ora inizializzo e aggiungo la vista che gestirà la scena.
    self.sceneView = [[DRRSceneView alloc] initWithFrame:self.bounds];
    [self.sceneView.scene setPaused:YES];
    [self.sceneView setHidden:YES];
    [self addSubview:self.sceneView];
    
    // Aggiungo l'handler degli eventi della tastiera
    self.eventMonitor =
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
                                          handler:^NSEvent * (NSEvent * theEvent) {
                                              int found = NO;
                                              
                                              switch ([theEvent keyCode]) {
                                                  case 123:             // Freccia sinistra
                                                      [self move:NSMakeSize(-20, 0) invalidate:YES];
                                                      found = YES;
                                                      break;
                                                  case 124:             // Freccia destra
                                                      [self move:NSMakeSize(20, 0) invalidate:YES];
                                                      found = YES;
                                                      break;
                                                  case 125:             // Freccia giù
                                                      [self move:NSMakeSize(0, -20) invalidate:YES];
                                                      found = YES;
                                                      break;
                                                  case 126:             // Freccia su
                                                      [self move:NSMakeSize(0, 20) invalidate:YES];
                                                      found = YES;
                                                      break;
                                                      
                                                  case 51:              // delete
                                                      [self removeLatestLine];
                                                      found = YES;
                                                      break;
                                                  case 48:              // TAB
                                                      [self switchToLastButton];
                                                      found = YES;
                                                      break;
                                                  case 49:              // barra spazio
                                                      [self startOrPauseScene];
//                                                      [self.dock selectCell:self.btnPlay];
//                                                      [self.btnPlay setAltMode:YES];
                                                      found = YES;
                                                      break;
                                                  case 53:              // esc
                                                      [self stopScene];
                                                      found = YES;
                                                      break;
                                                  default:
                                                      break;
                                              }
                                              
                                              if (found)
                                                  return nil; // NON invio l'evento se ho premuto un tasto
                                              else
                                                  return theEvent;
                                          }];
}

- (void)setItemPropertiesToDefault {
    
    #ifdef DEBUGINIT
    NSLog(@"setItemProperties myView");
    #endif
    
    self.viewPrevResizeWasInLive = NO;
    self.prevInLiveMovement = NO;
    self.inLiveMovement = NO;
    self.validLine = NO;
    self.thisIsANewLine = YES;
    self.dirtyRect = NSMakeRect(0, 0, 1, 1);
    self.customCursor = DRAW;
    self.maxZoomFactor = 1;
    self.minZoomFactor = 0.25;
    
    // inizializzo l'array di linee disegnate, le proprietà e altri paths
    self.linesContainer = [[NSMutableArray alloc] init];
    self.linesHistory = [[NSMutableArray alloc] init];
    self.pathLines = [NSBezierPath bezierPath];
    [self.pathLines setLineWidth:2];
    self.pathSinglePoint = [NSBezierPath bezierPath];
    self.pathBall = [NSBezierPath bezierPath];
    self.nearpointIdx = NSMakePoint(NOTFOUND, NOTFOUND);
    
    [self.ball setIsAlreadyPlaced:NO];
    [self.ball setIsAlreadyTempPlaced:NO];
    
    self.screenRect = [[NSScreen mainScreen] frame];
    self.v2wTrans = [NSAffineTransform transform];
    self.v2wScale = [NSAffineTransform transform];
    self.w2vTrans = [NSAffineTransform transform];
    self.w2vScale = [NSAffineTransform transform];
    self.initMove = CGVectorMake(0, 0);
    
}

- (BOOL)allowsVibrancy {
    return YES;
}



- (void)saveToFile {

    NSSavePanel * panel = [NSSavePanel savePanel];
    [panel setCanCreateDirectories:YES];
    [panel setCanSelectHiddenExtension:YES];
    [panel setAllowedFileTypes:self.fileTypes];
    [panel setNameFieldStringValue:self.filesavename];
    [panel setTitle:@"Save map to file"];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        NSURL * fileURL = [panel URL];
        panel = nil;
        self.filesavename = [[[fileURL absoluteString] lastPathComponent] stringByDeletingPathExtension];
        NSMutableString * fullstring = [[NSMutableString alloc] initWithString:@""];
        
        // scorro le linee dell'array
        [self.linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger idx, BOOL *stop) {
            if (idx > 0)
                [fullstring appendString:@"\n"]; // divido le linee con \n
            
            // per ogni punto della linea, aggiungo il punto ad una stringa
            [line enumerateObjectsUsingBlock:^(id point, NSUInteger idx, BOOL *stop) {
                NSString * pstr = NSStringFromPoint([point pointValue]);
                [fullstring appendString:pstr];
                [fullstring appendString:@";"];
            }];
        }];
        
        [fullstring appendString:@"||"];
        
        // Aggiungo la history, scorro le entry dell'array
        [self.linesHistory enumerateObjectsUsingBlock:^(DRRSegmentIdx * entry, NSUInteger idx, BOOL *stop) {
            if (idx > 0)
                [fullstring appendString:@"\n"]; // divido le linee con \n
            
            // per ogni entry DRRSegmentIdx salvo i 3 indici
            [fullstring appendString:[NSString stringWithFormat:@"%ld;%ld;%ld", entry.idxline, entry.idxstartpt, entry.idxendpt]];
        }];
        
        [fullstring appendString:@"||"];
        
        // Aggiungo la posizione della palla
        [fullstring appendString:NSStringFromPoint(self.ball.center)];
        
        // Scrivo sul file scelto
        [fullstring writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
    
}

- (void)loadFromFile {
    
    [self.sceneView setPaused:YES];
    
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setCanCreateDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanSelectHiddenExtension:YES];
    [panel setAllowedFileTypes:self.fileTypes];
    [panel setTitle:@"Load map from file"];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        
        NSStringEncoding * enc = NULL;
//        NSError *__autoreleasing * err = NULL;
        NSString * filecontent = [NSString stringWithContentsOfURL:[panel URLs][0] usedEncoding:enc error:NULL];
        panel = nil;
        
        if (filecontent != nil) {
            
            [self stopScene];
            [self.sceneView clearScene];
            [self.sceneView setItemPropertiesToDefault];
            [self setItemPropertiesToDefault];
            
            NSArray * filecontentdivided = [filecontent componentsSeparatedByString:@"||"];
            
            // Ricostruisco l'array di linee
            NSArray * rawlines = [filecontentdivided[0] componentsSeparatedByString:@"\n"];
            [rawlines enumerateObjectsUsingBlock:^(NSString * strline, NSUInteger idx, BOOL *stop) {
                // Prendo la stringa con dentro i punti (in forma {37, 40};{54, 60} ), li separo aggiungendoli ad un NSArray. Poi creo un NSMutableArray. Poi scorro questi punti, i converto da stringa a NSPoint e poi li incapsulo in un NSValue per aggiungerli al NSMutableArray.
                NSMutableArray * line = [[NSMutableArray alloc] init];
                NSArray * strpointline = [strline componentsSeparatedByString:@";"];
                [strpointline enumerateObjectsUsingBlock:^(NSString * strpoint, NSUInteger idxp, BOOL *stop) {
                    NSPoint point = NSPointFromString(strpoint);
                    if (point.x != 0 && point.y != 0) { // TODO: risolvere meglio bug: unisce tutte le linee col punto 0,0
                        [line addObject:[NSValue valueWithPoint:point]];
                    }
                }];
                [self.linesContainer addObject:line];
            }];
            
            // Ricostruisco l'history
            // Prima divido le linee dalla palla
            NSArray * rawhistory = [filecontentdivided[1] componentsSeparatedByString:@"\n"];
            [rawhistory enumerateObjectsUsingBlock:^(NSString * entry, NSUInteger idx, BOOL *stop) {
                DRRSegmentIdx * indexes = [[DRRSegmentIdx alloc] init];
                NSArray * entrydivided = [entry componentsSeparatedByString:@";"];
                [entrydivided enumerateObjectsUsingBlock:^(NSString * singleidx, NSUInteger idx, BOOL *stop) {
                    if (idx == 0)
                        indexes.idxline = [singleidx integerValue];
                    else if (idx == 1)
                        indexes.idxstartpt = [singleidx integerValue];
                    else
                        indexes.idxendpt = [singleidx integerValue];
                }];
                [self.linesHistory addObject:indexes];
            }];
            
            // Imposto la posizione della palla
            NSString * rawballpos = filecontentdivided[2];
            NSPoint ballpos = NSPointFromString(rawballpos);
            if (ballpos.x != 0 && ballpos.y != 0) {
                [self.ball setCenterPosition:ballpos];
                self.ball.isAlreadyPlaced = YES;
            }
            
            self.linesContainerHasChanged = YES;
            [self setNeedsDisplay:YES];
            
        }
        
        else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"Errore nel caricamento del file"];
        }
        
    } // fine panel richiesta file
    
}

- (void)resetMap {

    if ([self.sceneView isHidden]) {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Reset current map?"];
        [alert setInformativeText:@"You can't undo this."];
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Abort"];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            
            [self stopScene];
            [self.sceneView setItemPropertiesToDefault];
            [self.sceneView clearScene];
            [self setItemPropertiesToDefault];
            
//            self.sceneView = [[DRRSceneView alloc] initWithFrame:self.bounds];
//            [self.sceneView.scene setPaused:YES];
//            [self.sceneView setHidden:YES];
            
            [self setNeedsDisplay:YES];
        }
    }
    
}



- (NSPoint)findAdiacentVertex:(NSPoint) pt {
    
    __block NSPoint doubleidx;
    __block BOOL found = NO;
    
    if ([self.linesContainer count] > 0) {
        // comincio il ciclo: per ogni oggetto dell'array (NSMutableArray di NSPoint)...
        [self.linesContainer enumerateObjectsWithOptions:NSEnumerationReverse
                                              usingBlock:^(id line, NSUInteger idx, BOOL *stop) {
                                                  
                                                  // ...cerco i punti i cui indici sono il primo e l'ultimo della linea
                                                  NSInteger endidx = [line count] - 1;
                                                  NSPoint startp = [line[0] pointValue];
                                                  NSPoint endp = [line[endidx] pointValue];
                                                  
                                                  // e controllo la loro distanza dal mio punto: punto finale...
                                                  if ((fabs(endp.x - pt.x) <= PTDISTANCE) && (fabs(endp.y - pt.y) <= PTDISTANCE) && !((fabs(endp.x - pt.x) > PTDISTANCE*0.7) && (fabs(endp.y - pt.y) > PTDISTANCE*0.7))) {
                                                      *stop = YES; found = YES;
                                                      doubleidx = NSMakePoint(idx, endidx);
                                                  }
                                                  // ...e punto iniziale
                                                  else if ((fabs(startp.x - pt.x) <= PTDISTANCE) && (fabs(startp.y - pt.y) <= PTDISTANCE) && !((fabs(startp.x - pt.x) > PTDISTANCE*0.7) && (fabs(startp.y - pt.y) > PTDISTANCE*0.7))) {
                                                      *stop = YES; found = YES;
                                                      
                                                      // rigiro l'array in modo da poter continuare la linea aggiungendo punti alla fine
                                                      // TODO: brutto sistema...
                                                      NSValue * temp;
                                                      NSInteger i, j;
                                                      for (i = 0, j = [line count] - 1; i < j; i++, j--) {
                                                          temp = line[i];
                                                          line[i] = line[j];
                                                          line[j] = temp;
                                                      }
                                                      
                                                      doubleidx = NSMakePoint(idx, endidx);
                                                  }
                                              }];
    }
    
    // arrivo qui solo se l'array delle linee è vuoto oppure se non ho trovato un punto adiacente al mio
    if (!found) doubleidx.x = NOTFOUND;
    return doubleidx;
    
}

- (NSRect)computeRect:(NSPoint)p1 secondPoint:(NSPoint)p2 moveBorder:(CGFloat)border {
    
    NSPoint bb = [self.w2vScale transformPoint:NSMakePoint(border, border)];
    CGFloat borderscaled = bb.x;
    
    CGFloat x = fmin(p1.x, p2.x) - borderscaled; CGFloat y = fmin(p1.y, p2.y) - borderscaled;
    CGFloat raww = p2.x - p1.x; CGFloat rawh = p2.y - p1.y;
    CGFloat w = fabs(raww) + 2*borderscaled; CGFloat h = fabs(rawh) + 2*borderscaled;
    
    return NSMakeRect(x, y, w, h);
}

- (CGFloat)distanceBetweenPoint:(NSPoint)p1 andPoint:(NSPoint)p2 {

    CGFloat dX = fabs(p1.x - p2.x);
    CGFloat dY = fabs(p1.y - p2.y);
    CGFloat d = sqrt((dX*dX) + (dY*dY)); // TODO: si può migliorare?
    
    return d;
    
}



- (void)switchToLastButton {
    if (self.dock.selectedCell != self.btnPan) {
        self.dock.prevSelectCell_RMouse = self.dock.selectedCell;
        [self.dock selectCell:self.btnPan];
    }
    else {
        DRRButton * temp = self.dock.selectedCell;
        [self.dock selectCell:self.dock.prevSelectCell_RMouse];
        self.dock.prevSelectCell_RMouse = temp;
    }
    
    [self updateCursor:self];
}



- (void)addEmptyLine {

    NSMutableArray * line = [[NSMutableArray alloc] init];
    [self.linesContainer addObject:line];
    
}

- (void)addPointToLatestLine:(NSPoint *)p {
    
    if (p != NULL) {
        NSInteger last = [self.linesContainer count] - 1;
        [self.linesContainer[last] addObject:[NSValue valueWithPoint:*p]];
        self.linesContainerHasChanged = YES;
    }
    else
        errno = EINVAL;
    
}

- (void)addPointToIdxLine:(NSPoint*)p idxLinesArray:(NSInteger)idx {
    
    if (p != NULL) {
        [self.linesContainer[idx] addObject:[NSValue valueWithPoint:*p]];
        self.linesContainerHasChanged = YES;
    }
    else
        errno = EINVAL;
    
}

- (void)addLineToHistory {
    
    if (!self.thisIsANewLine) {
        NSInteger idxline = (NSInteger) self.nearpointIdx.x;
        NSInteger idxstart = (NSInteger) self.nearpointIdx.y;
        NSMutableArray * thisline = self.linesContainer[idxline];
        NSInteger lastpointidx = [thisline count] - 1;
        DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
        [self.linesHistory addObject:idxs];
    }
    else {
        NSInteger lastlineidx = [self.linesContainer count] - 1;
        NSInteger lastpointidx = [self.linesContainer[lastlineidx] count] - 1;
        DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
        [self.linesHistory addObject:idxs];
    }
    
}

- (void)removeLatestLine {
    
    if (self.sceneView.isHidden) {
        if ([self.linesHistory count] > 0) {
            
            #ifdef DEBUGLINESHIST
            NSLog(@"removeLatestLine: c'è una limea da rimuovere");
            #endif
            
            DRRSegmentIdx * idxs = [self.linesHistory lastObject];
            NSMutableArray * line = self.linesContainer[idxs.idxline];
            NSInteger i = 0;
            NSMutableArray * dirtyPoints = [[NSMutableArray alloc] init];
            
            // Rimuovo un punto alla volta dall'array di linee e creo un array con quei punti per poi creare il rettangolo da ridisegnare
            for (i = idxs.idxendpt; i > idxs.idxstartpt; i--) {
                [dirtyPoints addObject:line[i]];
                [line removeObjectAtIndex:i];
            }
            // lo aggiungo sempre perchè devo ridisegnare anche il pezzo di linea che si unisce a quella precedente, se c'è
            [dirtyPoints addObject:line[idxs.idxstartpt]];
            // Non ho rimosso subito il punto di indice idxstartpt perchè se è una linea doppia allora quel punto serve per la linea dei punti di indici precedenti
            if (idxs.idxstartpt == 0) {
                [line removeObjectAtIndex:0];
            }
            
            if ([line count] == 0) {
                [self.linesContainer removeObjectAtIndex:idxs.idxline];
            }
            
            [self.linesHistory removeLastObject];
            self.linesContainerHasChanged = YES;
            
            [self setNeedsDisplay:YES];
            //        [self setNeedsDisplayInRect:[self computeRectFromArray:dirtyPoints moveBorder:1]]; //TODO sarà più veloce calcolare il rettangolo o ridisegnare tutto?
        }
        
        else {
            self.ball.isAlreadyPlaced = NO;
            NSPoint ballcenterview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]];
            [self setNeedsDisplayInRect:NSMakeRect(ballcenterview.x - self.ball.radius,
                                                   ballcenterview.y - self.ball.radius,
                                                   self.ball.radius * 2,
                                                   self.ball.radius * 2)];
            #ifdef DEBUGLINESHIST
            NSLog(@"removeLatestLine: Nessuna una limea da rimuovere");
            #endif
        }
    }
    
}



- (void)move:(NSSize)mstep invalidate:(BOOL)flag {
    
    NSPoint pview = self.bounds.origin;
    NSPoint pworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pview]];
    NSPoint pviewmoved = NSMakePoint(pview.x + mstep.width, pview.y + mstep.height);
    NSPoint pworldmoved = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pviewmoved]];
    
    NSSize diff = NSMakeSize(pworldmoved.x - pworld.x, pworldmoved.y - pworld.y);
    
    // Aggiusto anche questi valori per scalare la scena
    if (!self.sceneView.isHidden) {
        [self.sceneView moveUpdate:diff useRuntime:YES]; // TODO: sarebbe meglio estrapolare dalle matrici invece di tenere un altro valore
        [self.sceneView moveScene:(DRRScene *)self.sceneView.scene];
    }
    else {
        [self.w2vTrans translateXBy:diff.width yBy:diff.height];
        [self.v2wTrans translateXBy:(-1 * diff.width) yBy:(-1 * diff.height)];
        [self.sceneView moveUpdate:diff useRuntime:NO];
    }
    
    if (flag)
        [self setNeedsDisplay:YES];
    
}

- (BOOL)scale:(CGFloat)sstep maxZoom:(CGFloat)upperbound minZoom:(CGFloat)lowerbound {
    
    BOOL reachedUpperB = NO;
    BOOL reachedLowerB = NO;
    NSPoint scalefactor = [self.w2vScale transformPoint:NSMakePoint(sstep, sstep)];
    
    if (scalefactor.x >= upperbound)
        reachedUpperB = YES;
    else if (scalefactor.x <= lowerbound)
        reachedLowerB = YES;
    
    if ( (!reachedUpperB && !reachedLowerB) || (reachedUpperB && (sstep < 1)) || (reachedLowerB && (sstep > 1)) ) {

        // Siccome la funzione di traslazione della matrice tiene conto della scalatura passando due paia di coordinate in coordinate mondo, allora passo alla funzione lo spostamento dal centro con la scalatura in coordinate vista.
        NSPoint pview = NSMakePoint(self.bounds.origin.x + self.bounds.size.width / 2,
                                    self.bounds.origin.y + self.bounds.size.height / 2);
        NSPoint pworld = [self.v2wScale transformPoint:pview];

        [self.w2vScale scaleBy:sstep];
        [self.v2wScale scaleBy:(1 / sstep)]; // TODO: sarebbe meglio estrapolare dalle matrici invece di tenere un altro valore
        [self.sceneView scaleUpdate:sstep];
        if (!self.sceneView.isHidden)
            [self.sceneView scaleScene:(DRRScene *)self.sceneView.scene];

        NSPoint pview_after = [self.w2vScale transformPoint:pworld];
        NSSize diff = NSMakeSize(pview.x - pview_after.x, pview.y - pview_after.y);

        [self move:diff invalidate:YES];
        
        return YES;
        
    }
    
    return NO;
    
}

- (void)updateCursor:(id)sender {
    
    #ifdef DEBUGPROTOCOL
    NSLog(@"DRRDrawingView: Protocol DockToView: updateCursor");
    #endif
    
    DRRButton * btn = [self.dock selectedCell];
    
    if (btn == self.btnDrawFree) {
        if (self.customCursor != DRAW) {
            [[NSCursor arrowCursor] set];
            self.customCursor = DRAW;
        }
    }
    
    else if (btn == self.btnPan) {
        if (self.customCursor != PANWAIT) {
            [[NSCursor openHandCursor] set];
            self.customCursor = PANWAIT;
        }
    }
    
    else if (btn == self.btnZoom) {
        if (self.customCursor != ZOOM) {
            [[NSCursor resizeUpDownCursor] set];
            self.customCursor = ZOOM;
        }
    }
    
}



- (void)setFrameSize:(NSSize)newSize {
    
    #ifdef DEBUGMATRIX
    NSLog(@"myView:setFrameSize");
    #endif
    
    // Voglio utilizzare il centro della vista come punto di ancoraggio: calcolo la posizione del centro per entrambi i frame (corrente e futuro) e passo la differenza alla funzione di traslazione, penserà lei alla scalatura.
    NSPoint pview_before = NSMakePoint(self.bounds.origin.x + self.bounds.size.width / 2,
                                       self.bounds.origin.y + self.bounds.size.height / 2);
    NSPoint pview_after = NSMakePoint(self.bounds.origin.x + newSize.width / 2,
                                      self.bounds.origin.y + newSize.height / 2);
    
    NSSize diff = NSMakeSize(pview_after.x - pview_before.x, pview_after.y - pview_before.y);
    
    [self move:diff invalidate:NO];
    
    [super setFrameSize:newSize];
    
//    if (heightBetweenDockAndTop < 0) {
//        // TODO: scalare matrice
//    }
    
    [dockBar setFrameSize:NSMakeSize(dockBar.frame.size.width, self.frame.size.height)];
    
    CGFloat heightBetweenDockAndTop = (self.frame.size.height - self.dock.frame.size.height);
    [self.dock setFrameOrigin:NSMakePoint(self.dock.frame.origin.x,
                                          self.frame.origin.y + (heightBetweenDockAndTop / 2))];
    
    [self.sceneView setFrameSize:self.bounds.size isActive:!self.sceneView.isHidden];
    
}

- (BOOL)preservesContentDuringLiveResize {
    return YES;
}

- (BOOL)inLiveResize {
    
    BOOL isInLive = [super inLiveResize];
    if (!isInLive) {
        if (self.viewPrevResizeWasInLive) {
            self.viewPrevResizeWasInLive = NO;
            [self setNeedsDisplay:YES];
        }
    }
    else
        self.viewPrevResizeWasInLive = YES;
    
    return isInLive;
    
}

- (BOOL)inLivePanOrScale {
    
    if (!self.inLiveMovement) {
        if (self.prevInLiveMovement) {
            self.prevInLiveMovement = NO;
            [self setNeedsDisplay:YES];
        }
    }
    else
        self.prevInLiveMovement = YES;
    
    return self.inLiveMovement;
    
}

- (void)setNeedsDisplay:(BOOL)flag {
    if (self.sceneView.isHidden) {
        [super setNeedsDisplay:flag];
    }
    else
        [super setNeedsDisplay:NO];
}

- (void)setNeedsDisplayInRect:(NSRect)invalidRect{
    
    if ([self.sceneView isHidden])
        [super setNeedsDisplayInRect:invalidRect];
    else {
//        [super setNeedsDisplayInRect:invalidRect];
        [super setNeedsDisplay:NO];
    }
}

- (void)drawRect:(NSRect)dirtRect {
    
    #ifdef DEBUGDRAW
    NSRect r = dirtRect;
    NSLog(@"-drawRect myView: o:%f^%f s:%f^%f", r.origin.x, r.origin.y,
          r.size.width, r.size.height);
    #endif
    
    if ([self.sceneView isHidden]) {
    
        [self.w2vScale concat];
        [self.w2vTrans concat];
        
        [[NSColor blackColor] set];
        
        if ([self inLiveResize] || [self inLivePanOrScale]) {
            [[NSGraphicsContext currentContext] setShouldAntialias: NO];
            [self.pathLines setLineWidth: 1.2];
        }
        else
            [self.pathLines setLineWidth: 2];
        
        // Disegno le linee
        if ([self.linesContainer count] > 0) {
            
            // per ogni linea del contenitore creo un path con NSBezierPath. Solo se nel frammepo LinesCOntainer è stato modificato
            if (self.linesContainerHasChanged) {
                [self.pathLines removeAllPoints];
                
                [self.linesContainer enumerateObjectsUsingBlock:^(id line, NSUInteger iline, BOOL *stop1) {
                    if ([line count] > 0) {
                        // aggiungo ogni punto della linea al path
                        [line enumerateObjectsUsingBlock:^(id point, NSUInteger ipoint, BOOL *stop2) {
                            NSPoint p = [point pointValue];
                            #ifdef DEBUGLINES
                            [self.pathSinglePoint appendBezierPathWithOvalInRect:NSMakeRect(p.x - 2, p.y - 2, 4, 4)];
                            #endif
                            
                            if (ipoint == 0)
                                [self.pathLines moveToPoint:p];
                            else
                                [self.pathLines lineToPoint:[point pointValue]];
                        }];
                    }
                    [self.pathLines stroke];
                    
                    #ifdef DEBUGLINES
                    [[NSColor redColor] set]; [self.pathSinglePoint fill]; [self.pathSinglePoint removeAllPoints];
                    [[NSColor blackColor] set];
                    #endif
                
                }];
                
                self.linesContainerHasChanged = NO;
            }
            
            // Disegno il path che mi sono costruito prima, non ho aggiunto o rimosso linee nel frattempo
            else {
                
                [self.pathLines stroke];
                
            }
            
        }
        
        // disegno la linea retta temporanea
        if (self.validLine) {
            NSBezierPath * tempLine = [[NSBezierPath alloc] init];
            NSPoint startPoint = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:self.prevmouseXY]];
            
            [tempLine setLineWidth:2];
            [[NSColor lightGrayColor] set];
            [tempLine moveToPoint:startPoint];
            [tempLine lineToPoint:self.tempPoint];
            [tempLine stroke];
            
            if (!self.ball.isAlreadyPlaced && self.ball.isAlreadyTempPlaced) {
                [[NSColor colorWithCalibratedRed:0.35 green:1 blue:0.0 alpha:0.3] set]; // 88 224 0
                [self.ball.circle fill];
            }
        }
        
        // Disegno la palla
        if (self.ball.isAlreadyPlaced) {
            [[NSColor lGreen] set];
            [self.ball.circle fill];
            [[NSColor lightGrayColor] set];
            [self.ball.circle stroke];
        }
        
        // DEBUG: scrivo il numero di elementi nell'array delle linee e in quello della cronologia
        #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSLeftTextAlignment];
        NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
        NSString * lCont_str = [NSString stringWithFormat:@"%li", (long)[self.linesContainer count]];
        NSString * lHist_str = [NSString stringWithFormat:@"%li", (long)[self.linesHistory count]];
        [lCont_str drawInRect:NSMakeRect(self.bounds.size.width - 52, 0, 20, 15) withAttributes:attr];
        [lHist_str drawInRect:NSMakeRect(self.bounds.size.width - 22, 0, 40, 15) withAttributes:attr];
        #endif
        
    }
    
    // View nascosta dalla scena
//    else {
//        
//    }
    
}


- (void)startOrPauseScene {
    
    NSInteger row = 0; NSInteger col = 0;
    
    if ([self.sceneView isHidden]) {
        
        if ([self.sceneView isPaused])
            [self.sceneView setPaused:NO];

        // Dopo aver disegnato, passo le linee alla vista che gestirà la scena in movimento
        
        NSPoint ballCenter = NSMakePoint(0, 0);
        if (self.ball.isAlreadyPlaced)
            ballCenter = self.ball.center;

        [self.sceneView buildSceneContent:self.linesContainer
                             ballPosition:ballCenter
                               ballRadius:self.ball.radius];
        
        [self.sceneView setHidden:NO];
        
        
        // Sposto la camera sulla palla
        if (self.ball.isAlreadyPlaced) {
//            CGPoint ballCenterView = NSPointToCGPoint([self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]]);
//            NSPoint centerView = NSMakePoint(self.sceneView.bounds.origin.x + self.sceneView.bounds.size.width / 2,
//                                             self.sceneView.bounds.origin.y + self.sceneView.bounds.size.height / 2);
//            self.initMove = CGVectorMake(centerView.x - ballCenterView.x, centerView.y - ballCenterView.y);
////            [self.sceneView.scene runAction:[SKAction moveBy:self.initMove duration:0.5]];
//            [((DRRScene *) self.sceneView.scene) moveWorld:self.initMove withDuration:0.5];
            NSPoint viewCenter = NSMakePoint(self.sceneView.bounds.origin.x + self.sceneView.bounds.size.width / 2,
                                             self.sceneView.bounds.origin.y + self.sceneView.bounds.size.height / 2);
            NSPoint viewCenter_world = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:viewCenter]];
            self.initMove = CGVectorMake(viewCenter_world.x - self.ball.center.x, viewCenter_world.y - self.ball.center.y);
//            [self.sceneView.scene runAction:[SKAction moveBy:self.initMove duration:0.5]];
            [((DRRScene *) self.sceneView.scene) moveWorld:self.initMove withDuration:0.5];
            
            [self.sceneView moveUpdate:NSMakeSize(self.initMove.dx, self.initMove.dy) useRuntime:YES]; // TEST: è una prova!
//            }
        }
        
        
        
        // Disabilito esteticamente i bottoni che non voglio utilizzare durante la scena e abilito il pan
        // TODO: disabilitare meglio
        NSArray * cells = [self.dock cells];
        [cells enumerateObjectsUsingBlock:^(NSCell * cell, NSUInteger idx, BOOL *stop) {
            if (cell == self.btnDrawFree || cell == self.btnDrawLine) {
                ((DRRButton *) cell).altMode = YES;
                if (cell == self.btnDrawFree)
                    [self.dock drawCellInside:cell]; // TODO: male, non dovrei farlo a mano, le altre funzionao da sole
            }
            else if (cell == self.btnBack || cell == self.btnPlay || cell == self.btnTrash)
                ((DRRActionButton *) cell).altMode = YES;
        }];
        self.dock.prevSelectCell_playPause = self.dock.prevSelectCell;
        [self.dock getRow:&row column:&col ofCell:self.btnPan];
        [self.dock setState:NSOnState atRow:row column:col];
        
    }
    
    else if (![self.sceneView.scene isPaused]) {
        [self.sceneView.scene setPaused:YES];
        [self.dock getRow:&row column:&col ofCell:self.btnPlay];
        [[self.dock cellAtRow:row column:col] setAltMode:NO];
    }
    
    else if ([self.sceneView.scene isPaused]){
        [self.sceneView.scene setPaused:NO];
        [self.dock getRow:&row column:&col ofCell:self.btnPlay];
        [[self.dock cellAtRow:row column:col] setAltMode:YES];
    }

//    [self updateCursor:self];
}

- (void)stopScene {

    if (!self.sceneView.isHidden) {

//        DRRScene * tempScene = [[DRRScene alloc] initWithSize:self.sceneView.bounds.size];
        [self.sceneView presentScene:nil];
        [self.sceneView.scene setPaused:YES];
        [self.sceneView setHidden:YES];
        [self.sceneView setItemPropertiesToDefault];
        
//        [self.sceneView moveUpdate:NSMakeSize(- self.initMove.dx, - self.initMove.dy) useRuntime:NO];
        
        // Riabilito esteticamente i bottoni che non volevo utilizzare durante la scena //TODO: disabilitare davvero
        NSArray * cells = [self.dock cells];
        [cells enumerateObjectsUsingBlock:^(NSCell * cell, NSUInteger idx, BOOL *stop) {
            if (cell == self.btnDrawFree || cell == self.btnDrawLine) {
                ((DRRButton *) cell).altMode = NO;
                if (cell == self.btnDrawFree)
                    [self.dock drawCellInside:cell]; // TODO: male, non dovrei farlo a mano, le altre funzionao da sole
            }
            else if (cell == self.btnBack || cell == self.btnPlay || cell == self.btnTrash)
                ((DRRActionButton *) cell).altMode = NO;
        }];
        
        NSInteger row = 0; NSInteger col = 0;
        [self.dock getRow:&row column:&col ofCell:self.dock.prevSelectCell_playPause];
//        [self.dock selectCellAtRow:row column:col];
        [self.dock setState:NSOnState atRow:row column:col];
        
        
        [self setNeedsDisplay:YES];
    }
    
//    [self updateCursor:self];
}



- (void)mouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDown");
    #endif
    
    self.leftpressed = YES;
    NSPoint pwindow = [theEvent locationInWindow];
    NSPoint pview = [self convertPoint:pwindow fromView:nil];
    NSPoint pworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pview]];
    
    DRRButton * btn = [self.dock selectedCell];
    
    if ([self.sceneView isHidden] && (btn == self.btnDrawFree || btn == self.btnDrawLine)) {

        if (self.customCursor != DRAW) {
            [[NSCursor arrowCursor] set];
            self.customCursor = DRAW;
        }
        
        // controllo se il mouse è vicino ad un punto precedente...
        self.nearpointIdx = [self findAdiacentVertex:pworld];
        
        // ...si! Ancoro la nuova linea a quella.
        if (self.nearpointIdx.x != NOTFOUND) {
            
            #ifdef DEBUGLINES
            NSLog(@"Trovato punto di ancoraggio");
            #endif
            
            self.thisIsANewLine = NO;
            NSPoint nearpoint = [self.linesContainer[(NSInteger)self.nearpointIdx.x][(NSInteger)self.nearpointIdx.y] pointValue];
            
            self.prevmouseXY = [self.w2vTrans transformPoint:nearpoint];
            self.prevmouseXY = [self.w2vScale transformPoint:self.prevmouseXY];
            
            // sposto il puntatore del mouse nella nuova posizione (coordinate schermo)
            NSRect frameRelativeToScreen = [self.window convertRectToScreen:self.frame];
            NSPoint nearpointview = [self.w2vTrans transformPoint:nearpoint];
            nearpointview = [self.w2vScale transformPoint:nearpointview];
            NSPoint newpos = NSMakePoint(frameRelativeToScreen.origin.x + nearpointview.x,
                                         (self.screenRect.size.height) - (frameRelativeToScreen.origin.y + nearpointview.y));
            CGWarpMouseCursorPosition(newpos);
            
        }
        
        // ...no! Aggiungo una nuova linea e il punto ad essa. Includo il caso in cui la funzione abbia restituito un errore per camuffarlo a runtime
        else {
            self.thisIsANewLine = YES;
            self.prevmouseXY = pview;
            
            [self addEmptyLine];
            [self addPointToLatestLine:(&pworld)];
            
        }
        
        if (btn == self.btnDrawLine) {
            self.prevTempPoint = pworld;
            self.tempPoint = pworld;
        }
        
    } // fine btnDrawFree || btnDrawLine
    
    else if (btn == self.btnPan) {
        if (self.customCursor != PANACTIVE) {
            [[NSCursor closedHandCursor] set];
            self.customCursor = PANACTIVE;
        }
        
        if ([self.ball hitTest:pworld])
            self.ballPressed = YES;
        
        self.prevmouseXY = pview;
    }
    
    else if (btn == self.btnZoom) {
        if (self.customCursor != ZOOM) {
            [[NSCursor resizeUpDownCursor] set];
            self.customCursor = ZOOM;
        }
        
        self.prevmouseXY = pview;
    }
    
    #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
    if ([self.sceneView isHidden])
        [self setNeedsDisplayInRect:NSMakeRect(self.bounds.size.width - 55, 0, self.bounds.size.width, 50)];
    #endif
    
}

- (void)mouseDragged:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseDragged");
    #endif
    
    if (self.leftpressed) {
        
        NSPoint pwindow = [theEvent locationInWindow];
        NSPoint pview   = [self convertPoint:pwindow fromView:nil];
        NSPoint pworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pview]];
        
        DRRButton * btn = [self.dock selectedCell];
        
        if ([self.sceneView isHidden] && btn == self.btnDrawFree) {
            
            // Voglio evitare di avere troppi punti molto vicini, controllo la distanza tra questo punto e il precedente
            NSPoint prevmouseXYworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:self.prevmouseXY]];
            CGFloat d = [self distanceBetweenPoint:prevmouseXYworld andPoint:pworld];
            
            if (d > SEGLENGTH) {
                if (!self.ball.isAlreadyPlaced) {
                    CGFloat bX = prevmouseXYworld.x;
                    if (pworld.x - prevmouseXYworld.x > 0)
                        bX += 10;
                    else
                        bX -= 10;
                    [self.ball setIsAlreadyPlaced:YES];
                    [self.ball setCenterPosition:NSMakePoint(bX, prevmouseXYworld.y + 30)];
                    
                    NSPoint pballview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]];
                    [self setNeedsDisplayInRect:NSMakeRect(pballview.x - self.ball.radius - 1, pballview.y - self.ball.radius - 1,
                                                           self.ball.radius * 2 + 2, self.ball.radius * 2 + 2)];
                    
                }
                
                self.atLeastOneStroke = YES;
                
                // Devo aggiungere i punti alla linea ancorata nella mouseDown senza crearne una nuova
                if (!self.thisIsANewLine)
                    [self addPointToIdxLine:(&pworld) idxLinesArray:self.nearpointIdx.x];
                // Creo nuova linea.
                else
                    [self addPointToLatestLine:(&pworld)];
                
                self.dirtyRect = [self computeRect:self.prevmouseXY secondPoint:pview moveBorder:1];
                [self setNeedsDisplayInRect:self.dirtyRect];
                
                self.prevmouseXY = pview;
            }
            
            else {
                #ifdef DEBUGLINES
                NSLog(@"Punto troppo vicino, lo ignoro");
                #endif
            }
            
        } // fine btnDrawFree
        
        else if ([self.sceneView isHidden] && btn == self.btnDrawLine) {
            
            NSPoint prevmouseXYworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:self.prevmouseXY]];
            CGFloat d = [self distanceBetweenPoint:prevmouseXYworld andPoint:pworld];
            if (d > SEGLENGTH) {
                self.prevTempPoint = self.tempPoint;
                self.tempPoint = pworld;
                self.validLine = YES;
                
                if (!self.ball.isAlreadyPlaced) {
                    CGFloat bX = prevmouseXYworld.x;
                    if (pworld.x - prevmouseXYworld.x > 0)
                        bX += 10;
                    else
                        bX -= 10;
                    
                    BOOL areOnDifferentPlanesDx = (bX > prevmouseXYworld.x) && (self.ball.center.x < prevmouseXYworld.x);
                    BOOL areOnDifferentPlanesSx = (bX < prevmouseXYworld.x) && (self.ball.center.x > prevmouseXYworld.x);
                    
                    // imposto una posizione temporanea per la pallina in due casi: non ne ha oppure ne ha una ma devo posizionarla dall'altro lato rispetto al punto in cui ho iniziato a disegnare la linea
                    if (!self.ball.isAlreadyTempPlaced ||
                        (self.ball.isAlreadyTempPlaced && (areOnDifferentPlanesDx || areOnDifferentPlanesSx)) ) {
                        
                        [self.ball setIsAlreadyTempPlaced:YES];
                        [self.ball setCenterPosition:NSMakePoint(bX, prevmouseXYworld.y + 30)];
                        
                        NSPoint pballview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]];
                        if (!self.ball.isAlreadyTempPlaced) {
                            [self setNeedsDisplayInRect:NSMakeRect(pballview.x - self.ball.radius,
                                                                   pballview.y - self.ball.radius,
                                                                   self.ball.radius * 2,
                                                                   self.ball.radius * 2)];
                        }
                        else {
                            [self setNeedsDisplayInRect:NSMakeRect(self.prevmouseXY.x - self.ball.radius * 2,
                                                                   pballview.y - self.ball.radius,
                                                                   self.ball.radius * 4,
                                                                   self.ball.radius * 2)];
                        }
                    }
                }  // if se non è posizionata la palla in modo definitivo: imposto una posizione temporanea
            } // if distanza valida per disegnare una linea temporanea
            else {
                if (self.validLine && self.ball.isAlreadyTempPlaced) {
                    NSPoint pballview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]];
                    [self setNeedsDisplayInRect:NSMakeRect(self.prevmouseXY.x - self.ball.radius * 2,
                                                           pballview.y - self.ball.radius,
                                                           self.ball.radius * 4,
                                                           self.ball.radius * 2)];
                }
                
                self.validLine = NO;
            }

            NSPoint prevTempPointview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.prevTempPoint]];
            NSPoint tempPointview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.tempPoint]];
            
            CGRect r1 = NSRectToCGRect([self computeRect:self.prevmouseXY secondPoint:prevTempPointview moveBorder:1]);
            CGRect r2 = NSRectToCGRect([self computeRect:self.prevmouseXY secondPoint:tempPointview moveBorder:1]);
            self.dirtyRect = NSRectFromCGRect(CGRectUnion(r1, r2));
            [self setNeedsDisplayInRect:self.dirtyRect];
            
        } // fine btnDrawLine
        
        else if (btn == self.btnPan) {
            
            if ([self ballPressed]) {
                NSPoint pviewworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:pview]];
                NSPoint prevmouseXYworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:self.prevmouseXY]];
                NSSize diff = NSMakeSize(pviewworld.x - prevmouseXYworld.x, pviewworld.y - prevmouseXYworld.y);
                
                [self.ball setCenterPosition:NSMakePoint(self.ball.center.x + diff.width,
                                                         self.ball.center.y + diff.height)];
//                [self setNeedsDisplayInRect:NSMakeRect(pwindow.x - self.ball.radius, pwindow.y - self.ball.radius,
//                                                       self.ball.radius * 2, self.ball.radius * 2)];
            if (self.sceneView.isHidden)
                [self setNeedsDisplay:YES]; // TODO: migliorare solo invalidare rettangolo...
            }
            
            else {
                if (self.inLiveMovement)
                    self.prevInLiveMovement = YES;
                self.inLiveMovement = YES;
                
                NSSize diff = NSMakeSize(pview.x - self.prevmouseXY.x, pview.y - self.prevmouseXY.y);
                [self move:diff invalidate:YES];
            }
            
            self.prevmouseXY = pview;
                
        }
        
        else if (btn == self.btnZoom) {

            if (self.inLiveMovement)
                self.prevInLiveMovement = YES;
            self.inLiveMovement = YES;
            
            CGFloat diff = pview.y - self.prevmouseXY.y;
            CGFloat s = 1;
            
            if (fabs(diff) > 1) {
                
                if (diff > 0) {
                    if (self.customCursor != ZOOMIN) {
                        [[NSCursor resizeUpCursor] set];
                        self.customCursor = ZOOMIN;
                    }
                    
                    s = 1 + (diff * 0.005);
                }
                else {
                    if (self.customCursor != ZOOMOUT) {
                        [[NSCursor resizeDownCursor] set];
                        self.customCursor = ZOOMOUT;
                    }
                    
                    s = 1 - (diff * -1 * 0.005);
                }
                
                BOOL hasScaled = [self scale:s maxZoom:self.maxZoomFactor minZoom:self.minZoomFactor];
                
                if (!hasScaled) {
                    [[NSCursor resizeUpDownCursor] set];
                    self.customCursor = ZOOM;
                }
                
                self.prevmouseXY = pview;
                
            }

        } // fine btnZoom
        
        #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
        if ([self.sceneView isHidden])
            [self setNeedsDisplayInRect:NSMakeRect(self.bounds.size.width - 55, 0, self.bounds.size.width, 50)];
        #endif
        
    }

}

- (void)mouseUp:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+mouseUp");
    #endif
    
    if (self.leftpressed) {

        self.leftpressed = NO;
        NSPoint pwindow = [theEvent locationInWindow];
        NSPoint pview   = [self convertPoint:pwindow fromView:nil];
        NSPoint pworld = [self.v2wScale transformPoint:pview];
        pworld = [self.v2wTrans transformPoint:pworld];
        
        DRRButton * btn = [self.dock selectedCell];
        
        if ([self.sceneView isHidden] && btn == self.btnDrawFree) {
            
            // Se è stato disegnato almeno un pezzo di linea allora lo aggiungo alla cronologia...
            if (self.atLeastOneStroke) {
                if (!self.thisIsANewLine) {
                    NSInteger idxline = (NSInteger) self.nearpointIdx.x;
                    NSInteger idxstart = (NSInteger) self.nearpointIdx.y;
                    NSMutableArray * thisline = self.linesContainer[idxline];
                    NSInteger lastpointidx = [thisline count] - 1;
                    DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
                    [self.linesHistory addObject:idxs];
                }
                else {
                    NSInteger lastlineidx = [self.linesContainer count] - 1;
                    NSInteger lastpointidx = [self.linesContainer[lastlineidx] count] - 1;
                    DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
                    [self.linesHistory addObject:idxs];
                }
                self.atLeastOneStroke = NO;
            }
            
            // altrimenti, solo se stavo disegnando una nuova linea, rimuovo quel punto dall'array linesContainer
            else if (self.thisIsANewLine) {
                [self.linesContainer removeLastObject];
            }
            
        }
        
        else if ([self.sceneView isHidden] && btn == self.btnDrawLine) {
            
            if (self.validLine) {
                // Devo aggiungere i punti alla linea ancorata nella mouseDown senza crearne una nuova oppure creare una nuova linea e aggiungerla alla cronologia
                if (!self.thisIsANewLine) {
                    [self addPointToIdxLine:(&pworld) idxLinesArray:self.nearpointIdx.x];
                    
                    NSInteger idxline = (NSInteger) self.nearpointIdx.x;
                    NSInteger idxstart = (NSInteger) self.nearpointIdx.y;
                    NSMutableArray * thisline = self.linesContainer[idxline];
                    NSInteger lastpointidx = [thisline count] - 1;
                    DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:idxline indexTwo:idxstart indexThree:lastpointidx];
                    [self.linesHistory addObject:idxs];
                }
                
                else {
                    
                    if (!self.ball.isAlreadyPlaced) {
                        NSPoint prevmouseXYworld = [self.v2wTrans transformPoint:[self.v2wScale transformPoint:self.prevmouseXY]];
                        CGFloat bX = prevmouseXYworld.x;
                        if (pworld.x - prevmouseXYworld.x > 0)
                            bX += 10;
                        else
                            bX -= 10;
                        [self.ball setIsAlreadyPlaced:YES];
                        [self.ball setCenterPosition:NSMakePoint(bX, prevmouseXYworld.y + 30)];
                        NSPoint pballview = [self.w2vScale transformPoint:[self.w2vTrans transformPoint:self.ball.center]];
                        [self setNeedsDisplayInRect:NSMakeRect(pballview.x - self.ball.radius - 1, pballview.y - self.ball.radius - 1,
                                                               self.ball.radius * 2 + 2, self.ball.radius * 2 + 2)];
                    }
                    
                    [self addPointToLatestLine:(&pworld)];
                    
                    NSInteger lastlineidx = [self.linesContainer count] - 1;
                    NSInteger lastpointidx = [self.linesContainer[lastlineidx] count] - 1;
                    DRRSegmentIdx * idxs = [[DRRSegmentIdx alloc] initWithIndex:lastlineidx indexTwo:0 indexThree:lastpointidx];
                    [self.linesHistory addObject:idxs];
                }
                
                self.dirtyRect = [self computeRect:self.prevmouseXY secondPoint:pview moveBorder:1];
                self.validLine = NO;
                [self setNeedsDisplayInRect:self.dirtyRect];
            }
            
            // altrimenti, solo se stavo disegnando una nuova linea, rimuovo quel punto dall'array linesContainer
            else if (self.thisIsANewLine) {
                [self.linesContainer removeLastObject];
            }
            
        }
        
        else if (btn == self.btnPan) {
            if (self.ballPressed)
                self.ballPressed = NO;
            
            self.inLiveMovement = NO;
            [self setNeedsDisplay:YES];
            self.customCursor = PANWAIT;
            [[NSCursor openHandCursor] set];
        }
        
        else if (btn == self.btnZoom) {
            self.inLiveMovement = NO;
            [self setNeedsDisplay:YES];
            self.customCursor = ZOOM;
            [[NSCursor resizeUpDownCursor] set];
        }
        
        #if defined(DEBUGLINES) || defined(DEBUGLINESHIST)
        if ([self.sceneView isHidden])
            [self setNeedsDisplayInRect:NSMakeRect(self.bounds.size.width - 55, 0, self.bounds.size.width, 50)];
        #endif
        
    }
    
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+rightMouseDown");
    #endif
    
    if (!self.leftpressed) {
        self.rightpressed = YES;
    }
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    
    #ifdef DEBUGMOUSECORR
    NSLog(@"+rightMouseUp");
    #endif
    
    if (self.rightpressed) {
        [self switchToLastButton];
        self.rightpressed = NO;
    }
}

- (void)scrollWheel:(NSEvent *)theEvent {
//    NSLog(@"user scrolled %f horizontally and %f vertically", [theEvent deltaX], [theEvent deltaY]);
    [self move:NSMakeSize([theEvent deltaX] * 4, -3 * [theEvent deltaY]) invalidate:YES]; //TODO: Brutto, basato su driver del tuo touchpad
}


@end