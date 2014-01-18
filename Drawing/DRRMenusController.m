//
//  DRRMenuController.m
//  Drawing
//
//  Created by Diego on 18/01/14.
//  Copyright (c) 2014 Diego Giorgini. All rights reserved.
//

#import "DRRMenusController.h"

@implementation DRRMenuController

- (IBAction)doSaveAs:(id)pId; {
    NSLog(@"doSaveAs");
    NSSavePanel *tvarNSSavePanelObj	= [NSSavePanel savePanel];
    int tvarInt	= [tvarNSSavePanelObj runModal];
    if(tvarInt == NSOKButton){
     	NSLog(@"doSaveAs we have an OK button");
    } else if(tvarInt == NSCancelButton) {
     	NSLog(@"doSaveAs we have a Cancel button");
     	return;
    } else {
     	NSLog(@"doSaveAs tvarInt not equal 1 or zero = %3d",tvarInt);
     	return;
    } // end if
    
    NSString * tvarDirectory = [tvarNSSavePanelObj directory];
    NSLog(@"doSaveAs directory = %@",tvarDirectory);
    
    NSString * tvarFilename = [tvarNSSavePanelObj filename];
    NSLog(@"doSaveAs filename = %@",tvarFilename);
    
} // end doSaveAs

- (IBAction)doOpen:(id)pId; {
    NSLog(@"doOpen");
    NSOpenPanel *tvarNSOpenPanelObj	= [NSOpenPanel openPanel];
    NSInteger tvarNSInteger	= [tvarNSOpenPanelObj runModalForTypes:nil];
    if(tvarNSInteger == NSOKButton){
     	NSLog(@"doOpen we have an OK button");
    } else if(tvarNSInteger == NSCancelButton) {
     	NSLog(@"doOpen we have a Cancel button");
     	return;
    } else {
     	NSLog(@"doOpen tvarInt not equal 1 or zero = %3d",tvarNSInteger);
     	return;
    } // end if
    
    NSString * tvarDirectory = [tvarNSOpenPanelObj directory];
    NSLog(@"doOpen directory = %@",tvarDirectory);
    
    NSString * tvarFilename = [tvarNSOpenPanelObj filename];
    NSLog(@"doOpen filename = %@",tvarFilename);
    
} // end doOpen

@end
