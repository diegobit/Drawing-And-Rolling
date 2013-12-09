//
//  DRRPointObj.h
//  Drawing
//
//  Created by Diego Giorgini on 09/12/13.
//  Copyright (c) 2013 Diego Giorgini. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DRRPointObj : NSObject {
    NSPoint point;
}

- (id)initWithPoint:(NSPoint *)p;
//- (BOOL)isEmpty;
- (NSPoint)getPoint;
- (void)setPoint:(NSPoint *)p;

@end
