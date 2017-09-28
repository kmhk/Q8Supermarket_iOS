//
//  Annotation.m
//  shoutchat
//
//  Created by phoenix on 9/18/13.
//  Copyright (c) 2013 jiangwei. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [self setTitle:nil];
    [self setSubtitle:nil];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Getters and setters
-(id)init{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title retain];
    }
}

- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        [_subtitle release];
        _subtitle = [subtitle retain];
    }
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

@end