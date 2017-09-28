//
//  MyListViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MyListObject.h"
#import "MyListItem.h"
@interface MyListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UIButton *lb_sent;
@property (weak, nonatomic) IBOutlet UIButton *lb_inbox;
@property (weak, nonatomic) IBOutlet UILabel *lb_header;
- (IBAction)onBtnAdd:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnSent:(id)sender;
- (IBAction)onBtnInbox:(id)sender;
- (IBAction)onBtnRemove:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myListTable;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property (nonatomic, strong) NSMutableArray *arrayItem;
@property (nonatomic, strong) NSMutableArray *arrayForTable;
@property (nonatomic, assign) BOOL listStatus;
@property (nonatomic, strong) MyListObject *listObj;
@property (nonatomic, strong) MyListItem *myItem;
@property (nonatomic, assign) int listIndex;
- (IBAction)Done:(id)sender;
- (IBAction)btnSearch:(id)sender;

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@property(nonatomic, assign) 	int removeIndex;

@end
