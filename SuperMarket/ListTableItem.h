//
//  ListTableItem.h
//  SuperMarket
//
//  Created by phoenix on 1/23/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListTableItem : NSObject
@property (nonatomic, assign) int isList;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *itemSubID;
@property (nonatomic, strong) NSString *measureUnit;
@property (nonatomic, strong) NSString *measureQuantity;
@property (nonatomic, strong) NSString *isDone;

@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *receiversName;
@property (nonatomic, strong) NSString *items;
@property (nonatomic, strong) NSString *listID;
@property (nonatomic, assign) int itemNumber;
@end
