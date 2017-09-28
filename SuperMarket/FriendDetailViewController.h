//
//  FriendDetailViewController.h
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
@interface FriendDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbtitle;
@property (weak, nonatomic) IBOutlet UILabel *lbemail;
@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbMobile;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
- (IBAction)onRemove:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_Name;
@property (weak, nonatomic) IBOutlet UILabel *lb_mobileno;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UILabel *lb_city;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;
@property (nonatomic, strong) FriendObject *obj;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@end
