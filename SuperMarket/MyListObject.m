//
//  MyListObject.m
//  SuperMarket
//
//  Created by phoenix on 1/23/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "MyListObject.h"

@implementation MyListObject
- (id)init
{
    self = [super init];
    self.items = [[NSMutableArray alloc]init];
    return self;
}
@end
