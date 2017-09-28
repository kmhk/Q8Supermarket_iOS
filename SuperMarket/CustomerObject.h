//
//  CustomerObject.h
//  SuperMarket
//
//  Created by phoenix on 12/6/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerObject : NSObject
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *Mobile;
@property (nonatomic, strong) NSString *Email;
@property (nonatomic, strong) NSString *StateID;
@property (nonatomic, strong) NSString *AreaID;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *Username;
@property (nonatomic, strong) NSString *Password;
@property (nonatomic, strong) NSString *MobileID;
@property (nonatomic, strong) NSString *MobileType;
@property (nonatomic, strong) NSString *InsertDate;
@property (nonatomic, strong) NSString *IsActive;
@property (nonatomic, strong) NSString *UserType;
@property (nonatomic, strong) NSString *AccessToken;
@end
