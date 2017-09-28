//
//  MyAccountViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OAuth.h"
#import "OAuth+UserDefaults.h"
#import "OAuthConsumerCredentials.h"
#import "TwitterDialog.h"
@interface MyAccountViewController : UIViewController<TwitterDialogDelegate, TwitterLoginDialogDelegate,UITextFieldDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
    OAuth *oAuth;
}
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnGmail;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

- (IBAction)onBtnList:(id)sender;
- (IBAction)onForgot:(id)sender;
- (IBAction)onBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)onBtnGmail:(id)sender;
- (IBAction)onBtnFacebook:(id)sender;
- (IBAction)onBtnTwitter:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
- (IBAction)onBtnLogin:(id)sender;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;

@end
