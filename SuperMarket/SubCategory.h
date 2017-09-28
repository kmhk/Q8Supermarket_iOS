//
//  SubCategory.h
//  SuperMarket
//
//  Created by phoenix on 11/18/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategory : NSObject
@property (nonatomic, strong) NSString *subCatID;
@property (nonatomic, strong) NSString *mainCatID;
@property (nonatomic, strong) NSString *subCatAr;
@property (nonatomic, strong) NSString *subCatEn;
@property (nonatomic, strong) NSString *subCatMeasures;
@property (nonatomic, strong) NSString *sort;
@end
