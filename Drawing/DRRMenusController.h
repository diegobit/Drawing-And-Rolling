//
//  DRRMenuController.h
//  Drawing
//
//  Created by Diego on 18/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRRDrawingView.h"

@interface DRRMenuController : NSMenu {
    IBOutlet DRRDrawingView * drawingView;
}

- (IBAction)saveAs:(id)pId;
- (IBAction)open:(id)pId;

@end
