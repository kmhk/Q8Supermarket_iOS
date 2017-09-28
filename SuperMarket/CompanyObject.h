//
//  CompanyObject.h
//  SuperMarket
//
//  Created by phoenix on 11/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchObject.h"
@interface CompanyObject : NSObject
@property (strong, nonatomic) NSString *companyID;
@property (strong, nonatomic) NSString *companyNameAr;
@property (strong, nonatomic) NSString *companyNameEn;
@property (strong, nonatomic) NSString *companyEmail;
@property (strong, nonatomic) NSString *companyPhone;
@property (strong, nonatomic) NSString *companyFax;
@property (strong, nonatomic) NSString *companyLogo;
@property (strong, nonatomic) NSString *companyStateID;
@property (strong, nonatomic) NSString *companyAreaID;
@property (strong, nonatomic) NSString *companyAddressAr;
@property (strong, nonatomic) NSString *companyAddressEn;
@property (strong, nonatomic) NSString *companyDescAr;
@property (strong, nonatomic) NSString *companyDescEn;
@property (strong, nonatomic) NSString *companyOverallSort;
@property (strong, nonatomic) NSString *companyProductSort;
@property (strong, nonatomic) NSString *companyOrderSort;
@property (strong, nonatomic) NSString *companyBigLogo;
@property (strong, nonatomic) NSString *companyAboutUsLogo;
@property (strong, nonatomic) NSString *companySloganAr;
@property (strong, nonatomic) NSString *companySloganEn;
@property (strong, nonatomic) NSString *companyBranches;
@property (strong, nonatomic) NSString *companyOffers;
@end
