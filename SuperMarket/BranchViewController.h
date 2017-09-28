//
//  BranchViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BranchObject.h"
#import "CompanyObject.h"
#import <sqlite3.h>
@interface BranchViewController : UIViewController<MKMapViewDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (nonatomic, strong) CompanyObject *selCompany;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property (nonatomic, strong) NSMutableArray *Branches;
@property (nonatomic, strong) BranchObject *branchObj;
- (IBAction)onBack:(id)sender;

@end
