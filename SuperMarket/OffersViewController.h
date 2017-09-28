//
//  OffersViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CompanyObject.h"
@interface OffersViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
- (IBAction)select_offers:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backImg;
@property (nonatomic, strong) NSMutableArray *logoArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCompanies;

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, strong) CompanyObject *companyObj;
@property(nonatomic, assign) bool errEncounter;

@property (nonatomic, strong) UIImageView *statusView;
@end
