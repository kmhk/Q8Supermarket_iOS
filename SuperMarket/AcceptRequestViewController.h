//
//  AcceptRequestViewController.h
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
@interface AcceptRequestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_mobile;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;

@property (weak, nonatomic) IBOutlet UIButton *btnRefuse;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;

- (IBAction)onRefuse:(id)sender;
- (IBAction)onAccept:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
@property (nonatomic, strong) FriendObject *obj;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@property (nonatomic, strong) UIViewController *prevView;
@end
