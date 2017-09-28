//
//  SearchResultViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/24/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import <sqlite3.h>
@interface SearchResultViewController : UIViewController{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (nonatomic, strong) NSMutableArray *arrayProductsWithCategory;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UITableView *table_Products;


- (IBAction)onBtnFavorite:(id)sender;

- (IBAction)onBtnPurchase:(id)sender;




- (IBAction)onFriend:(id)sender;
- (IBAction)onBack:(id)sender;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) ProductObject *productObj;
@end
