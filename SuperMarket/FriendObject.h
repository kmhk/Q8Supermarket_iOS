//
//  FriendObject.h
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendObject : NSObject
@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSString *friendName;
@property (nonatomic, strong) NSString *friendMobile;
@property (nonatomic, strong) NSString *friendEmail;
@property (nonatomic, strong) NSString *friendCity;
@property (nonatomic, assign) BOOL isPending;
@end
