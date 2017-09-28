//
//  NewListViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface NewListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_header;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIImageView *img_header;
@property (weak, nonatomic) IBOutlet UIButton *btn_send;
@property (weak, nonatomic) IBOutlet UIButton *btn_can;

- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnDone:(id)sender;
- (IBAction)onBtnAdd:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onCancelMeasure:(id)sender;
- (IBAction)onBtnPlus:(id)sender;
- (IBAction)onAddMeasure:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *subcatName;
@property (weak, nonatomic) IBOutlet UITextField *tListName;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;
@property (weak, nonatomic) IBOutlet UIView *toFriendView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *addlistTable;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;
@property (nonatomic, strong) NSMutableArray *arrayMyList;
@property (nonatomic, strong) NSMutableArray *arraySubCategories;
@property (nonatomic, strong) NSMutableArray *arrayMeasure;
@property (nonatomic, strong) NSMutableArray *arrayQuantity;
@property (nonatomic, strong) NSMutableArray *arrayCheckedFriends;
@property (weak, nonatomic) IBOutlet UIPickerView *measurePicker;
@property (nonatomic, assign) int selQuantyIndex;
@property (nonatomic, assign) int selMeasureIndex;
@property (nonatomic, assign) int selItem;
@property (nonatomic, assign) int mainNum;
@property (nonatomic, strong) NSString *friendIDs;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@end
