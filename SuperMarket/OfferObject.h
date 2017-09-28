//
//  OfferObject.h
//  SuperMarket
//
//  Created by phoenix on 11/15/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferObject : NSObject
@property (nonatomic, strong) NSString *offerID;
@property (nonatomic, strong) NSString *offerCompanyID;
@property (nonatomic, strong) NSString *offerTitleAr;
@property (nonatomic, strong) NSString *offerTitleEn;
@property (nonatomic, strong) NSString *offerDescAr;
@property (nonatomic, strong) NSString *offerDescEn;
@property (nonatomic, strong) NSString *offerPhotoURL;
@property (nonatomic, strong) NSString *offerStartDate;
@property (nonatomic, strong) NSString *offerEndDate;
@property (nonatomic, strong) NSString *offerIsActive;
@property (nonatomic, strong) NSString *offerBranchList;
@property (nonatomic, strong) NSString *offerlastUpdateTime;
@property (nonatomic, strong) NSString *offerProducts;

@end
