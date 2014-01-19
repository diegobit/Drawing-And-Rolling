//
//  DRRAppDelegate.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
//#import "DRRScene.h"
#import "DRRDrawingView.h"


@interface DRRAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet DRRDrawingView * drawingView;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;
- (void)applicationDidResignActive:(NSNotification *)notification;
- (void)applicationDidBecomeActive:(NSNotification *)notification;

@property (assign) IBOutlet NSWindow *window;
//@property (assign) IBOutlet SKView *skView;

@end
