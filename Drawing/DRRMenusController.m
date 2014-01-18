//
//  DRRMenuController.m
//  Drawing
//
//  Created by Diego on 18/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import "DRRMenusController.h"

@implementation DRRMenuController

- (IBAction)saveAs:(id)pId; {
    [drawingView saveToFile];
}

- (IBAction)open:(id)pId; {
    [drawingView loadFromFile];
}

@end
