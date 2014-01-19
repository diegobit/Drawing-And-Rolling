//
//  DRRAppDelegate.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRAppDelegate.h"


@implementation DRRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window setBackgroundColor:[NSColor whiteColor]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (flag)
        [self.window orderFront:self];
    else
        [self.window makeKeyAndOrderFront:self];
    return YES;
}

- (void)applicationDidResignActive:(NSNotification *)notification {
    if ([drawingView.sceneView.scene isPaused])
        self.doNotReactivate = YES;
    [drawingView.sceneView setPaused:YES];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [drawingView.sceneView setPaused:NO];
    if (self.doNotReactivate) {
        [drawingView.sceneView.scene setPaused:YES];
        self.doNotReactivate = NO;
    }
}


@end

