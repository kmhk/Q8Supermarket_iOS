//
//  AboutViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/2/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CompanyObject.h"
#import "Setting.h"
#import "AsyncImageView.h"
#import <MessageUI/MessageUI.h>
@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
@property (weak, nonatomic) IBOutlet UILabel *lbBranch;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbFax;
@property (weak, nonatomic) IBOutlet UILabel *lbTel;
- (IBAction)onBranch:(id)sender;
- (IBAction)btnEMail:(id)sender;
- (IBAction)OnBtnTelNum:(id)sender;

- (IBAction)onBtnBack:(id)sender;

- (IBAction)onBtnShare:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *lb_company_summary;
@property (weak, nonatomic) IBOutlet UIView *view_info;

@property (weak, nonatomic) IBOutlet UILabel *lb_aboutus;

@property (weak, nonatomic) IBOutlet UILabel *lb_telephone;
@property (weak, nonatomic) IBOutlet UILabel *lb_fax;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (nonatomic, strong) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_branches;
@property (weak, nonatomic) IBOutlet AsyncImageView *img_companyLogo;
@property (nonatomic, strong) CompanyObject *selCompany;
@end
