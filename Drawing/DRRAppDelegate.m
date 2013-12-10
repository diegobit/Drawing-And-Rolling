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
    NSLog(@"applicationDidFinishLaunching");
    // Insert code here to initialize your application
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (flag)
        [self.window orderFront:self];
    else
        [self.window makeKeyAndOrderFront:self];
    return YES;
}

@end
