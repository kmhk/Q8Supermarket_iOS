//
//  SearchViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"
#import <sqlite3.h>
@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITabBarControllerDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCan;
- (IBAction)onDone:(id)sender;
- (IBAction)onBtnSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_pickerTitle;
- (IBAction)onCancelButton:(id)sender;
@property (nonatomic, strong) NSMutableArray *selectedStatus;
@property (weak, nonatomic) IBOutlet UIButton *bnSearch;
@property (weak, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lb_header;
@property (nonatomic, strong) NSMutableArray *search_list;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSString *supermarketID;
@property (nonatomic, strong) NSString *mainCatID;
@property (nonatomic, strong) NSString *subCatID;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *priceFrom;
@property (nonatomic, strong) NSString *priceTo;
@property (nonatomic, strong) NSString *offerID;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, assign) int selectType;
@property (nonatomic, assign) int myLang;
@property (nonatomic, strong) ProductObject *productObj;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) int selIndex;


@end
