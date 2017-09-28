//
//  BranchObject.h
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchObject : NSObject
@property (nonatomic, strong) NSString *branchID;
@property (nonatomic, strong) NSString *NameAr;
@property (nonatomic, strong) NSString *NameEn;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *Phone;
@property (nonatomic, strong) NSString *Fax;
@property (nonatomic, strong) NSString *Sort;
@property (nonatomic, strong) NSString *StateID;
@property (nonatomic, strong) NSString *AreaID;
@property (nonatomic, strong) NSString *AddressEn;
@property (nonatomic, strong) NSString *AddressAr;
@property (nonatomic, strong) NSString *CompanyID;
@property (nonatomic, strong) NSString *Latitude;
@property (nonatomic, strong) NSString *Longitude;
@end
