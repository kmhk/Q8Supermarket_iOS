//
//  CompanyViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyObject.h"
#import "AsyncImageView.h"
#import "OfferObject.h"
#import <sqlite3.h>
@interface CompanyViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (nonatomic, strong) UIImageView *statusView;

@property (weak, nonatomic) IBOutlet UIButton *btnAbout;
- (IBAction)onCurrentOffers:(id)sender;
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSearch:(id)sender;
- (IBAction)onBtnShare:(id)sender;
- (IBAction)onBtnAbout:(id)sender;
- (IBAction)onExpiredOffers:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnExpiredOffers;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentOffers;

@property (weak, nonatomic) IBOutlet UIView *tablesView;
@property (weak, nonatomic) IBOutlet UIImageView *expOfferSection;
@property (weak, nonatomic) IBOutlet UITableView *expireTable;
@property (weak, nonatomic) IBOutlet UIImageView *curOfferSection;

@property (weak, nonatomic) IBOutlet UITableView *currentTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (nonatomic, strong) CompanyObject *selCompany;
@property (weak, nonatomic) IBOutlet AsyncImageView *BigLogo;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) bool errEncounter;
@property(nonatomic, strong) NSMutableArray *currentofferArray;
@property(nonatomic, strong) NSMutableArray *currentArray;
@property(nonatomic, strong) NSMutableArray *expiredofferArray;
@property(nonatomic, strong) NSMutableArray *expiredArray;
@property(nonatomic, strong) OfferObject *offerObj;
@property (nonatomic, strong) BranchObject *branchObj;
@end
