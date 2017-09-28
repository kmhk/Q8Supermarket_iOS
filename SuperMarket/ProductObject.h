//
//  ProductObject.h
//  SuperMarket
//
//  Created by phoenix on 11/17/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property (nonatomic, strong) NSString *prodID;
@property (nonatomic, strong) NSString *OfferID;
@property (nonatomic, strong) NSString *prodQuantity;
@property (nonatomic, strong) NSString *prodMainCatID;
@property (nonatomic, strong) NSString *prodSubCatID;
@property (nonatomic, strong) NSString *prodOrgPrice;
@property (nonatomic, strong) NSString *prodCurPrice;
@property (nonatomic, strong) NSString *prodPhotoURL;
@property (nonatomic, strong) NSString *prodMeasureID;
@property (nonatomic, strong) NSString *prodDescEn;
@property (nonatomic, strong) NSString *prodDescAr;
@property (nonatomic, strong) NSString *prodStartDate;
@property (nonatomic, strong) NSString *prodEndDate;
@property (nonatomic, strong) NSString *prodBranchList;
@property (nonatomic, strong) NSString *prodVisitsCount;
@property (nonatomic, strong) NSString *prodTitleAr;
@property (nonatomic, strong) NSString *prodTitleEn;
@property (nonatomic, strong) NSString *prodIsActive;
@property (nonatomic, strong) NSString *prodlastUpdateTime;
@property (nonatomic, strong) NSString *prodFavoriteProducts;
@property (nonatomic, strong) NSString *prodHomeOrderProducts;
@property (nonatomic, strong) NSString *prodPurchasedProducts;
@property (nonatomic, strong) NSString *prodCompanyID;
@property (nonatomic, strong) NSString *prodAddDate;
@property (nonatomic, strong) NSString *prodAddPurchaseDate;
@end
