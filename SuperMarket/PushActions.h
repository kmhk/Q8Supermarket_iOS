//
//  PushActions.h
//  SuperMarket
//
//  Created by phoenix on 3/4/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"
#import "State.h"
#import "Measures.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "CompanyObject.h"
#import "BranchObject.h"
#import <sqlite3.h>
@interface PushActions : NSObject
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property (nonatomic, strong) Area *areaObj;
@property (nonatomic, strong) State *cityObj;
@property (nonatomic, strong) Measures *measureObj;
@property (nonatomic, strong) MainCategory *mainObj;
@property (nonatomic, strong) SubCategory *subObj;
@property (nonatomic, strong) CompanyObject *comObj;
@property (nonatomic, strong) BranchObject *braObj;
@property (nonatomic, assign) int pushType;
-(void)pushCompany;
-(void)pushBranch;
-(void)pushMainCategory;
-(void)pushSubCategory;
-(void)pushCity;
-(void)pushArea;
-(void)pushMeasure;

@end
