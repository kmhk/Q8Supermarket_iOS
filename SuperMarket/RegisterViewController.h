//
//  RegisterViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UIImageView *img_arrow;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *tCityView;
@property (weak, nonatomic) IBOutlet UIView *tUserView;
@property (weak, nonatomic) IBOutlet UIView *tPasswordView;
@property (weak, nonatomic) IBOutlet UIView *tConfirmView;

@property (weak, nonatomic) IBOutlet UIView *tEmailView;

@property (weak, nonatomic) IBOutlet UIButton *btn_city;

@property (weak, nonatomic) IBOutlet UIView *tMobileNoView;
@property (weak, nonatomic) IBOutlet UIView *tNameView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_Register;
@property (weak, nonatomic) IBOutlet UILabel *lb_pickerTitle;
- (IBAction)onDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (nonatomic, strong) NSMutableArray *cityArray;
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnSelectCity:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tName;
@property (weak, nonatomic) IBOutlet UITextField *tMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *tSelectCity;
@property (weak, nonatomic) IBOutlet UITextField *tEmail;
@property (weak, nonatomic) IBOutlet UITextField *tUsername;
@property (weak, nonatomic) IBOutlet UITextField *tPassword;
@property (weak, nonatomic) IBOutlet UITextField *tConfirm;
@property (nonatomic, strong) NSString *tmobileID;
@property (nonatomic, strong) NSString *tareaID;
@property (nonatomic, strong) NSString *tcityID;
@property (nonatomic, strong) NSString *taddress;
@property (nonatomic, strong) NSString *tmobileType;
@property (nonatomic, strong) NSString *tuserType;
@property (nonatomic, strong) NSString *taccessToken;
@property (nonatomic, assign) int selIndex;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;

@end
