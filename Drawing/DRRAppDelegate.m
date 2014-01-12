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
//    [self.window setBackgroundColor:[NSColor colorWithCalibratedRed:0.89 green:0.89 blue:0.89 alpha:1]];
    [self.window setBackgroundColor:[NSColor whiteColor]];


//    /* Pick a size for the scene */
//    SKScene *scene = [DRRMainView sceneWithSize:CGSizeMake(1024, 768)];
//    
//    /* Set the scale mode to scale to fit the window */
//    scene.scaleMode = SKSceneScaleModeAspectFit;
//    
//    [self.skView presentScene:scene];
//    
//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;

    
}



- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (flag)
        [self.window orderFront:self];
    else
        [self.window makeKeyAndOrderFront:self];
    return YES;
}

@end
