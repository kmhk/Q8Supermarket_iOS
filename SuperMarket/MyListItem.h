//
//  MyListItem.h
//  SuperMarket
//
//  Created by phoenix on 12/8/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyListItem : NSObject
@property (nonatomic, assign) BOOL isMainCategory;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemSubID;
@property (nonatomic, strong) NSString *measureUnit;
@property (nonatomic, strong) NSString *measureQuantity;
@property (nonatomic, strong) NSString *isDone;
@property (nonatomic, assign) int selectedItems;
@end
