//
//  MyListObject.h
//  SuperMarket
//
//  Created by phoenix on 1/23/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyListObject : NSObject
@property (nonatomic, strong) NSString *listID;
@property (nonatomic, strong) NSString *listTitle;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *receiversName;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSMutableArray *items;
@end
