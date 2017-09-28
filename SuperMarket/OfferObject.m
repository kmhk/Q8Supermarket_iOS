//
//  OfferObject.m
//  SuperMarket
//
//  Created by phoenix on 11/15/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "OfferObject.h"

@implementation OfferObject
- (id)init
{
    self = [super init];
    self.offerBranchList = @"";
    self.offerCompanyID = @"";
    self.offerDescAr = @"";
    self.offerDescEn = @"";
    self.offerEndDate = @"";
    self.offerID = @"";
    self.offerIsActive = @"";
    self.offerlastUpdateTime = @"";
    self.offerPhotoURL = @"";
    self.offerProducts = @"";
    self.offerStartDate = @"";
    self.offerTitleAr = @"";
    self.offerTitleEn = @"";
    return self;
}

@end
