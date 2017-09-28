//
//  ProductsWithCategory.h
//  SuperMarket
//
//  Created by phoenix on 11/21/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductObject.h"
@interface ProductsWithCategory : NSObject
@property (nonatomic, strong) ProductObject *obj;
@property (nonatomic, assign) BOOL isCategory;
@property (nonatomic, strong) NSString *mainID;
@property (nonatomic, strong) NSString *subID;
@property (nonatomic, strong) NSString *companyID;
@end
