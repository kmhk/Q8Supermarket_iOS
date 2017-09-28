//
//  SendRequestViewController.h
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendRequestViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
- (IBAction)onSendRequest:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *lbOR;
@property (weak, nonatomic) IBOutlet UILabel *lbOR1;
@property (weak, nonatomic) IBOutlet UITextField *tFriendName;
@property (weak, nonatomic) IBOutlet UITextField *tEmail;
@property (weak, nonatomic) IBOutlet UITextField *tMobile;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property (weak, nonatomic) IBOutlet UIButton *btnSendRequest;
@property(nonatomic, assign) 	BOOL recordResults;
@property (nonatomic, assign) BOOL errStatus;
@end
