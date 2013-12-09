//
//  DRRPointObj.m
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import "DRRPointObj.h"



@implementation DRRPointObj

// initialize without setting its point
//- (id)init {
//    if ( self = [super init] ) {
//        point = NULL;
//    }
//    return self;
//}


// initialize with the NSPoint pointed by p
- (id)initWithPoint:(NSPoint *)p {
    if ( self = [super init] ) {
        point = (*p);
    }
    return self;
}


//- (BOOL)isEmpty {
//    if (point) return true;
//    else return false;
//}


- (NSPoint)getPoint {
    return point;
}


- (void)setPoint:(NSPoint *)p {
    point = (*p);
}

@end
