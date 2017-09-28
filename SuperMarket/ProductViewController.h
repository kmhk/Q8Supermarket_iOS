//
//  ProductViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/16/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "OfferObject.h"
#import "ProductObject.h"
#import "ProductsWithCategory.h"
#import <sqlite3.h>
@interface ProductViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbTo;
@property (weak, nonatomic) IBOutlet UILabel *lbFrom;
- (IBAction)onBtnShareIcon:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table_Products;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lb_OfferTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_OfferDesc;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UILabel *lb_remainDays;

@property (nonatomic, strong) NSDate *offerStartDate;
@property (nonatomic, strong) NSDate *offerStopDate;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *progressBarBg;

@property (weak, nonatomic) IBOutlet UILabel *lb_startDate;
@property (weak, nonatomic) IBOutlet UILabel *lb_endDate;
@property (nonatomic, strong) OfferObject *selOffer;
@property (nonatomic, strong) NSMutableArray *arrayProduct;
@property (nonatomic, strong) ProductObject *productObj;

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property (nonatomic, strong) NSMutableArray *arrayProductsWithCategory;
@property (nonatomic, strong) NSString *companyName;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSearch:(id)sender;
- (IBAction)onBtnShare:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnFavorite:(id)sender;
- (IBAction)onBtnPurchase:(id)sender;

@end
